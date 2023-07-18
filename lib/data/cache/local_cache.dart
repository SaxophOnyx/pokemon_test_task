import 'package:hive_flutter/hive_flutter.dart';
import 'package:pokemon_test_task/data/cache/pokemon_data_model.dart';
import 'package:pokemon_test_task/domain/models/pokemon.dart';
import 'package:pokemon_test_task/domain/services/contracts/I_data_cache.dart';
import 'package:pokemon_test_task/domain/services/contracts/data_fetch_error.dart';
import 'package:pokemon_test_task/domain/services/contracts/data_update_error.dart';

class LocalCache implements IDataCache {
  final String cacheKey;
  final String _nameBoxKey;
  final String _pokemonBoxKey;

  LocalCache(this.cacheKey)
    : _nameBoxKey = '${cacheKey}_names}',
      _pokemonBoxKey = '${cacheKey}_pokemons';

  Future<void> deleteFromDisk() async {
    await Hive.deleteBoxFromDisk(_nameBoxKey);
    await Hive.deleteBoxFromDisk(_pokemonBoxKey);
  }

  @override
  Future<void> addOrUpdateNames(List<String> names, int offset) async {
    try {
      final box = await Hive.openBox<String>(_nameBoxKey);

      final map = <int, String>{};
      for (int i = 0; i < names.length; ++i) {
        map[offset + i] = names[i];
      }

      box.putAll(map); 

    } catch(e) {
      throw DataUpdateError();
    }
  }

  @override
  Future<void> addOrUpdatePokemon(Pokemon pokemon, int offset) async {
    try {
      final box = await Hive.openBox<PokemonDataModel>(_pokemonBoxKey);
      final dataModel = PokemonDataModel.fromModel(pokemon);
      await box.put(offset, dataModel);

    } catch(e) {
      throw DataUpdateError();
    }
  }

  @override
  Future<Pokemon?> fetchPokemon(int offset) async {
    try {
      final box = await Hive.openBox<PokemonDataModel>(_pokemonBoxKey);
      final dataModel = box.get(offset);

      if (dataModel == null) {
        return null;
      }

      return dataModel.toModel();

    } catch(e) {
      throw DataFetchError();
    }
  }

  @override
  Future<List<String>> fetchNames(int offset, int limit) async {
    try {
      final box = await Hive.openBox<String>(_nameBoxKey);
      final names = box.valuesBetween(startKey: offset, endKey: offset + limit - 1);
      return names.toList();

    } catch(e) {
      throw DataFetchError();
    }
  }
}
