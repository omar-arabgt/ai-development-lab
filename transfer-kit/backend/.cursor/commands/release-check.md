# Release Check — GO / NO-GO

Run the full pre-release gate for this repo exactly as defined in
`.claude/skills/release-check/SKILL.md` (same policy applies here):
analyzer/checks, FULL test suite, branch-flow check, and the forbidden-paths
diff scan. Finish with ONE verdict — GO or NO-GO — listing every failed gate
with exact evidence. Never build, upload, or deploy anything.
