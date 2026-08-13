/// Computes sale prices for discounted car listings.
class DiscountCalculator {
  /// TASK: return [originalPrice] reduced by [discountPercent].
  /// Throw an ArgumentError if [discountPercent] is not between 0 and 100.
  /// Example: applyDiscount(10000, 15) -> 8500.
  static double applyDiscount(double originalPrice, double discountPercent) {
    if (discountPercent < 0 || discountPercent > 100) {
      throw ArgumentError.value(
        discountPercent,
        'discountPercent',
        'Must be between 0 and 100',
      );
    }
    return originalPrice * (1 - discountPercent / 100);
  }
}
