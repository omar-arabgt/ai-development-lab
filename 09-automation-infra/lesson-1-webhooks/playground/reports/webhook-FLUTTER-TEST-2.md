# Webhook Report — FLUTTER-TEST-2

**Source**: Sentry alert webhook
**Org**: sentrytest-7x
**Project**: flutter-test
**Issue**: [FLUTTER-TEST-2](https://sentrytest-7x.sentry.io/issues/FLUTTER-TEST-2)
**Status**: unresolved (new)
**First seen**: 2026-08-14T00:24:51.872Z · **Last seen**: 2026-08-14T00:27:39.000Z · **Occurrences**: 2

## Error

```
FormatException: Unparseable branch count: "N/A"
```

Culprit: `import_dealer_contacts.dart` in `main`, raised at `import_dealer_contacts.dart:33:69`.

## Root Cause

`04-sentry-autofix/lesson-1-sentry-eyes/playground/bin/import_dealer_contacts.dart` imports a hardcoded
`partnerFeed` list where the `branches` field is expected to be a numeric string. One entry
(`Zarqa Cars`) has `branches: 'N/A'` (line 12) — the partner feed sometimes sends a non-numeric
placeholder instead of a count.

The import loop parses `branches` with `int.tryParse(rawBranches)` (line 30), which returns `null`
for `"N/A"` since it isn't a valid integer. The `null` case is detected and handled by constructing a
`FormatException` and reporting it to Sentry via `Sentry.captureException` (lines 31–34) — so the
capture itself is intentional/expected behavior, not a bug in the reporting path. The exception simply
documents that the "Zarqa Cars" record was skipped due to unparseable input.

This mirrors the sibling script `import_listings.dart`, which already handles the analogous problem
(non-numeric price strings like `"12,500 JOD"`) gracefully via a `parsePrice()` helper that strips
thousands separators/currency text and extracts the numeric portion with a regex, returning `null`
only when no number can be recovered at all. `import_dealer_contacts.dart` has no equivalent
tolerance — any non-numeric `branches` value (not just `"N/A"`) is treated as fully unparseable.

## Affected Code

- `04-sentry-autofix/lesson-1-sentry-eyes/playground/bin/import_dealer_contacts.dart:29-36`
  - Line 12: `partnerFeed` entry with `branches: 'N/A'`
  - Line 30: `int.tryParse(rawBranches)` — fails on non-numeric input
  - Line 33: `FormatException` construction/capture (stacktrace-reported line)

## Proposed Fix (not applied)

Treat `"N/A"` (and similar known "no data" placeholders) as a legitimate "unknown branch count"
signal rather than an error condition, since it's an expected value the partner feed sends —
not malformed data:

1. Add an explicit check for known placeholder values (e.g. `"N/A"`, case-insensitive) before
   attempting `int.tryParse`, and skip/record those dealers without raising a `FormatException`
   or calling `Sentry.captureException` — log/print an informational message instead.
2. Keep `Sentry.captureException` reserved for genuinely malformed values (e.g. `"abc"`, empty
   string) that don't match a known placeholder, so real data-quality problems still surface in
   Sentry.
3. Optionally factor the "known missing-data marker" check into a small helper (analogous to
   `parsePrice()` in `import_listings.dart`) so both import scripts share consistent tolerance
   logic for partner feed quirks.

This would eliminate the noisy/expected `"N/A"` alert while preserving Sentry visibility for
actual unparseable data.
