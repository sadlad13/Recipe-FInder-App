import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'recipe_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCuisine = 'all';
  List<dynamic> _recipes = [];
  bool _isLoading = false;
  String? _error;

  final List<String> _cuisines = [
    'all',
    'american',
    'italian',
    'mexican',
    'chinese',
    'indian',
    'french',
    'japanese',
    'thai',
  ];

  Future<void> _getRecipes() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final results = await ApiService.fetchRecipes(
        query: _searchController.text.trim(),
        cuisine: _selectedCuisine,
      );
      setState(() {
        _recipes = results;
      });
    } catch (e) {
      setState(() {
        _error = 'Something went wrong: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildRecipeCard(dynamic recipe) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RecipeDetailScreen(recipe: recipe),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 6,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (recipe['thumbnail_url'] != null)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  recipe['thumbnail_url'],
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                recipe['name'] ?? 'No title',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasty Recipes 🍽️'),
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by ingredient...',
                filled: true,
                fillColor: Colors.grey[200],
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedCuisine,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              items: _cuisines.map((cuisine) {
                return DropdownMenuItem<String>(
                  value: cuisine,
                  child: Text(cuisine[0].toUpperCase() + cuisine.substring(1)),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCuisine = value!;
                });
              },
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _getRecipes,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text(
                'Search Recipes',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                      ? Center(child: Text(_error!))
                      : _recipes.isEmpty
                          ? const Center(child: Text('No recipes found'))
                          : ListView.builder(
                              itemCount: _recipes.length,
                              itemBuilder: (context, index) {
                                return _buildRecipeCard(_recipes[index]);
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }
}



















