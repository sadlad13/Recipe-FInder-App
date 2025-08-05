import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'tasty.p.rapidapi.com';
  static const Map<String, String> _headers = {
    'X-RapidAPI-Key': '440a9cd40dmshc33edc8dfe95532p1f8fd5jsnabc0567bf70a', // Replace this
    'X-RapidAPI-Host': 'tasty.p.rapidapi.com',
  };

  static Future<List<dynamic>> fetchRecipes({
    required String query,
    required String cuisine,
  }) async {
    final Map<String, String> params = {
      'from': '0',
      'size': '20',
      'q': query.isEmpty ? 'chicken' : query,
    };

    final uri = Uri.https(_baseUrl, '/recipes/list', params);

    final response = await http.get(uri, headers: _headers);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List results = data['results'] ?? [];

      // Optional cuisine filtering
      if (cuisine != 'all') {
        results = results.where((r) {
          final tags = r['tags'] ?? [];
          return tags.any((tag) => tag['name'] == cuisine.toLowerCase());
        }).toList();
      }

      return results;
    } else {
      throw Exception('Failed to load recipes');
    }
  }
}

