import 'package:pokemon_test_task/domain/models/pokemon.dart';

abstract class IDataProvider {
  Future<List<String>> fetchNames(int offset, int limit);
  Future<Pokemon> fetchDetails(int offset);
}
