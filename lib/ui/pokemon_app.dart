// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:pokemon_test_task/app/contracts/service/i_pokemon_service.dart';
import 'package:pokemon_test_task/ui/pages/list_page.dart';

class PokemonApp extends StatelessWidget{
  final IPokemonService service;

  const PokemonApp({required this.service, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ListPage(service: service),
      theme: ThemeData(
        primarySwatch: Colors.green
      ),
    );
  }
}
