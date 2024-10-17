import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'favorite_model.dart';
import 'DetailPage.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<FavoriteCharacter> _favoriteCharacters = [];
  final dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final favorites = await dbHelper.getFavorites();
    setState(() {
      _favoriteCharacters = favorites;
    });
  }

  Future<void> _deleteFavorite(int id) async {
    await dbHelper.deleteFavorite(id);
    await _loadFavorites();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Favorite character removed!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Characters'),
      ),
      body: _favoriteCharacters.isEmpty
          ? Center(child: Text('No favorite characters found.'))
          : ListView.builder(
              itemCount: _favoriteCharacters.length,
              itemBuilder: (context, index) {
                var favorite = _favoriteCharacters[index];
                return ListTile(
                  title: Text(favorite.name),
                  subtitle: Text(favorite.species),
                  leading: Image.network(favorite.image),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPage(
                          character: favorite.toCharacter(),
                        ),
                      ),
                    );
                  },
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteFavorite(favorite.id),
                  ),
                );
              },
            ),
    );
  }
}
