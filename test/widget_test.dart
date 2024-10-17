import 'package:flutter_test/flutter_test.dart';
import '../lib/Character.dart';
import '../lib/favorite_model.dart';

void main() {
  group('Character Class', () {
    test('Character fromJson should parse JSON correctly', () {
      final json = {
        'id': 1,
        'name': 'Abadango Cluster Princess',
        'species': 'Alien',
        'gender': 'Female',
        'origin': {'name': 'Abadango'},
        'location': {'name': 'Abadango'},
        'image': 'https://example.com/abadango.png',
      };

      final character = Character.fromJson(json);

      expect(character.id, 1);
      expect(character.name, 'Abadango Cluster Princess');
      expect(character.species, 'Alien');
      expect(character.gender, 'Female');
      expect(character.origin, 'Abadango');
      expect(character.location, 'Abadango');
      expect(character.image, 'https://example.com/abadango.png');
    });

    test('Character should have all required properties', () {
      final character = Character(
        id: 1,
        name: 'Abadango Cluster Princess',
        species: 'Alien',
        gender: 'Female',
        origin: 'Abadango',
        location: 'Abadango',
        image: 'https://example.com/abadango.png',
      );

      expect(character.id, isA<int>());
      expect(character.name, isA<String>());
      expect(character.species, isA<String>());
      expect(character.gender, isA<String>());
      expect(character.origin, isA<String>());
      expect(character.location, isA<String>());
      expect(character.image, isA<String>());
    });
  });

  group('FavoriteCharacter Class', () {
    test('FavoriteCharacter toMap should convert properties to a map', () {
      final favoriteCharacter = FavoriteCharacter(
        id: 1,
        name: 'Abadango Cluster Princess',
        species: 'Alien',
        gender: 'Female',
        origin: 'Abadango',
        location: 'Abadango',
        image: 'https://example.com/abadango.png',
      );

      final map = favoriteCharacter.toMap();

      expect(map['id'], 1);
      expect(map['name'], 'Abadango Cluster Princess');
      expect(map['species'], 'Alien');
      expect(map['gender'], 'Female');
      expect(map['origin'], 'Abadango');
      expect(map['location'], 'Abadango');
      expect(map['image'], 'https://example.com/abadango.png');
    });
  });
}
