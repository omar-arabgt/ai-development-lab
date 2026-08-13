# Spec: Loyalty Points

> NOTE FOR THE LESSON: this spec is DELIBERATELY incomplete.
> It looks reasonable at first read — the holes only show when you
> try to implement it. Do not "fix" it here; the exercise is to
> surface its open questions first.

## Goal
Reward buyers with loyalty points on every completed car purchase.

## API
`PointsCalculator.earn(double purchaseAmount, DateTime purchaseDate) -> int`

## Behavior

- Buyers earn **1 point per 100 JOD** of the purchase amount.
- Purchases made **on the weekend earn double points**.
- Points are always a whole number.

## Out of scope
- Redeeming or expiring points.
- Points history and storage.
