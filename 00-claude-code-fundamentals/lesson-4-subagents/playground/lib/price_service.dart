// Price service for the demo car marketplace.
// ⚠️ This file contains 4 DELIBERATE issues for the subagents to find.

class PriceService {
  // Issue 1: hardcoded secret (fake value, planted for the security-auditor)
  final String apiKey = 'sk_live_FAKE1234567890abcdef';

  // Issue 2: possible division by zero when monthsCount is 0
  double monthlyInstallment(double totalPrice, int monthsCount) {
    return totalPrice / monthsCount;
  }

  double applyDiscount(double price, double percentage) {
    // Issue 3: unused variable
    var oldPrice = price;
    return price - (price * percentage / 100);
  }

  void logPrice(double price) {
    // Issue 4: print in production code instead of a logger
    print('Final price: $price');
  }
}
