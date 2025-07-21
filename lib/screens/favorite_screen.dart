import 'package:flutter/material.dart';
import '../data/local_storage.dart';
import '../data/meal_data.dart';
import '../models/meal.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<Meal> favoriteMeals = [];
  List<Meal> filteredMeals = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadFavorites();
    _searchController.addListener(_filterResults);
  }

  void _loadFavorites() async {
    final favIds = await LocalStorage.getFavoriteMealIds();
    final meals = allMeals.where((meal) => favIds.contains(meal.id)).toList();
    setState(() {
      favoriteMeals = meals;
      filteredMeals = meals;
    });
  }

  void _filterResults() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredMeals = favoriteMeals.where((meal) {
        return meal.name.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Menu Favorit'),
        backgroundColor: Colors.pinkAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari menu favorit...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                fillColor: Colors.grey.shade100,
                filled: true,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: filteredMeals.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.sentiment_dissatisfied,
                            color: Colors.grey, size: 64),
                        SizedBox(height: 10),
                        Text(
                          'Tidak ada menu yang cocok.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    )
                  : ListView.separated(
                      itemCount: filteredMeals.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final meal = filteredMeals[index];
                        return Card(
                          color: Colors.white,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(12),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                meal.imagePath,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(
                              meal.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Row(
                              children: [
                                const Icon(Icons.timer,
                                    size: 16, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text(meal.duration),
                              ],
                            ),
                            trailing: const Icon(Icons.favorite,
                                color: Colors.pinkAccent),
                            onTap: () {
                              Navigator.pushNamed(context, '/detail',
                                  arguments: meal);
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
