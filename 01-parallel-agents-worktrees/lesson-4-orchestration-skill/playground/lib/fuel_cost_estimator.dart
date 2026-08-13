/// Estimates monthly fuel cost shown on car detail pages.
class FuelCostEstimator {
  /// TASK: given [kmPerMonth], fuel consumption in [litersPer100Km],
  /// and [pricePerLiter], return the estimated monthly fuel cost.
  /// Throw an ArgumentError if any input is negative.
  static double monthlyCost(
    double kmPerMonth,
    double litersPer100Km,
    double pricePerLiter,
  ) {
    if (kmPerMonth < 0 || litersPer100Km < 0 || pricePerLiter < 0) {
      throw ArgumentError('Inputs must not be negative');
    }
    return (kmPerMonth / 100) * litersPer100Km * pricePerLiter;
  }
}
