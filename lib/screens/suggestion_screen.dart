import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../data/meal_data.dart';
import '../data/local_storage.dart';

class SuggestionScreen extends StatefulWidget {
  const SuggestionScreen({super.key});

  @override
  State<SuggestionScreen> createState() => _SuggestionScreenState();
}

class _SuggestionScreenState extends State<SuggestionScreen> {
  late List<Meal> filteredMeals;
  Set<int> favoriteMealIds = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final selectedTags = args?['tags'] as List<String>? ?? [];
    final selectedMaxDuration = args?['maxDuration'] as int?;

    filteredMeals = allMeals.where((meal) {
      final hasTag =
          selectedTags.isEmpty || selectedTags.any((tag) => meal.tags.contains(tag));
      final mealDuration =
          int.tryParse(meal.duration.replaceAll(RegExp(r'[^0-9]'), '')) ?? 999;
      final withinTime = selectedMaxDuration != null
          ? mealDuration <= selectedMaxDuration
          : true;

      return hasTag && withinTime;
    }).toList();

    _loadFavorites();
  }

  void _loadFavorites() async {
    final ids = await LocalStorage.getFavoriteMealIds();
    setState(() {
      favoriteMealIds = ids;
    });
  }

  void _toggleFavorite(int mealId) async {
    if (favoriteMealIds.contains(mealId)) {
      await LocalStorage.removeFavoriteMeal(mealId);
    } else {
      await LocalStorage.saveFavoriteMeal(mealId);
    }
    _loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil Rekomendasi'),
      ),
      body: filteredMeals.isEmpty
          ? const Center(
              child: Text('Tidak ada menu yang cocok.'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredMeals.length,
              itemBuilder: (context, index) {
                final meal = filteredMeals[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      Navigator.pushNamed(context, '/detail', arguments: meal);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Hero(
                          tag: 'meal_${meal.id}',
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                            child: Image.asset(
                              meal.imagePath,
                              height: 180,
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
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      meal.name,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      favoriteMealIds.contains(meal.id)
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: favoriteMealIds.contains(meal.id)
                                          ? Colors.red
                                          : Colors.grey,
                                    ),
                                    onPressed: () => _toggleFavorite(meal.id),
                                  )
                                ],
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 6,
                                runSpacing: 4,
                                children: meal.tags
                                    .map((tag) => Chip(
                                          label: Text(tag),
                                          backgroundColor:
                                              Colors.grey.shade200,
                                        ))
                                    .toList(),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Waktu Memasak: ${meal.duration}',
                                style: const TextStyle(
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
