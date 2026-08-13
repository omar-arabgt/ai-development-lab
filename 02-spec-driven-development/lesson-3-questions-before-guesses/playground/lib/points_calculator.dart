/// Loyalty points earned on a completed purchase.
class PointsCalculator {
  /// See specs/loyalty-points.md — the spec is the only source of truth.
  static int earn(double purchaseAmount, DateTime purchaseDate) {
    if (purchaseAmount.isNaN || purchaseAmount < 0) {
      return 0;
    }

    // AC3: round to 3 decimals first to absorb double representation drift.
    final roundedAmount = ((purchaseAmount * 1000) + 0.5).floor() / 1000;

    final isWeekend = purchaseDate.weekday == DateTime.friday ||
        purchaseDate.weekday == DateTime.saturday;

    final points = isWeekend
        ? (roundedAmount / 100).floor() * 2
        : ((roundedAmount / 100) + 0.5).floor(); // round-half-up

    return points > 100 ? 100 : points;
  }
}
