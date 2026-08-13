#!/bin/bash
# 🛡️ حارس production — PreToolUse hook على أداة Bash
# بيستلم JSON فيه تفاصيل الأمر عبر stdin، وبيقرر: يمرّق أو يمنع

input=$(cat)

# فحص المحتوى: أي إشارة لـ production بأي صياغة → منع
if echo "$input" | grep -qiE 'production|prod-db|prod\.'; then
  echo "🚫 مرفوض من حارس production: الأمر فيه إشارة لبيئة الإنتاج." >&2
  echo "القانون: الـ AI ما بيلمس production نهائياً — بلا استثناءات." >&2
  exit 2   # exit 2 = امنع العملية، والرسالة فوق بترجع للـ AI
fi

exit 0     # exit 0 = مرّق
