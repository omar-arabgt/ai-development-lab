#!/bin/bash
# 🚦 Quality gate — PostToolUse hook on Edit/Write
# After any edit to a Dart file: run analysis automatically;
# if issues are found, report back to the AI so it fixes them

input=$(cat)

# Only check Dart file edits
echo "$input" | grep -q '\.dart' || exit 0

cd "$CLAUDE_PROJECT_DIR" || exit 0
result=$(dart analyze --fatal-infos 2>&1)

if [ $? -ne 0 ]; then
  echo "⛔ Quality gate: dart analyze found issues after your edit — fix them before continuing:" >&2
  echo "$result" | tail -8 >&2
  exit 2   # The AI sees this report and fixes the issues — self-healing loop
fi

exit 0
