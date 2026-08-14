// Imports dealer showroom records from the partner feed.
// One record carries a non-numeric branch count — this planted crash is
// the raw material for the lesson-3 automated fix pipeline.
import 'dart:io';

import 'package:sentry/sentry.dart';

const partnerFeed = [
  {'name': 'Amman Motors', 'branches': '3'},
  {'name': 'Irbid Auto City', 'branches': '5'},
  // Planted bug: the partner sometimes sends "N/A" instead of a number.
  {'name': 'Zarqa Cars', 'branches': 'N/A'},
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
    for (final dealer in partnerFeed) {
      final branches = int.parse(dealer['branches']!); // boom on "N/A"
      print('Registered ${dealer['name']} with $branches branches');
    }
  } catch (exception, stackTrace) {
    await Sentry.captureException(exception, stackTrace: stackTrace);
    stderr.writeln('Dealer import crashed — the error was reported to Sentry.');
  } finally {
    await Sentry.close();
  }
}
