/// Tracks which car listing IDs the current user has favorited.
class FavoritesService {
  final List<String> _favoriteCarIds = [];

  List<String> get favoriteCarIds => List.unmodifiable(_favoriteCarIds);

  /// TASK: toggle [carId] in the favorites list — add it if absent,
  /// remove it if present. Return true if the car ended up favorited,
  /// false otherwise.
  bool toggleFavorite(String carId) {
    if (_favoriteCarIds.contains(carId)) {
      _favoriteCarIds.remove(carId);
      return false;
    }
    _favoriteCarIds.add(carId);
    return true;
  }
}
