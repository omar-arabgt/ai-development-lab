/// Business pricing rules for the car market — the "precious cargo"
/// of this drill. Imagine three weeks of tuning went into these numbers.
class PricingRules {
  static const double vatRate = 0.16;
  static const double dealerCommission = 0.02;
  static const double transferFee = 150;
  static const double hotDealThreshold = 0.10;

  static double finalPrice(double basePrice) {
    return basePrice * (1 + vatRate + dealerCommission) + transferFee;
  }
}
