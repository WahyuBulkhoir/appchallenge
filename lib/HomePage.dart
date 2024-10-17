import 'package:flutter/material.dart';
import 'DetailPage.dart';
import 'FavoritePage.dart';
import 'Character.dart';
import 'database_helper.dart';
import 'favorite_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Character> _characters = [];
  Set<int> _favoriteCharacterIds = {};
  final dbHelper = DatabaseHelper();
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  bool _isLoadingMore = false;
  bool _hasMoreData = true;

  @override
  void initState() {
    super.initState();
    fetchCharacters();
    _loadFavoriteIds();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !_isLoadingMore &&
          _hasMoreData) {
        fetchCharacters();
      }
    });
  }

  Future<void> fetchCharacters() async {
    if (_isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    final response = await http.get(Uri.parse(
        'https://rickandmortyapi.com/api/character?page=$_currentPage'));

    if (response.statusCode == 200) {
      List<Character> newCharacters = [];
      final data = json.decode(response.body);
      for (var character in data['results']) {
        newCharacters.add(Character.fromJson(character));
      }

      setState(() {
        _characters.addAll(newCharacters);
        _currentPage++;
        _isLoadingMore = false;
        _hasMoreData = data['info']['next'] != null;
      });
    } else {
      setState(() {
        _isLoadingMore = false;
      });
      throw Exception('Failed to load characters');
    }
  }

  Future<void> _loadFavoriteIds() async {
    final favorites = await dbHelper.getFavorites();
    setState(() {
      _favoriteCharacterIds = favorites.map((fav) => fav.id).toSet();
    });
  }

  void _toggleFavorite(Character character) {
    if (_favoriteCharacterIds.contains(character.id)) {
      dbHelper.deleteFavorite(character.id);
      _favoriteCharacterIds.remove(character.id);
    } else {
      dbHelper.insertFavorite(FavoriteCharacter(
        id: character.id,
        name: character.name,
        species: character.species,
        gender: character.gender,
        origin: character.origin,
        location: character.location,
        image: character.image,
      ));
      _favoriteCharacterIds.add(character.id);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rick and Morty Characters'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.pushNamed(context, '/search');
            },
          ),
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoritesPage()),
              );
              await _loadFavoriteIds();
            },
          ),
        ],
      ),
      body: _characters.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: GridView.builder(
                    controller: _scrollController,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.75,
                    ),
                    padding: const EdgeInsets.all(10),
                    itemCount: _characters.length,
                    itemBuilder: (context, index) {
                      var character = _characters[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetailPage(character: character),
                            ),
                          );
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: Hero(
                                  tag: 'character_${character.id}',
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(15)),
                                    child: Image.network(
                                      character.image,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      character.name,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(character.species),
                                    SizedBox(height: 5),
                                    IconButton(
                                      icon: Icon(
                                        _favoriteCharacterIds
                                                .contains(character.id)
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: _favoriteCharacterIds
                                                .contains(character.id)
                                            ? Colors.red
                                            : null,
                                      ),
                                      onPressed: () =>
                                          _toggleFavorite(character),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                if (_isLoadingMore)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
    );
  }
}
