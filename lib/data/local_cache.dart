import 'package:hive/hive.dart';
import 'package:pokemon_test_task/app/contracts/data/data_fetch_error.dart';
import 'package:pokemon_test_task/app/contracts/data/i_data_provider.dart';
import 'package:pokemon_test_task/app/contracts/service/pokemon_not_found_error.dart';
import 'package:pokemon_test_task/data/pokemon_data_model.dart';
import 'package:pokemon_test_task/domain/pokemon.dart';

class LocalCache implements IDataProvider {
  final IDataProvider dataProvider;
  final String cacheKey;
  final String _namesBoxKey;
  final String _pokemonsBoxKey;

  LocalCache({
    required this.dataProvider,
    required this.cacheKey
  }): _namesBoxKey = '${cacheKey}_names}',
      _pokemonsBoxKey = '${cacheKey}_pokemons';

  @override
  Future<List<String>> fetchNames(int offset, int limit) async {
    try {
      final namesBox = await Hive.openBox<String>(_namesBoxKey);

      try {
        final names = await dataProvider.fetchNames(offset, limit);
        final map = <int, String>{};
        for (int i = 0; i < limit; ++i) {
          map[offset + i] = names[i];
        }

        namesBox.putAll(map);        
        return names;
      } on DataFetchError {
        final namesBox = await Hive.openBox<String>(_namesBoxKey);
        final names = namesBox.valuesBetween(startKey: offset, endKey: offset + limit);
        return names.toList();
      }
    } catch(e) {
      throw DataFetchError();
    }
  }

  @override
  Future<Pokemon> fetchDetails(int offset) async {
    late final Box<PokemonDataModel> box;
    try {
      box = await Hive.openBox<PokemonDataModel>(_pokemonsBoxKey);
      try {
        final pokemon = await dataProvider.fetchDetails(offset);
        final dataModel = PokemonDataModel.fromModel(pokemon);
        await box.put(offset, dataModel);
        return pokemon;
      } on DataFetchError catch(e) {
        final dataModel = box.get(offset);
        if (dataModel != null) {
          return dataModel.toModel();
        } else {
          throw PokemonNotFoundError();
        }
      }
    } catch(e) {
      throw PokemonNotFoundError();
    } finally {
      await box.close();
    }
  }
}
