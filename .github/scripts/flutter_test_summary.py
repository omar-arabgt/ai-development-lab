#!/usr/bin/env python3
"""Turns a `flutter test --file-reporter json:...` output into a markdown
test report appended to the GitHub run summary page."""
import json
import os
import sys

results_path = sys.argv[1]
platform = sys.argv[2] if len(sys.argv) > 2 else 'unknown'

names = {}
rows = []
passed = failed = 0

with open(results_path) as f:
    for line in f:
        try:
            event = json.loads(line)
        except json.JSONDecodeError:
            continue
        if event.get('type') == 'testStart':
            names[event['test']['id']] = event['test']['name']
        elif event.get('type') == 'testDone' and not event.get('hidden'):
            name = names.get(event['testID'], f"test {event['testID']}")
            if name.startswith('loading '):
                continue
            ok = event.get('result') == 'success'
            passed += ok
            failed += not ok
            rows.append(f"| {'✅' if ok else '❌'} | {name} |")

summary = os.environ.get('GITHUB_STEP_SUMMARY')
out = [
    f"## 📱 Journey report — {platform}",
    "",
    f"**{passed} passed, {failed} failed**",
    "",
    "| Result | Test |",
    "|---|---|",
    *rows,
    "",
]
report = '\n'.join(out)
if summary:
    with open(summary, 'a') as f:
        f.write(report + '\n')
print(report)
sys.exit(1 if failed else 0)
