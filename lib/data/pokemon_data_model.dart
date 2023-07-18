import 'dart:typed_data';

import 'package:hive/hive.dart';
import 'package:pokemon_test_task/domain/models/pokemon.dart';
import 'package:pokemon_test_task/domain/models/pokemon_type.dart';

@HiveType(typeId: 0)
class PokemonDataModel {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final List<String> types;
  @HiveField(2)
  final double weight;
  @HiveField(3)
  final int height;
  @HiveField(4)
  final Uint8List image;

  PokemonDataModel(
    this.name,
    this.types,
    this.weight,
    this.height,
    this.image
  );

  factory PokemonDataModel.fromModel(Pokemon pokemon) {
    final list = List<String>.generate(pokemon.types.length, (i) => pokemon.types[i].toString());
    return PokemonDataModel(
      pokemon.name, list, pokemon.weight, pokemon.height, pokemon.image
    );
  }

  Pokemon toModel() {
    return Pokemon(
      name: name,
      types: List.generate(types.length, (i) => PokemonType.fromString(types[i])),
      weight: weight,
      height: height,
      image: image
    );
  }
}
