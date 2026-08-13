/// Badge shown on a listing card when a car's price changes.
class PriceDropBadge {
  /// TASK: give a badge when the price drops.
  /// (Deliberately vague — the real requirements live in specs/price-drop-badge.md.)
  static String compute(double oldPrice, double newPrice) {
    if (oldPrice <= 0 || newPrice < 0) {
      throw ArgumentError('prices must be non-negative and oldPrice must be positive');
    }
    if (newPrice >= oldPrice) return '';
    final dropRatio = (oldPrice - newPrice) / oldPrice;
    return dropRatio >= 0.10 ? 'HOT DEAL' : 'PRICE DROP';
  }
}
