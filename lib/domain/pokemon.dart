import 'dart:typed_data';

import 'package:pokemon_test_task/domain/pokemon_type.dart';

class Pokemon {
  final String name;
  final List<PokemonType> types;
  final double weight;
  final int height;
  final Uint8List image;

  Pokemon({
    required this.name,
    required List<PokemonType> types,
    required this.weight,
    required this.height,
    required this.image
  }): types = List.unmodifiable(types);
}
