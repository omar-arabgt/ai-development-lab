// Referee for specs/price-sort.md (ticket OMA-11).
// Run with: dart tool/spec_check.dart
// Exits non-zero if any acceptance criterion fails.

import 'dart:io';

import '../lib/result_sorter.dart';

typedef Results = List<Map<String, Object?>>;

class Case {
  final String name;
  final bool Function() run;
  Case(this.name, this.run);
}

bool listEquals(List<Object?> a, List<Object?> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

List<Object?> ids(Results results) => results.map((m) => m['id']).toList();

void main() {
  final cases = <Case>[
    Case('1: empty list returns empty list', () {
      final input = <Map<String, Object?>>[];
      final result = ResultSorter.byPriceAscending(input);
      return result.isEmpty;
    }),
    Case('2: all no-price entries keep original relative order', () {
      final input = <Map<String, Object?>>[
        {'id': 'a', 'price': null},
        {'id': 'b'},
        {'id': 'c', 'price': 'call'},
        {'id': 'd', 'price': 0},
        {'id': 'e', 'price': -10},
      ];
      final result = ResultSorter.byPriceAscending(input);
      return listEquals(ids(result), ['a', 'b', 'c', 'd', 'e']);
    }),
    Case('3: mixed priced/no-price — priced ascending, then no-price in original order', () {
      final input = <Map<String, Object?>>[
        {'id': 'noprice1'},
        {'id': 'mid', 'price': 20},
        {'id': 'cheap', 'price': 5},
        {'id': 'noprice2', 'price': null},
        {'id': 'expensive', 'price': 50},
      ];
      final result = ResultSorter.byPriceAscending(input);
      return listEquals(
        ids(result),
        ['cheap', 'mid', 'expensive', 'noprice1', 'noprice2'],
      );
    }),
    Case('4: ties keep original relative order (stable sort)', () {
      final input = <Map<String, Object?>>[
        {'id': 'x1', 'price': 10},
        {'id': 'y', 'price': 5},
        {'id': 'x2', 'price': 10},
        {'id': 'x3', 'price': 10},
      ];
      final result = ResultSorter.byPriceAscending(input);
      return listEquals(ids(result), ['y', 'x1', 'x2', 'x3']);
    }),
    Case('5: zero/negative prices treated as no-price', () {
      final input = <Map<String, Object?>>[
        {'id': 'a', 'price': 15},
        {'id': 'zero', 'price': 0},
        {'id': 'b', 'price': 3},
        {'id': 'neg', 'price': -5},
      ];
      final result = ResultSorter.byPriceAscending(input);
      return listEquals(ids(result), ['b', 'a', 'zero', 'neg']);
    }),
    Case('6: malformed price values never throw, treated as no-price', () {
      final input = <Map<String, Object?>>[
        {'id': 'a', 'price': 'cheap'},
        {'id': 'b', 'price': true},
        {'id': 'c', 'price': [1, 2]},
        {'id': 'd', 'price': <String, Object?>{}},
        {'id': 'valid', 'price': 7},
      ];
      final result = ResultSorter.byPriceAscending(input);
      return listEquals(ids(result), ['valid', 'a', 'b', 'c', 'd']);
    }),
    Case('7: missing key, null, and zero are treated identically', () {
      final input = <Map<String, Object?>>[
        {'id': 'missing'},
        {'id': 'null', 'price': null},
        {'id': 'zero', 'price': 0},
      ];
      final result = ResultSorter.byPriceAscending(input);
      return listEquals(ids(result), ['missing', 'null', 'zero']);
    }),
    Case('8: int and double prices compare numerically', () {
      final input = <Map<String, Object?>>[
        {'id': 'ten', 'price': 10},
        {'id': 'nineFive', 'price': 9.5},
        {'id': 'ten2', 'price': 10.0},
      ];
      final result = ResultSorter.byPriceAscending(input);
      return listEquals(ids(result), ['nineFive', 'ten', 'ten2']);
    }),
    Case('9: pure function — input untouched, returned list reuses same map instances', () {
      final input = <Map<String, Object?>>[
        {'id': 'b', 'price': 20},
        {'id': 'a', 'price': 5},
      ];
      final result = ResultSorter.byPriceAscending(input);

      final inputUnchanged = listEquals(ids(input), ['b', 'a']);
      final differentListInstance = !identical(result, input);
      final sameMapInstancesReordered =
          identical(result[0], input[1]) && identical(result[1], input[0]);

      return inputUnchanged && differentListInstance && sameMapInstancesReordered;
    }),
  ];

  var failures = 0;
  for (final c in cases) {
    bool passed;
    Object? error;
    try {
      passed = c.run();
    } catch (e) {
      passed = false;
      error = e;
    }
    if (passed) {
      print('PASS  ${c.name}');
    } else {
      failures++;
      final suffix = error != null ? ' — threw: $error' : '';
      print('FAIL  ${c.name}$suffix');
    }
  }

  print('---');
  print('${cases.length - failures}/${cases.length} passed');
  if (failures > 0) exit(1);
}
