# Release Check — GO / NO-GO

Run every gate below, then give ONE verdict: **GO** or **NO-GO** with reasons.

1. `flutter analyze` — zero errors tolerated.
2. `flutter test` — the FULL suite, all green.
3. Branch flow: current work must sit on a branch off `dev`, working tree clean,
   no commits directly on qa/staging/production.
4. Diff scan vs `dev`: the diff must NOT touch `lib/environments/prod/`, signing
   files (`key.properties`, `*.keystore`), `GoogleService-Info`, or
   `google-services.json`. Any hit = automatic NO-GO.
5. Version sanity: report the current `pubspec.yaml` version and whether it
   changed in this diff (informational).

Hard rules: NEVER build or upload anything — store builds and deploys are
human-only (hooks block them anyway). A NO-GO must list every failed gate with
exact evidence (file, test name, analyzer line). Never soften a NO-GO.
