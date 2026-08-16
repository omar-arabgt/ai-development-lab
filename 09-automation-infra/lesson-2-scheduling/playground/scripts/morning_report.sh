#!/bin/bash
# Cron wrapper for the morning report (module 07, lesson 2).
# Cron runs with a bare environment — no login shell, no PATH magic —
# so the wrapper makes everything explicit: PATH, working dir, logging.
set -euo pipefail

export PATH="$HOME/.local/bin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin"

REPORT_DIR="$HOME/Documents/work/sandbox/ai-development-lab/07-analytics-posthog/lesson-2-morning-report"
cd "$REPORT_DIR"

echo "=== $(date) — cron woke the morning report ==="

claude -p "Write the daily morning report for the car-market lab. Gather: (1) from Sentry lab org (sentrytest): unresolved issues, anything new in the last 24h, and status of previously fixed ones; (2) from PostHog: yesterday's activity vs the 7-day average. Then write reports/morning-$(date +%Y-%m-%d-%H%M).md in Arabic with three sections: 🔴 شو انكسر, 📊 شو صار, ✅ توصية اليوم. Hedge on small samples. Do NOT touch the arabgt org." \
  --allowedTools "mcp__sentry__*,mcp__posthog__*,Write,Bash(date *)"

echo "=== $(date) — done ==="
