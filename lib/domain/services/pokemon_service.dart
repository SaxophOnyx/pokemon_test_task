import 'package:pokemon_test_task/domain/services/contracts/data_fetch_error.dart';
import 'package:pokemon_test_task/domain/services/i_pokemon_service.dart';
import 'package:pokemon_test_task/domain/services/contracts/i_data_provider.dart';
import 'package:pokemon_test_task/domain/services/errors/page_not_found_error.dart';
import 'package:pokemon_test_task/domain/services/errors/pokemon_not_found_error.dart';
import 'package:pokemon_test_task/domain/models/pokemon.dart';

class PokemonService implements IPokemonService {
  final IDataProvider dataProvider;
  final int maxPageSize;

  const PokemonService({
    required this.dataProvider,
    this.maxPageSize = 30
  });

  @override
  Future<List<String>> fetchPokemonNamesFromPage(int pageNumber) async {
    try {
      return await dataProvider.fetchNames((pageNumber - 1) * maxPageSize, maxPageSize);
    } on DataFetchError {
      throw PageNotFoundError();
    }
  }

  @override
  Future<Pokemon> fetchPokemonDetails(int pageNumber, int entryNumber) async {
    try {
      return await dataProvider.fetchDetails((pageNumber - 1) * maxPageSize + entryNumber - 1);
    } on DataFetchError {
      throw PokemonNotFoundError();
    }
  }
}
