import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pokemon_test_task/app/contracts/data/data_fetch_error.dart';

import 'package:pokemon_test_task/app/contracts/data/i_data_provider.dart';
import 'package:pokemon_test_task/domain/pokemon.dart';
import 'package:pokemon_test_task/domain/pokemon_type.dart';

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
      return List<String>.generate(pokemons.length, (i) => pokemons[i]['name']);
    } catch(e) {
      throw DataFetchError();
    }
  }

  @override
  Future<Pokemon> fetchDetails(int offset) async {
    if (offset < 0) {
      throw DataFetchError();
    }

    try {
      final detailsUri = Uri.parse('$rootUri/${offset + 1}');
      final raw = await http.read(detailsUri);
      final decoded = jsonDecode(raw);

      final String name = decoded['name'];
      final double weight = decoded['weight'] / 10;
      final int height = decoded['height'] * 10;
      final List<PokemonType> types = List.empty(growable: true);

      final rawTypes = decoded['types'] as List<dynamic>;
      for (var t in rawTypes) {
        types.add(PokemonType.fromName(t['type']['name']));
      }

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
