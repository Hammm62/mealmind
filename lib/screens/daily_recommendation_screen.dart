import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../utils/daily_meal_generator.dart';

class DailyRecommendationScreen extends StatelessWidget {
  const DailyRecommendationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Meal todayMeal = DailyMealGenerator.getTodayMeal();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Hari Ini'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Hero(
                tag: 'meal_${todayMeal.id}',
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  child: Image.asset(
                    todayMeal.imagePath,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      todayMeal.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: todayMeal.tags
                          .map((tag) => Chip(
                                label: Text(tag),
                                backgroundColor: Colors.grey.shade200,
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Durasi: ${todayMeal.duration}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/detail',
                            arguments: todayMeal,
                          );
                        },
                        icon: const Icon(Icons.fastfood),
                        label: const Text('Lihat Detail'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
