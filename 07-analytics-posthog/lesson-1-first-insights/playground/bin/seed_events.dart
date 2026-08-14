// Seeds one week of realistic car-market analytics events into PostHog,
// so the AI has real data to answer questions about in this lesson.
// Run with: dart run bin/seed_events.dart  (POSTHOG_PROJECT_KEY must be set)
import 'dart:convert';
import 'dart:io';
import 'dart:math';

const models = [
  'Toyota Corolla 2022',
  'Kia Sportage 2023',
  'Hyundai Tucson 2024',
  'Mercedes-Benz EQS 2024',
  'Toyota Camry 2023',
];

const searches = ['toyota', 'under 20000', 'suv 2024', 'electric', 'kia'];

Future<void> main() async {
  final apiKey = Platform.environment['POSTHOG_PROJECT_KEY'];
  if (apiKey == null || apiKey.isEmpty) {
    stderr.writeln('POSTHOG_PROJECT_KEY is not set — see the lesson README.');
    exit(64);
  }
  final host = Platform.environment['POSTHOG_HOST'] ?? 'https://us.i.posthog.com';

  // Seeded randomness: every run produces the same believable week.
  final rng = Random(2026);
  final now = DateTime.now().toUtc();
  final batch = <Map<String, Object?>>[];

  for (var day = 6; day >= 0; day--) {
    // iOS-heavy audience, busier toward the weekend — gives the AI
    // real patterns to discover, not uniform noise.
    final dayWeight = day <= 1 ? 3 : 2;
    for (var i = 0; i < 6 * dayWeight; i++) {
      final user = 'user_${1 + rng.nextInt(8)}';
      final platform = rng.nextInt(10) < 7 ? 'ios' : 'android';
      final timestamp = now
          .subtract(Duration(days: day, minutes: rng.nextInt(720)))
          .toIso8601String();

      final roll = rng.nextInt(10);
      final Map<String, Object?> event;
      if (roll < 5) {
        event = {
          'event': 'car_viewed',
          'properties': {'model': models[rng.nextInt(models.length)]},
        };
      } else if (roll < 8) {
        event = {
          'event': 'search_performed',
          'properties': {'query': searches[rng.nextInt(searches.length)]},
        };
      } else {
        event = {
          'event': 'reservation_requested',
          'properties': {'model': models[rng.nextInt(models.length)]},
        };
      }

      batch.add({
        ...event,
        'distinct_id': user,
        'timestamp': timestamp,
        'properties': {
          ...(event['properties'] as Map<String, Object?>),
          'platform': platform,
          r'$current_url': 'app://car-market',
        },
      });
    }
  }

  final client = HttpClient();
  final request = await client.postUrl(Uri.parse('$host/batch/'));
  request.headers.contentType = ContentType.json;
  request.write(jsonEncode({'api_key': apiKey, 'batch': batch}));
  final response = await request.close();
  final body = await response.transform(utf8.decoder).join();
  client.close();

  if (response.statusCode == 200) {
    print('Seeded ${batch.length} events across the last 7 days.');
    print('Open PostHog -> Activity to watch them arrive (can take ~1 min).');
  } else {
    stderr.writeln('PostHog rejected the batch (${response.statusCode}): $body');
    exit(1);
  }
}
