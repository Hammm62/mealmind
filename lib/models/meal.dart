class Meal {
  final int id;
  final String name;
  final List<String> tags;
  final List<String> ingredients;
  final String instructions;
  final String duration;
  final String imagePath;

  Meal({
    required this.id,
    required this.name,
    required this.tags,
    required this.ingredients,
    required this.instructions,
    required this.duration,
    required this.imagePath,
  });
}
