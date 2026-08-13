# Spec: Loyalty Points

## Goal
Reward buyers with loyalty points on every completed car purchase.

## API
`PointsCalculator.earn(double purchaseAmount, DateTime purchaseDate) -> int`

## Behavior (acceptance criteria)

| # | Given | When | Then |
|---|-------|------|------|
| AC1 | a weekday purchase | `purchaseDate` (server-local time) is not Friday or Saturday | points = round-half-up(`purchaseAmount` / 100) |
| AC2 | a weekend purchase | `purchaseDate` (server-local time) is Friday or Saturday | points = `floor(purchaseAmount / 100) * 2` |
| AC3 | float precision | `purchaseAmount` has more than 3 decimal places | round `purchaseAmount` to 3 decimal places first, then apply AC1/AC2 |
| AC4 | a large purchase | computed points exceed 100 | cap the result at `100`, regardless of weekday/weekend |
| AC5 | invalid input | `purchaseAmount` is negative or NaN | return `0` |
| AC6 | boundary | `purchaseAmount / 100` has a fractional part of exactly `0.5` on a weekday | round up (round-half-up), e.g. 50 JOD -> 1 point |

## Edge cases
- 50 JOD on a weekday -> 0.5 -> round-half-up -> **1 point** (sub-100 JOD purchases are NOT guaranteed 0 points).
- 150 JOD on a weekend -> `floor(1.5) * 2` = `1 * 2` = **2 points** (floor happens before doubling, not after).
- 0 JOD purchase -> **0 points**, and this is a valid result, not an AC5 invalid-input case.
- 99.9996 JOD -> rounds to 100.000 (AC3) -> **1 point**.
- 10100 JOD on a weekend -> `floor(101) * 2` = 202 -> capped to **100 points** (AC4).
- 10000 JOD on a weekday -> round-half-up(100) = exactly 100 -> at the cap, no clamping needed.
- Weekend is Friday/Saturday (matches the Jordanian work week, consistent with JOD as the currency) — NOT Saturday/Sunday.
- `purchaseAmount` is always assumed to already be in JOD; no currency conversion is performed.

## Out of scope
- Redeeming or expiring points.
- Points history and storage.
- Currency conversion (input is always JOD).
