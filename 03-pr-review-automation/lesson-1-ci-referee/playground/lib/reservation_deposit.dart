/// Deposit paid online to reserve a car (see specs/reservation-deposit.md).
///
/// NOTE: unlike previous playgrounds, this one ships IMPLEMENTED and green —
/// the exercise is breaking it in a PR and watching the cloud referee catch it.
class ReservationDeposit {
  // 5% is the contracted rate — see specs/reservation-deposit.md (AC1).
  static const double _rate = 0.05;
  static const double _minimum = 500;
  static const double _maximum = 2000;

  static double compute(double carPrice) {
    if (carPrice.isNaN || carPrice <= 0) {
      throw ArgumentError.value(carPrice, 'carPrice', 'must be positive');
    }
    final deposit = _rate * carPrice;
    if (deposit < _minimum) return _minimum;
    if (deposit > _maximum) return _maximum;
    return deposit;
  }
}
