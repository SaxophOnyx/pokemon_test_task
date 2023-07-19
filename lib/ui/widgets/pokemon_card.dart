// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

class PokemonCard extends StatelessWidget {
  final String pokemonName;
  final void Function()? onTap;
  final Color? color;

  PokemonCard({
    super.key,
    required this.pokemonName,
    this.onTap,
    this.color
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: BoxConstraints(minHeight: 60),
        padding: EdgeInsets.all(15),
        color: color,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            pokemonName,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ),
    );
  }
}
