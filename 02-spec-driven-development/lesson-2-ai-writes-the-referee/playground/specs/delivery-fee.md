# Spec: Delivery Fee

## Goal
Compute the home-delivery fee for a purchased car, shown at checkout.

## API
`DeliveryFee.compute(double distanceKm, double carPrice) -> double`

## Behavior (acceptance criteria)

| # | Given | When | Then |
|---|-------|------|------|
| AC1 | an expensive car | `carPrice` >= 50000 | fee is `0` (free delivery, ANY distance) |
| AC2 | a nearby buyer | `distanceKm` <= 10 | fee is `0` (free delivery, ANY price) |
| AC3 | everything else | no free-delivery rule applies | fee is `0.5 * distanceKm`, but never below the minimum of `25` |
| AC4 | boundaries | `carPrice` exactly 50000, or `distanceKm` exactly 10 | still free — both thresholds belong to the free tier |
| AC5 | invalid input | `distanceKm` <= 0 or `carPrice` <= 0 | throw `ArgumentError` |

## Edge cases
- `distanceKm` = 50 -> formula gives exactly 25 -> fee 25 (minimum boundary).
- `distanceKm` = 20 -> formula gives 10 -> minimum kicks in -> fee 25.
- Both free rules true at once (cheap distance AND expensive car) -> still just 0.

## Out of scope
- Currency formatting and rounding (return the raw double).
- Scheduling, delivery windows, driver assignment.
