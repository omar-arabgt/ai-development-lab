/// Formats a raw price (JOD) for display in the car listing UI.
class CurrencyFormatter {
  /// TASK: format [amountInJod] as a display string with a thousands
  /// separator and the "JOD" suffix, e.g. 12500 -> "12,500 JOD".
  /// Negative amounts should throw an ArgumentError.
  static String format(num amountInJod) {
    if (amountInJod < 0) {
      throw ArgumentError.value(
        amountInJod,
        'amountInJod',
        'must not be negative',
      );
    }

    final digits = amountInJod.toInt().toString();
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(digits[i]);
    }

    return '$buffer JOD';
  }
}
