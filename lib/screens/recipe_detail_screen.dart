import 'package:flutter/material.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Map<String, dynamic> recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    final name = recipe['name'] ?? 'No Name';
    final imageUrl = (recipe['thumbnail_url'] ?? '').toString();
    final ingredients = recipe['sections'] != null && recipe['sections'].isNotEmpty
        ? recipe['sections'][0]['components']
        : null;
    final instructions = recipe['instructions'];

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imageUrl,
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 220,
                    color: Colors.grey.shade300,
                    child: const Center(child: Icon(Icons.broken_image)),
                  ),
                ),
              ),
            const SizedBox(height: 16),

            Text(
              name,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            if (ingredients != null) ...[
              Text(
                'Ingredients',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              ...ingredients.map<Widget>((ing) => Text('• ${ing['raw_text'] ?? ''}')).toList(),
              const SizedBox(height: 24),
            ],

            if (instructions != null && instructions.isNotEmpty) ...[
              Text(
                'Instructions',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              ...instructions.map<Widget>((step) {
                final displayText = step['display_text'] ?? '';
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text('• $displayText'),
                );
              }).toList(),
            ]
          ],
        ),
      ),
    );
  }
}

