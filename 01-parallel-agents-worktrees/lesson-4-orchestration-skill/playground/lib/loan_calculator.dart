/// Computes monthly installments for car financing offers.
class LoanCalculator {
  /// TASK: return the monthly installment for a loan of [principal]
  /// paid over [months] with zero interest, rounded up to the nearest
  /// whole number. Throw an ArgumentError if [months] is not positive.
  static int monthlyInstallment(double principal, int months) {
    if (months <= 0) {
      throw ArgumentError.value(months, 'months', 'must be positive');
    }
    return (principal / months).ceil();
  }
}
