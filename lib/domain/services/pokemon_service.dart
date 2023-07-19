import 'package:pokemon_test_task/domain/services/contracts/I_data_cache.dart';
import 'package:pokemon_test_task/domain/services/contracts/data_fetch_error.dart';
import 'package:pokemon_test_task/domain/services/contracts/data_update_error.dart';
import 'package:pokemon_test_task/domain/services/errors/data_error.dart';
import 'package:pokemon_test_task/domain/services/i_pokemon_service.dart';
import 'package:pokemon_test_task/domain/services/contracts/i_data_provider.dart';
import 'package:pokemon_test_task/domain/services/errors/page_not_found_error.dart';
import 'package:pokemon_test_task/domain/services/errors/pokemon_not_found_error.dart';
import 'package:pokemon_test_task/domain/models/pokemon.dart';

class PokemonService implements IPokemonService {
  @override
  final int maxPageSize;

  final IDataProvider dataProvider;
  final IDataCache cache;

  const PokemonService({
    required this.dataProvider,
    required this.cache,
    this.maxPageSize = 30
  });

  @override
  Future<List<String>> fetchPokemonNamesFromPage(int pageNumber) async {
    final offset = (pageNumber - 1) * maxPageSize;
    late List<String> fetchedNames;

    try {
      fetchedNames = await dataProvider.fetchNames(offset, maxPageSize);
      if (fetchedNames.isEmpty) {
        throw PageNotFoundError();
      }

      await cache.addOrUpdateNames(fetchedNames, offset);

    } on DataFetchError {
      try {
        fetchedNames = await cache.fetchNames(offset, maxPageSize);

      } on DataFetchError {
        throw DataError(message: 'Failed to read data from cache');
      }

    } on DataUpdateError {
      throw DataError(message: 'Failed to update data in cache');
    }

    if (fetchedNames.isEmpty) {
      throw PageNotFoundError();
    }

    return fetchedNames;
  }

  @override
  Future<Pokemon> fetchPokemonDetails(int pageNumber, int entryNumber) async {
    final offset = (pageNumber - 1) * maxPageSize + entryNumber - 1;
    late Pokemon? pokemon;

    try {
      pokemon = await dataProvider.fetchPokemon(offset);
      if (pokemon == null) {
        throw PokemonNotFoundError();
      }

      await cache.addOrUpdatePokemon(pokemon, offset);

    } on DataFetchError {
      try {
        pokemon = await cache.fetchPokemon(offset);
        
        if (pokemon == null) {
          throw PokemonNotFoundError();
        }

      } on DataFetchError {
        throw DataError(message: 'Failed to read data from cache');
      }
    } on DataUpdateError {
      throw DataError(message: 'Failed to update data in cache'); 
    }

    return pokemon;
  }
}
