/// Formats engine displacement for listing cards.
class EngineSizeFormatter {
  /// TASK: format [cc] (engine size in cubic centimeters) as liters
  /// with one decimal place and an "L" suffix, e.g. 1998 -> "2.0L".
  /// Throw an ArgumentError if [cc] is not positive.
  static String format(int cc) {
    if (cc <= 0) {
      throw ArgumentError.value(cc, 'cc', 'must be positive');
    }
    final liters = cc / 1000;
    return '${liters.toStringAsFixed(1)}L';
  }
}
