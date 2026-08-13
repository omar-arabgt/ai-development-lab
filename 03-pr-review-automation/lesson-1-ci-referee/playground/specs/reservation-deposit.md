# Spec: Reservation Deposit

## Goal
Compute the deposit a buyer pays online to reserve a car before visiting the showroom.

## API
`ReservationDeposit.compute(double carPrice) -> double`

## Behavior (acceptance criteria)

| # | Given | When | Then |
|---|-------|------|------|
| AC1 | a normal car | 5% of `carPrice` is between 500 and 2000 | deposit = `0.05 * carPrice` |
| AC2 | a cheap car | 5% of `carPrice` is below 500 | deposit = `500` (minimum) |
| AC3 | an expensive car | 5% of `carPrice` is above 2000 | deposit = `2000` (maximum) |
| AC4 | boundaries | 5% is exactly 500 (carPrice 10000) or exactly 2000 (carPrice 40000) | the exact value — no clamping needed |
| AC5 | invalid input | `carPrice` <= 0 or NaN | throw `ArgumentError` |

## Edge cases
- carPrice 9999.99 -> 5% = 499.9995 -> minimum kicks in -> 500.
- carPrice 40000.01 -> 5% = 2000.0005 -> maximum kicks in -> 2000.

## Out of scope
- Refund policy, payment processing, currency formatting.
