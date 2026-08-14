/// Sorts car search results for the listing page.
///
/// See specs/price-sort.md (ticket OMA-11) for the acceptance criteria.
class ResultSorter {
  static List<Map<String, Object?>> byPriceAscending(
    List<Map<String, Object?>> results,
  ) {
    final priced = <MapEntry<int, Map<String, Object?>>>[];
    final unpriced = <Map<String, Object?>>[];

    for (var i = 0; i < results.length; i++) {
      final entry = results[i];
      final price = entry['price'];
      if (price is num && price > 0) {
        priced.add(MapEntry(i, entry));
      } else {
        unpriced.add(entry);
      }
    }

    priced.sort((a, b) {
      final priceCompare =
          (a.value['price'] as num).compareTo(b.value['price'] as num);
      return priceCompare != 0 ? priceCompare : a.key.compareTo(b.key);
    });

    return [
      for (final entry in priced) entry.value,
      ...unpriced,
    ];
  }
}
