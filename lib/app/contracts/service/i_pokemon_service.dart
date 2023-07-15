import 'package:pokemon_test_task/domain/pokemon.dart';

abstract class IPokemonService {
  Future<List<String>> fetchPokemonNamesFromPage(int pageNumber);
  Future<Pokemon> fetchPokemonDetails(int pageNumber, int entryNumber);
}
