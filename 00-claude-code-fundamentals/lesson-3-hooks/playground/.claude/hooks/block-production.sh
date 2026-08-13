#!/bin/bash
# 🛡️ Production guard — PreToolUse hook on the Bash tool
# Receives JSON with command details via stdin, then decides: allow or block

input=$(cat)

# Content inspection: any reference to production, in any form → block
if echo "$input" | grep -qiE 'production|prod-db|prod\.'; then
  echo "🚫 Blocked by production guard: this command references the production environment." >&2
  echo "Rule: AI never touches production — no exceptions." >&2
  exit 2   # exit 2 = block the operation; the message above goes back to the AI
fi

exit 0     # exit 0 = allow
