import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'SearchPage.dart';
import 'FavoritePage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rick and Morty App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
      routes: {
        '/search': (context) => SearchPage(),
        '/favorites': (context) => FavoritesPage(),
      },
    );
  }
}
