/// Badge shown on a listing card when a car's price changes.
class PriceDropBadge {
  /// TASK: give a badge when the price drops.
  /// (Deliberately vague — the real requirements live in specs/price-drop-badge.md.)
  static String compute(double oldPrice, double newPrice) {
    if (oldPrice <= 0) {
      throw ArgumentError('oldPrice must be positive');
    }
    if (newPrice <= 0) {
      throw ArgumentError('newPrice must be positive');
    }
    if (newPrice >= oldPrice) return '';

    final dropPercent = (oldPrice - newPrice) / oldPrice * 100;
    if (dropPercent >= 10) return 'HOT DEAL';
    return 'PRICE DROP';
  }
}
