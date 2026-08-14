# Spec: Sort search results by price

Ticket: [OMA-11](https://linear.app/omar-lab/issue/OMA-11/sort-search-results-by-price) — "sort search results by price"

## Context

Sales team request: buyers want to sort search results starting from the cheapest car. Some listings have no price (dealer asks buyers to call). Prices are in a single currency (JOD).

## Decisions (product owner, 2026-08-14)

1. The price lives under the `"price"` key and holds a `num` (int or double). The key may be missing or its value `null`.
2. Listings with no price go to the **end** of the result list, in their original relative order.
3. "No price" means: missing key, `null`, a non-numeric value, or any numeric value `<= 0`. Zero and negative numbers are never valid prices.
4. Single currency (JOD) — no currency normalization; out of scope.
5. Ties (equal valid prices) keep their original relative order (stable sort).
6. Ascending order only. Descending is a separate future ticket — out of scope.
7. Malformed/unexpected value types must never throw — they are treated as "no price" per rule 3.
8. `byPriceAscending` is a pure function: it returns a **new** list and never mutates the input list or its elements.
9. Out of scope: UI default sort selection, multi-key sorting (e.g. price + date), server-side sorting. This function only sorts one already-fetched page of results, client-side.

## Function contract

```dart
static List<Map<String, Object?>> byPriceAscending(
  List<Map<String, Object?>> results,
)
```

- **Input:** a list of result maps, each optionally containing a `"price"` key.
- **Output:** a new list containing the same map instances, reordered:
  - Entries with a valid price (`num`, `> 0`) first, ascending by price.
  - Entries with no valid price last, in their original relative order.
  - Entries within each group that are equal/indistinguishable for sorting purposes keep their original relative order (stable).
- **Never throws**, regardless of what `"price"` holds.
- **Never mutates** the input list or its map entries.

## Acceptance criteria

| # | Given | When | Then |
|---|-------|------|------|
| 1 | An empty list | `byPriceAscending` is called | Returns an empty list |
| 2 | A list where every entry has no valid price (missing key, `null`, non-numeric, zero, or negative) | `byPriceAscending` is called | Returns a list with all entries in their original relative order (unchanged) |
| 3 | A list mixing valid-priced and no-price entries, in shuffled order | `byPriceAscending` is called | Returns valid-priced entries first sorted ascending by price, followed by all no-price entries in their original relative order |
| 4 | Two or more entries share the same valid price | `byPriceAscending` is called | Those entries appear in the output in the same relative order as in the input (stable sort) |
| 5 | Entries with price `0` and negative prices (e.g. `-5`) mixed with valid-priced entries | `byPriceAscending` is called | The `0`/negative entries are treated as no-price and placed at the end, in original relative order among themselves and other no-price entries |
| 6 | Entries with malformed price values (e.g. `"cheap"`, `true`, `[1,2]`, `{}`) | `byPriceAscending` is called | No exception is thrown; those entries are treated as no-price and placed at the end |
| 7 | Entries with a missing `"price"` key vs. an explicit `"price": null` vs. `"price": 0` | `byPriceAscending` is called | All are treated identically as no-price and placed at the end, preserving their original relative order relative to each other |
| 8 | A list with both `int` and `double` valid prices (e.g. `10` and `9.5`) | `byPriceAscending` is called | They are compared numerically and ordered correctly regardless of Dart numeric type |
| 9 | A non-empty input list | `byPriceAscending` is called | The original input list (reference) and its map entries are unchanged after the call; the returned list is composed of the same map instances, reordered |
