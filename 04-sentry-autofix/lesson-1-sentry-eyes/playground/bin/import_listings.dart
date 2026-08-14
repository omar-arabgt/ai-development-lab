// Simulates the nightly job that imports car listings from a dealer feed.
// Dealer feeds sometimes send formatted prices (thousands separators,
// currency suffixes) instead of plain numeric strings.
import 'dart:io';

import 'package:sentry/sentry.dart';

const dealerFeed = [
  {'model': 'Toyota Corolla 2022', 'price': '15500'},
  {'model': 'Kia Sportage 2023', 'price': '21000'},
  {'model': 'Hyundai Tucson 2024', 'price': '12,500 JOD'},
];

/// Extracts a numeric price from a dealer feed value, tolerating thousands
/// separators and currency suffixes/prefixes (e.g. "12,500 JOD"). Returns
/// null when no number can be recovered.
double? parsePrice(String raw) {
  final cleaned = raw.replaceAll(',', '');
  final match = RegExp(r'-?\d+(\.\d+)?').firstMatch(cleaned);
  if (match == null) return null;
  return double.tryParse(match.group(0)!);
}

Future<void> main() async {
  final dsn = Platform.environment['SENTRY_DSN'];
  if (dsn == null || dsn.isEmpty) {
    stderr.writeln('SENTRY_DSN is not set. Export it first — see the lesson README.');
    exit(64);
  }

  await Sentry.init((options) {
    options.dsn = dsn;
    options.environment = 'lab';
  });

  try {
    for (final listing in dealerFeed) {
      final rawPrice = listing['price']!;
      final price = parsePrice(rawPrice);
      if (price == null) {
        final error = FormatException('Unparseable price: "$rawPrice"');
        await Sentry.captureException(error, stackTrace: StackTrace.current);
        stderr.writeln('Skipping ${listing['model']}: invalid price "$rawPrice"');
        continue;
      }
      print('Imported ${listing['model']} at $price JOD');
    }
  } finally {
    await Sentry.close();
  }
}
