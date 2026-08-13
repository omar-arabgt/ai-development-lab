/// Validates car plate numbers entered by sellers.
class PlateValidator {
  /// TASK: return true when [plate] matches the format "NN-NNNNN"
  /// (2 digits, a dash, then 5 digits), e.g. "10-12345".
  /// Anything else (wrong lengths, letters, missing dash) returns false.
  static bool isValid(String plate) {
    return RegExp(r'^\d{2}-\d{5}$').hasMatch(plate);
  }
}
