import 'package:flutter/material.dart';

class PokemonCard extends StatelessWidget {
  final String pokemonName;
  final void Function()? onTap;
  final Color? color;

  const PokemonCard({
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
        constraints: const BoxConstraints(minHeight: 60),
        padding: const EdgeInsets.all(15),
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
