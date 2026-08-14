// Imports dealer showroom records from the partner feed.
// One record carries a non-numeric branch count — this planted crash is
// the raw material for the lesson-3 automated fix pipeline.
import 'dart:io';

import 'package:sentry/sentry.dart';

const partnerFeed = [
  {'name': 'Amman Motors', 'branches': '3'},
  {'name': 'Irbid Auto City', 'branches': '5'},
  // The partner sometimes sends "N/A" instead of a number.
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
      final rawBranches = dealer['branches']!;
      final branches = int.tryParse(rawBranches);
      if (branches == null) {
        final error = FormatException('Unparseable branch count: "$rawBranches"');
        await Sentry.captureException(error, stackTrace: StackTrace.current);
        stderr.writeln('Skipping ${dealer['name']}: invalid branch count "$rawBranches"');
        continue;
      }
      print('Registered ${dealer['name']} with $branches branches');
    }
  } finally {
    await Sentry.close();
  }
}
