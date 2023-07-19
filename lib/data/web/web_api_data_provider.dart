import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pokemon_test_task/domain/services/contracts/data_fetch_error.dart';

import 'package:pokemon_test_task/domain/services/contracts/i_data_provider.dart';
import 'package:pokemon_test_task/domain/models/pokemon.dart';
import 'package:pokemon_test_task/domain/models/pokemon_type.dart';

class WebApiDataProvider implements IDataProvider {
  final String rootUri;

  WebApiDataProvider(this.rootUri)
    : assert(Uri.tryParse(rootUri) != null, 'Provided rootUri has to be a valid URI');

  @override
  Future<List<String>> fetchNames(int offset, int limit) async {
    if (offset < 0 || limit < 0) {
      throw DataFetchError();
    }

    try {
      final targetUri = Uri.parse('$rootUri?offset=$offset&limit=$limit');
      final raw = await http.read(targetUri);
      final decoded = jsonDecode(raw);
      final pokemons = decoded['results'] as List<dynamic>;
      return pokemons.map<String>((i) => i['name']).toList();
    } catch(e) {
      throw DataFetchError();
    }
  }

  @override
  Future<Pokemon?> fetchPokemon(int offset) async {
    if (offset < 0) {
      throw DataFetchError();
    }

    try {
      final detailsUri = Uri.parse('$rootUri/${offset + 1}');
      final response = await http.get(detailsUri);

      if (response.statusCode == 404) {
        return null;
      }

      final decoded = jsonDecode(response.body);

      final String name = decoded['name'];
      final double weight = decoded['weight'] / 10;
      final int height = decoded['height'] * 10;

      final rawTypes = decoded['types'] as List<dynamic>;
      final types = rawTypes
        .map((i) => PokemonType.fromName(i['type']['name']))
        .toList();

      final imageUri = Uri.parse(decoded['sprites']['front_default']);
      final image = await http.readBytes(imageUri);

      return Pokemon(
        name: name,
        types: types,
        weight: weight,
        height: height,
        image: image
      );

    } catch(e) {
      throw DataFetchError();
    }
  }
}
