import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const String _favoriteKey = 'favorite_meals';
  static const String _dailyKey = 'daily_recommendation';

  /// ====== FAVORIT ======

  /// Mendapatkan daftar ID menu favorit
  static Future<Set<int>> getFavoriteMealIds() async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList(_favoriteKey) ?? [];
    return ids.map(int.parse).toSet();
  }

  /// Menyimpan ID menu ke favorit
  static Future<void> saveFavoriteMeal(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList(_favoriteKey) ?? [];
    if (!ids.contains(id.toString())) {
      ids.add(id.toString());
      await prefs.setStringList(_favoriteKey, ids);
    }
  }

  /// Menghapus ID menu dari favorit
  static Future<void> removeFavoriteMeal(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList(_favoriteKey) ?? [];
    ids.remove(id.toString());
    await prefs.setStringList(_favoriteKey, ids);
  }

  /// Menghapus semua data favorit
  static Future<void> clearFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_favoriteKey);
  }

  /// ====== REKOMENDASI HARIAN ======

  /// Menyimpan ID menu rekomendasi harian berdasarkan tanggal hari ini
  static Future<void> saveTodayRecommendation(int mealId) async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().substring(0, 10);
    await prefs.setStringList(_dailyKey, [today, mealId.toString()]);
  }

  /// Mengambil ID menu yang direkomendasikan hari ini, jika ada
  static Future<int?> getTodayRecommendationId() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_dailyKey);
    final today = DateTime.now().toIso8601String().substring(0, 10);
    if (data != null && data.length == 2 && data[0] == today) {
      return int.tryParse(data[1]);
    }
    return null;
  }

  /// Menghapus rekomendasi harian
  static Future<void> clearTodayRecommendation() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_dailyKey);
  }
}
