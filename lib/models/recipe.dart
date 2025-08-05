class Recipe {
  final String? id;
  final String? name;
  final String? description;
  final String? thumbnail;
  final String? instructions;
  final List<String>? ingredients;

  Recipe({
    this.id,
    this.name,
    this.description,
    this.thumbnail,
    this.instructions,
    this.ingredients,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    final ingredients = <String>[];
    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'];
      final measure = json['strMeasure$i'];
      if (ingredient != null &&
          ingredient.toString().trim().isNotEmpty &&
          measure != null &&
          measure.toString().trim().isNotEmpty) {
        ingredients.add('$measure $ingredient');
      }
    }

    return Recipe(
      id: json['idMeal'],
      name: json['strMeal'],
      description: json['strCategory'] ?? 'No category',
      thumbnail: json['strMealThumb'],
      instructions: json['strInstructions'],
      ingredients: ingredients,
    );
  }
}
