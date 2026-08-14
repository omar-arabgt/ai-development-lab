// Standalone spec-conformance checker for PointsCalculator.earn.
// Run with: dart tool/spec_check.dart
//
// This is the referee: it checks an implementation against every
// acceptance criterion and edge case in specs/loyalty-points.md.
// It does not know or care how earn() is implemented.

import 'dart:io';

import '../lib/points_calculator.dart';

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

/// Checks that earn(purchaseAmount, purchaseDate) returns [expected].
void expectPoints(
    String name, double purchaseAmount, DateTime purchaseDate, int expected) {
  int actual;
  try {
    actual = PointsCalculator.earn(purchaseAmount, purchaseDate);
  } catch (e) {
    _fail(name,
        'earn($purchaseAmount, $purchaseDate) threw $e, expected result $expected');
    return;
  }
  if (actual == expected) {
    _pass(name);
  } else {
    _fail(name,
        'earn($purchaseAmount, $purchaseDate) => $actual, expected $expected');
  }
}

void main() {
  // Fixed local reference dates, all in the same week:
  // 2026-08-13 Thu, 2026-08-14 Fri, 2026-08-15 Sat,
  // 2026-08-16 Sun, 2026-08-17 Mon.
  final thu = DateTime(2026, 8, 13);
  final fri = DateTime(2026, 8, 14);
  final sat = DateTime(2026, 8, 15);
  final sun = DateTime(2026, 8, 16);
  final mon = DateTime(2026, 8, 17);

  // --- AC1: weekday -> round-half-up(purchaseAmount / 100) ---
  expectPoints('AC1 weekday, exact 100 -> 1', 100, thu, 1);
  expectPoints('AC1 weekday, 349 -> 3.49 rounds down -> 3', 349, thu, 3);
  expectPoints('AC1 weekday, 350 -> 3.5 rounds up -> 4', 350, thu, 4);
  expectPoints('AC1 weekday (Monday), 250 -> 2.5 rounds up -> 3', 250, mon, 3);

  // --- AC2: weekend -> floor(purchaseAmount / 100) * 2 ---
  expectPoints('AC2 Friday, 150 -> floor(1.5)*2 = 2', 150, fri, 2);
  expectPoints('AC2 Saturday, 199 -> floor(1.99)*2 = 2', 199, sat, 2);
  expectPoints('AC2 Friday, 200 -> floor(2)*2 = 4', 200, fri, 4);
  expectPoints('AC2 Saturday, 250 -> floor(2.5)*2 = 4', 250, sat, 4);

  // --- AC3: round purchaseAmount to 3 decimals before AC1/AC2 ---
  expectPoints(
      'AC3 weekday, 99.9996 rounds to 100.000 -> 1', 99.9996, thu, 1);
  expectPoints(
      'AC3 weekday, 100.0004 rounds to 100.000 -> 1', 100.0004, thu, 1);
  expectPoints(
      'AC3 weekday, 49.9996 rounds to 50.000 -> 0.5 rounds up -> 1',
      49.9996,
      thu,
      1);

  // --- AC4: cap at 100 points per purchase ---
  expectPoints('AC4 weekday, 20000 -> 200 raw -> capped to 100', 20000, thu, 100);
  expectPoints(
      'AC4 weekend, 10100 -> floor(101)*2=202 raw -> capped to 100',
      10100,
      fri,
      100);
  expectPoints(
      'AC4 weekday, 10000 -> exactly 100, at the cap (no clamp needed)',
      10000,
      thu,
      100);

  // --- AC5: negative or NaN purchaseAmount -> 0 ---
  expectPoints('AC5 negative amount, weekday -> 0', -100, thu, 0);
  expectPoints('AC5 negative amount, weekend -> 0', -1, fri, 0);
  expectPoints('AC5 NaN amount -> 0', double.nan, thu, 0);

  // --- AC6: boundary — 0.5 fractional part on a weekday rounds up ---
  expectPoints('AC6 weekday, 50 -> 0.5 rounds up -> 1', 50, thu, 1);
  expectPoints('AC6 weekday, 150 -> 1.5 rounds up -> 2', 150, thu, 2);
  expectPoints('AC6 weekday, 250 -> 2.5 rounds up -> 3', 250, thu, 3);

  // --- Edge cases called out explicitly in the spec ---
  expectPoints(
      'Edge: 0 JOD purchase -> 0 points (valid, not an AC5 case)', 0, thu, 0);
  expectPoints(
      'Edge: Sunday is NOT weekend, uses weekday formula (round-half-up)',
      250,
      sun,
      3);
  expectPoints(
      'Edge: Monday is NOT weekend, uses weekday formula (round-half-up)',
      250,
      mon,
      3);

  print('');
  print('$_passed passed, $_failed failed');
  if (_failed > 0) {
    exit(1);
  }
}
