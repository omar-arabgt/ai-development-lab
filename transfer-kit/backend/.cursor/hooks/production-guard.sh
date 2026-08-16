#!/bin/bash
# Production red line for Cursor agents — mirrors .claude/settings.json hooks.
input=$(cat)
cmd=$(echo "$input" | python3 -c "import json,sys; print(json.load(sys.stdin).get('command',''))" 2>/dev/null)

if echo "$cmd" | grep -qiE 'DATABASE_URL=|--settings[= ][^ ]*(prod|staging)|(psql|pg_dump|pg_restore|mysql|mysqldump) .*(prod|staging|arabgt\.com)|manage\.py (shell|dbshell|flush)'; then
  cat <<JSON
{"permission": "deny", "user_message": "BLOCKED by production red line: this command points at production/staging data or a forbidden manage.py command.", "agent_message": "Blocked: AI work targets the local docker-compose stack only. Never touch production/staging databases or run manage.py shell/dbshell/flush."}
JSON
  exit 0
fi
echo '{"permission": "allow"}'
