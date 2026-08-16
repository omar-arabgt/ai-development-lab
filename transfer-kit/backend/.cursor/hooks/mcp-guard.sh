#!/bin/bash
# Company MCP guard for Cursor — mirrors the Claude-side policy:
# Sentry company org is read-only; destructive Linear ops are human-only.
input=$(cat)

if echo "$input" | grep -qiE 'update_issue|resolve|assign' && echo "$input" | grep -qi 'arabgt'; then
  cat <<'JSON'
{"permission": "deny", "user_message": "BLOCKED: writes to the ArabGT Sentry org are read-only phase.", "agent_message": "Blocked by company guard: reading and analyzing Sentry is fine; resolving/assigning/modifying issues in the company org is not allowed yet."}
JSON
  exit 0
fi

if echo "$input" | grep -qiE 'delete_|merge_diff|save_project|save_release|save_milestone|save_status_update'; then
  cat <<'JSON'
{"permission": "deny", "user_message": "BLOCKED: destructive/structural Linear operations are human-only.", "agent_message": "Blocked by company guard: creating issues and comments is fine; deleting, merging, or changing projects/releases is not."}
JSON
  exit 0
fi
echo '{"permission": "allow"}'
