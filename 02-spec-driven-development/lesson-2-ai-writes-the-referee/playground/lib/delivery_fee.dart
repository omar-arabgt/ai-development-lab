/// Home-delivery fee shown at checkout.
class DeliveryFee {
  static const double _freeDistanceKm = 10;
  static const double _freeCarPrice = 50000;
  static const double _minimumFee = 25;
  static const double _ratePerKm = 0.5;

  /// See specs/delivery-fee.md — the spec is the only source of truth.
  static double compute(double distanceKm, double carPrice) {
    if (distanceKm <= 0 || carPrice <= 0) {
      throw ArgumentError('distanceKm and carPrice must be positive');
    }
    if (carPrice >= _freeCarPrice || distanceKm <= _freeDistanceKm) {
      return 0;
    }
    final fee = _ratePerKm * distanceKm;
    return fee < _minimumFee ? _minimumFee : fee;
  }
}
