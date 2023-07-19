import 'package:flutter/material.dart';
import 'package:pokemon_test_task/data/cache/local_cache.dart';
import 'package:pokemon_test_task/domain/services/pokemon_service.dart';
import 'package:pokemon_test_task/data/cache/pokemon_data_model_adapter.g.dart';
import 'package:pokemon_test_task/data/web/web_api_data_provider.dart';
import 'package:pokemon_test_task/ui/pokemon_app.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(PokemonDataModelAdapter());
  
  final dataProvider = WebApiDataProvider('https://pokeapi.co/api/v2/pokemon');
  final cache = LocalCache('test-task');
  final service = PokemonService(dataProvider: dataProvider, cache: cache);

  final app = PokemonApp(service: service);
  runApp(app);
}
