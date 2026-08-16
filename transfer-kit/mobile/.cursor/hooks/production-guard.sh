#!/bin/bash
# Production red line for Cursor agents — mirrors .claude/settings.json hooks.
input=$(cat)
cmd=$(echo "$input" | python3 -c "import json,sys; print(json.load(sys.stdin).get('command',''))" 2>/dev/null)

if echo "$cmd" | grep -qiE 'main_prod|environments/prod|fastlane .*(release|deploy|beta)|xcrun altool|upload.*(appstore|play)|flutter build (appbundle|ipa)'; then
  cat <<JSON
{"permission": "deny", "user_message": "BLOCKED by production red line: production builds, entrypoints, and store uploads are human-only.", "agent_message": "Blocked: releases go through the dev -> qa -> staging -> production promotion chain. Never build or run the prod target."}
JSON
  exit 0
fi
echo '{"permission": "allow"}'
