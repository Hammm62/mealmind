import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../data/meal_data.dart';
import '../data/local_storage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> selectedTags = [];
  int? selectedMaxDuration;
  Set<int> favoriteMealIds = {};
  List<Meal> filteredMeals = [];

  final List<String> tagOptions = ['hemat', 'sehat', 'cepat'];
  final List<int> durationOptions = [5, 10, 15];

  @override
  void initState() {
    super.initState();
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

  void _filterMeals() {
    setState(() {
      filteredMeals = allMeals.where((meal) {
        final hasTag = selectedTags.any((tag) => meal.tags.contains(tag));

        final mealDuration = int.tryParse(
              meal.duration.replaceAll(RegExp(r'[^0-9]'), ''),
            ) ??
            999;

        final withinTime = selectedMaxDuration != null
            ? mealDuration <= selectedMaxDuration!
            : true;

        return hasTag && withinTime;
      }).toList();
    });
  }

  Widget _buildTagChip(String tag) {
    final selected = selectedTags.contains(tag);
    return ChoiceChip(
      label: Text(tag),
      labelStyle: TextStyle(
        color: selected ? Colors.white : Colors.black,
      ),
      selectedColor: Theme.of(context).colorScheme.primary,
      backgroundColor: Colors.grey.shade200,
      selected: selected,
      onSelected: (_) {
        setState(() {
          selected ? selectedTags.remove(tag) : selectedTags.add(tag);
        });
      },
    );
  }

  Widget _buildFavoriteMeals() {
    final favoriteMeals = allMeals
        .where((meal) => favoriteMealIds.contains(meal.id))
        .toList();

    if (favoriteMeals.isEmpty) {
      return const Text(
        'Belum ada menu favorit.',
        style: TextStyle(color: Colors.grey),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Menu Favorit Kamu',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...favoriteMeals.map((meal) => Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 3,
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(meal.duration),
                trailing: IconButton(
                  icon: const Icon(Icons.favorite, color: Colors.red),
                  onPressed: () => _toggleFavorite(meal.id),
                ),
                onTap: () async {
                  await Navigator.pushNamed(context, '/detail', arguments: meal);
                  _loadFavorites(); // Refresh setelah kembali
                },
              ),
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MealMind'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            tooltip: 'Menu Hari Ini',
            onPressed: () async {
              await Navigator.pushNamed(context, '/daily');
              _loadFavorites(); // Refresh juga kalau ada interaksi
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pilih Preferensi',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: tagOptions.map(_buildTagChip).toList(),
              ),
              const SizedBox(height: 24),
              const Text(
                'Batas Waktu Memasak',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                children: durationOptions
                    .map((dur) => ChoiceChip(
                          label: Text('≤ $dur menit'),
                          labelStyle: TextStyle(
                            color: selectedMaxDuration == dur
                                ? Colors.white
                                : Colors.black,
                          ),
                          selectedColor:
                              Theme.of(context).colorScheme.secondary,
                          backgroundColor: Colors.grey.shade200,
                          selected: selectedMaxDuration == dur,
                          onSelected: (_) {
                            setState(() {
                              selectedMaxDuration =
                                  selectedMaxDuration == dur ? null : dur;
                            });
                          },
                        ))
                    .toList(),
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    _filterMeals();
                    if (filteredMeals.isNotEmpty) {
                      await Navigator.pushNamed(
                        context,
                        '/suggestion',
                        arguments: {
                          'tags': selectedTags,
                          'maxDuration': selectedMaxDuration
                        },
                      );
                      _loadFavorites(); // Refresh setelah kembali
                    } else {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Tidak ada hasil'),
                          content: const Text(
                              'Coba ubah preferensi atau waktu memasak.'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text('OK'),
                            )
                          ],
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.fastfood),
                  label: const Text('Tampilkan Saran Menu'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              _buildFavoriteMeals(),
            ],
          ),
        ),
      ),
    );
  }
}
