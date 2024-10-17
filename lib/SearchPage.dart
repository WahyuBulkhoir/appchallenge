import 'package:flutter/material.dart';
import 'DetailPage.dart';
import 'Character.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Character> _searchResults = [];
  bool _isLoading = false;
  bool _hasError = false;

  Future<List<Character>> searchCharacters(String query) async {
    final response = await http.get(
        Uri.parse('https://rickandmortyapi.com/api/character/?name=$query'));

    if (response.statusCode == 200) {
      List<Character> characters = [];
      final data = json.decode(response.body);
      if (data['results'] != null) {
        for (var character in data['results']) {
          characters.add(Character.fromJson(character));
        }
      }
      return characters;
    } else {
      throw Exception('Failed to load search results');
    }
  }

  void _performSearch(String query) async {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _searchResults = [];
    });

    try {
      _searchResults = await searchCharacters(query);
    } catch (e) {
      _hasError = true;
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Characters'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
              ),
              onSubmitted: _performSearch,
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _hasError
                    ? const Center(child: Text('Error loading search results.'))
                    : _searchResults.isEmpty
                        ? const Center(child: Text('No characters found.'))
                        : ListView.builder(
                            itemCount: _searchResults.length,
                            itemBuilder: (context, index) {
                              var character = _searchResults[index];
                              return ListTile(
                                title: Text(character.name),
                                subtitle: Text(character.species),
                                leading: Image.network(character.image),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DetailPage(character: character),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}
