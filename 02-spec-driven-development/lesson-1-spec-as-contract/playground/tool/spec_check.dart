// Neutral referee: checks the implementation against specs/price-drop-badge.md.
// Run from the playground root with: dart tool/spec_check.dart
import '../lib/price_drop_badge.dart';

int passed = 0;
int failed = 0;

void check(String id, String description, bool Function() test) {
  bool ok;
  try {
    ok = test();
  } catch (e) {
    ok = false;
  }
  if (ok) {
    passed++;
    print('PASS  $id  $description');
  } else {
    failed++;
    print('FAIL  $id  $description');
  }
}

bool throwsArgumentError(void Function() f) {
  try {
    f();
    return false;
  } on ArgumentError {
    return true;
  } catch (_) {
    return false;
  }
}

void main() {
  check('AC1a', 'equal prices -> no badge',
      () => PriceDropBadge.compute(10000, 10000) == '');
  check('AC1b', 'price increase -> no badge',
      () => PriceDropBadge.compute(10000, 12000) == '');
  check('AC2a', 'small drop (1%) -> PRICE DROP',
      () => PriceDropBadge.compute(10000, 9900) == 'PRICE DROP');
  check('AC2b', 'tiny drop -> PRICE DROP',
      () => PriceDropBadge.compute(10000, 9999.99) == 'PRICE DROP');
  check('AC3', 'big drop (20%) -> HOT DEAL',
      () => PriceDropBadge.compute(10000, 8000) == 'HOT DEAL');
  check('AC4', 'boundary: exactly 10% -> HOT DEAL',
      () => PriceDropBadge.compute(10000, 9000) == 'HOT DEAL');
  check('AC5a', 'oldPrice = 0 -> ArgumentError',
      () => throwsArgumentError(() => PriceDropBadge.compute(0, 5000)));
  check('AC5b', 'negative newPrice -> ArgumentError',
      () => throwsArgumentError(() => PriceDropBadge.compute(10000, -1)));
  check('AC5c', 'newPrice = 0 (free car) -> ArgumentError, not a 100% deal',
      () => throwsArgumentError(() => PriceDropBadge.compute(10000, 0)));

  print('');
  print('$passed passed, $failed failed');
  if (failed > 0) {
    print('SPEC VIOLATED — the implementation does not honor the contract.');
  } else {
    print('SPEC HONORED — implementation matches the contract.');
  }
}
