# Spec: Price Drop Badge

## Goal
Show a badge on the listing card when a car's price was reduced, so buyers spot deals instantly.

## API
`PriceDropBadge.compute(double oldPrice, double newPrice) -> String`

## Behavior (acceptance criteria)

| # | Given | When | Then |
|---|-------|------|------|
| AC1 | any listing | `newPrice` >= `oldPrice` (no drop, or increase) | return `""` (empty string — no badge) |
| AC2 | a price drop | drop is less than 10% of `oldPrice` | return `"PRICE DROP"` |
| AC3 | a price drop | drop is 10% of `oldPrice` or more | return `"HOT DEAL"` |
| AC4 | boundary | drop is exactly 10% | `"HOT DEAL"` (10% belongs to the hot tier) |
| AC5 | invalid input | `oldPrice` <= 0 or `newPrice` <= 0 | throw `ArgumentError` |

## Edge cases
- Equal prices -> `""` (AC1 covers it — equality is NOT a drop).
- Tiny drop (e.g. 10000 -> 9999.99) -> still `"PRICE DROP"`.
- Free cars do not exist: zero is invalid input, not a 100% discount.

## Out of scope
- Formatting/localization of the label (UI layer's job).
- Price history of more than one previous price.
