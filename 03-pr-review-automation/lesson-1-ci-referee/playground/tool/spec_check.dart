// Neutral referee for ReservationDeposit — designed to run in CI.
// Run with: dart 03-pr-review-automation/lesson-1-ci-referee/playground/tool/spec_check.dart
// Exit code 0 = spec honored, 1 = spec violated (this is what CI reads).
import 'dart:io';

import '../lib/reservation_deposit.dart';

const double _epsilon = 1e-9;
int _passed = 0;
int _failed = 0;

void expectDeposit(String name, double carPrice, double expected) {
  try {
    final actual = ReservationDeposit.compute(carPrice);
    if ((actual - expected).abs() <= _epsilon) {
      _passed++;
      print('PASS  $name');
    } else {
      _failed++;
      print('FAIL  $name — compute($carPrice) => $actual, expected $expected');
    }
  } catch (e) {
    _failed++;
    print('FAIL  $name — compute($carPrice) threw $e, expected $expected');
  }
}

void expectArgumentError(String name, double carPrice) {
  try {
    final actual = ReservationDeposit.compute(carPrice);
    _failed++;
    print('FAIL  $name — compute($carPrice) => $actual, expected ArgumentError');
  } on ArgumentError {
    _passed++;
    print('PASS  $name');
  } catch (e) {
    _failed++;
    print('FAIL  $name — threw ${e.runtimeType}, expected ArgumentError');
  }
}

void main() {
  expectDeposit('AC1 normal car (20000 -> 1000)', 20000, 1000);
  expectDeposit('AC1 normal car (15000 -> 750)', 15000, 750);
  expectDeposit('AC2 cheap car -> minimum (4000 -> 500)', 4000, 500);
  expectDeposit('AC2 just below the min boundary (9999.99 -> 500)', 9999.99, 500);
  expectDeposit('AC3 expensive car -> maximum (100000 -> 2000)', 100000, 2000);
  expectDeposit('AC3 just above the max boundary (40000.01 -> 2000)', 40000.01, 2000);
  expectDeposit('AC4 exactly at minimum boundary (10000 -> 500)', 10000, 500);
  expectDeposit('AC4 exactly at maximum boundary (40000 -> 2000)', 40000, 2000);
  expectArgumentError('AC5 zero price', 0);
  expectArgumentError('AC5 negative price', -5000);
  expectArgumentError('AC5 NaN price', double.nan);

  print('');
  print('$_passed passed, $_failed failed');
  if (_failed > 0) {
    print('SPEC VIOLATED — this gate must stay red until the contract is honored.');
    exit(1);
  }
  print('SPEC HONORED — gate is green.');
}
