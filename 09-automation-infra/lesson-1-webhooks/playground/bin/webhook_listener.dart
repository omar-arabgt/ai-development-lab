// The doorbell: a tiny local webhook listener. When an alert POST
// arrives, it wakes a headless Claude pipeline — no human in the loop.
// Run with: dart run bin/webhook_listener.dart   (from this playground dir)
// Set DRY_RUN=1 to print the pipeline command instead of running it.
import 'dart:convert';
import 'dart:io';

const port = 8787;

Future<void> main() async {
  final repoRoot = Directory.current.parent.parent.parent.path;
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, port);
  print('Doorbell armed: POST http://localhost:$port/sentry-alert');
  print('(DRY_RUN=${Platform.environment['DRY_RUN'] ?? '0'} — set 1 to only print the command)');

  await for (final request in server) {
    if (request.method != 'POST' || request.uri.path != '/sentry-alert') {
      request.response
        ..statusCode = 404
        ..write('unknown endpoint');
      await request.response.close();
      continue;
    }

    final body = await utf8.decoder.bind(request).join();
    final Map<String, dynamic> payload;
    try {
      payload = jsonDecode(body) as Map<String, dynamic>;
    } catch (_) {
      request.response
        ..statusCode = 400
        ..write('invalid JSON');
      await request.response.close();
      continue;
    }

    final issueId = payload['issue_id'] ?? 'UNKNOWN';
    final title = payload['title'] ?? 'no title';
    print('\n🔔 ${DateTime.now()} — webhook received: $issueId "$title"');

    request.response.write('accepted: waking the pipeline for $issueId');
    await request.response.close();

    final prompt =
        'A Sentry alert just arrived via webhook for issue $issueId: "$title". '
        'Fetch its details from the sentrytest lab org, investigate the code under '
        '04-sentry-autofix/lesson-1-sentry-eyes/playground, and write '
        '09-automation-infra/lesson-1-webhooks/playground/reports/webhook-$issueId.md '
        'with: root cause, affected code, and a proposed fix. Do NOT modify any code. '
        'Do NOT touch the arabgt org.';
    const allowed = 'mcp__sentry__*,Read,Glob,Grep,Write';

    if (Platform.environment['DRY_RUN'] == '1') {
      print('DRY RUN — would execute:\nclaude -p "<prompt>" --allowedTools "$allowed"');
      continue;
    }

    print('⚙️  waking headless pipeline...');
    final process = await Process.start(
      'claude',
      ['-p', prompt, '--allowedTools', allowed],
      workingDirectory: repoRoot,
      mode: ProcessStartMode.inheritStdio,
    );
    final exitCode = await process.exitCode;
    print(exitCode == 0
        ? '✅ pipeline finished — check reports/webhook-$issueId.md'
        : '❌ pipeline exited with code $exitCode');
  }
}
