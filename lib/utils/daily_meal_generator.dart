import 'dart:math';
import '../models/meal.dart';
import '../data/meal_data.dart';

class DailyMealGenerator {
  static Meal getTodayMeal() {
    final now = DateTime.now();
    final seed = now.year * 10000 + now.month * 100 + now.day;
    final rng = Random(seed);
    final index = rng.nextInt(allMeals.length);
    return allMeals[index];
  }
}
