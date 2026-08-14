// Standalone spec-conformance checker for DeliveryFee.compute.
// Run with: dart tool/spec_check.dart
//
// This is the referee: it checks an implementation against every
// acceptance criterion and edge case in specs/delivery-fee.md.
// It does not know or care how compute() is implemented.

import 'dart:io';

import '../lib/delivery_fee.dart';

const double _epsilon = 1e-9;

int _passed = 0;
int _failed = 0;

void _pass(String name) {
  _passed++;
  print('PASS  $name');
}

void _fail(String name, String detail) {
  _failed++;
  print('FAIL  $name');
  print('      $detail');
}

/// Checks that compute(distanceKm, carPrice) returns [expected].
void expectFee(String name, double distanceKm, double carPrice, double expected) {
  double actual;
  try {
    actual = DeliveryFee.compute(distanceKm, carPrice);
  } catch (e) {
    _fail(name,
        'compute($distanceKm, $carPrice) threw $e, expected result $expected');
    return;
  }
  if ((actual - expected).abs() <= _epsilon) {
    _pass(name);
  } else {
    _fail(name,
        'compute($distanceKm, $carPrice) => $actual, expected $expected');
  }
}

/// Checks that compute(distanceKm, carPrice) throws ArgumentError.
void expectArgumentError(String name, double distanceKm, double carPrice) {
  try {
    final actual = DeliveryFee.compute(distanceKm, carPrice);
    _fail(name,
        'compute($distanceKm, $carPrice) => $actual, expected ArgumentError to be thrown');
  } on ArgumentError {
    _pass(name);
  } catch (e) {
    _fail(name,
        'compute($distanceKm, $carPrice) threw ${e.runtimeType} ($e), expected ArgumentError');
  }
}

void main() {
  // --- AC1: expensive car (carPrice >= 50000) -> free, ANY distance ---
  expectFee('AC1 expensive car, short distance', 5, 50000, 0);
  expectFee('AC1 expensive car, long distance', 1000, 50000, 0);
  expectFee('AC1 very expensive car, huge distance', 500, 999999, 0);

  // --- AC2: nearby buyer (distanceKm <= 10) -> free, ANY price ---
  expectFee('AC2 nearby buyer, cheap car', 1, 100, 0);
  expectFee('AC2 nearby buyer, mid-price car', 10, 25000, 0);
  expectFee('AC2 nearby buyer, expensive-but-not-free-tier car', 3, 49999, 0);

  // --- AC3: everything else -> 0.5 * distanceKm, floored at minimum 25 ---
  expectFee('AC3 far + cheap car, above minimum', 60, 1000, 30);
  expectFee('AC3 far + cheap car, formula above minimum by a lot', 200, 1, 100);
  expectFee('AC3 far + cheap car, formula below minimum -> clamps to 25', 11, 100,
      25);
  expectFee('AC3 far + cheap car, just above free-distance threshold',
      10.0001, 100, 25);

  // --- AC4: boundaries belong to the free tier ---
  expectFee('AC4 carPrice exactly 50000, long distance -> still free', 999,
      50000, 0);
  expectFee(
      'AC4 distanceKm exactly 10, expensive-but-not-free car -> still free',
      10,
      49999,
      0);
  expectFee('AC4 distanceKm exactly 10 AND carPrice exactly 50000', 10, 50000,
      0);

  // --- AC5: invalid input -> ArgumentError ---
  expectArgumentError('AC5 distanceKm = 0', 0, 100);
  expectArgumentError('AC5 distanceKm negative', -1, 100);
  expectArgumentError('AC5 carPrice = 0', 10, 0);
  expectArgumentError('AC5 carPrice negative', 10, -1);
  expectArgumentError('AC5 both distanceKm and carPrice invalid', -5, -5);
  expectArgumentError(
      'AC5 invalid distanceKm takes priority over free-delivery rules '
      '(expensive car)',
      -1,
      100000);
  expectArgumentError(
      'AC5 invalid carPrice takes priority over free-delivery rules '
      '(short distance)',
      1,
      -100);

  // --- Edge cases called out explicitly in the spec ---
  expectFee('Edge: distanceKm = 50 -> formula gives exactly 25 (minimum boundary)',
      50, 100, 25);
  expectFee('Edge: distanceKm = 20 -> formula gives 10 -> minimum kicks in -> 25',
      20, 100, 25);
  expectFee(
      'Edge: both free rules true at once (cheap distance AND expensive car) -> 0',
      5,
      100000,
      0);

  print('');
  print('$_passed passed, $_failed failed');
  if (_failed > 0) {
    exit(1);
  }
}
