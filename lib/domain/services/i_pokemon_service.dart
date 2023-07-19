import 'package:pokemon_test_task/domain/models/pokemon.dart';

abstract class IPokemonService {
  int get maxPageSize;
  Future<List<String>> fetchPokemonNamesFromPage(int pageNumber);
  Future<Pokemon> fetchPokemonDetails(int pageNumber, int entryNumber);
}
