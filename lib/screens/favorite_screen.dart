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
      appBar: AppBar(title: const Text('Menu Favorit')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari menu favorit...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: filteredMeals.isEmpty
                ? const Center(child: Text('Tidak ada menu yang cocok.'))
                : ListView.builder(
                    itemCount: filteredMeals.length,
                    itemBuilder: (context, index) {
                      final meal = filteredMeals[index];
                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
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
                            ),
                          ),
                          subtitle: Text(meal.duration),
                          trailing: const Icon(Icons.favorite, color: Colors.red),
                          onTap: () {
                            Navigator.pushNamed(context, '/detail', arguments: meal);
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
