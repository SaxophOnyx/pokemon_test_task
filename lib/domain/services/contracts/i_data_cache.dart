import 'package:pokemon_test_task/domain/models/pokemon.dart';

abstract class IDataCache {
  Future<List<String>> fetchNames(int offset, int limit);
  Future<Pokemon?> fetchPokemon(int offset);
  Future<void> addOrUpdateNames(List<String> names, int offset);
  Future<void> addOrUpdatePokemon(Pokemon pokemon, int offset);
}
