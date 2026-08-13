#!/bin/bash
# 🚦 بوابة الجودة — PostToolUse hook على Edit/Write
# بعد أي تعديل ملف dart: فحص أوتوماتيك، وإذا في مشاكل بترجع للـ AI ليصلحها

input=$(cat)

# منفحص بس إذا التعديل كان على ملف dart
echo "$input" | grep -q '\.dart' || exit 0

cd "$CLAUDE_PROJECT_DIR" || exit 0
result=$(dart analyze --fatal-infos 2>&1)

if [ $? -ne 0 ]; then
  echo "⛔ بوابة الجودة: dart analyze لقى مشاكل بعد تعديلك — صلّحها قبل ما تكمل:" >&2
  echo "$result" | tail -8 >&2
  exit 2   # الـ AI بيشوف التقرير وبيصلح — self-healing loop
fi

exit 0
