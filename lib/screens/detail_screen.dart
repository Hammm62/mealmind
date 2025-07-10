import 'package:flutter/material.dart';
import '../models/meal.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final meal = ModalRoute.of(context)!.settings.arguments as Meal;

    return Scaffold(
      appBar: AppBar(
        title: Text(meal.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar dengan Hero animation
            Hero(
              tag: 'meal_${meal.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  meal.imagePath,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Estimasi waktu
            Row(
              children: [
                const Icon(Icons.timer, size: 20),
                const SizedBox(width: 6),
                Text(
                  meal.duration,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Bahan
            Text(
              'Bahan-bahan:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            ...meal.ingredients.map((item) => Text('• $item')),

            const SizedBox(height: 24),

            // Instruksi
            Text(
              'Langkah-langkah:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              meal.instructions,
              textAlign: TextAlign.justify,
              style: const TextStyle(height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}
