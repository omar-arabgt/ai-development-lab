// Simulates the nightly job that imports car listings from a dealer feed.
// One listing carries a malformed price — the crash is the point: it must
// land in Sentry so the AI can find it there in the next lessons.
import 'dart:io';

import 'package:sentry/sentry.dart';

const dealerFeed = [
  {'model': 'Toyota Corolla 2022', 'price': '15500'},
  {'model': 'Kia Sportage 2023', 'price': '21000'},
  // Planted bug: the feed sometimes sends formatted prices.
  {'model': 'Hyundai Tucson 2024', 'price': '12,500 JOD'},
];

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
      final price = double.parse(listing['price']!); // boom on the third one
      print('Imported ${listing['model']} at $price JOD');
    }
  } catch (exception, stackTrace) {
    await Sentry.captureException(exception, stackTrace: stackTrace);
    stderr.writeln('Import crashed — the error was reported to Sentry.');
  } finally {
    await Sentry.close();
  }
}
