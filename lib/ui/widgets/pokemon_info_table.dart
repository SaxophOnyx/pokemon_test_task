import 'package:flutter/material.dart';
import 'package:pokemon_test_task/domain/models/pokemon.dart';
import 'package:pokemon_test_task/domain/models/pokemon_type.dart';

class PokemonInfoTable extends StatelessWidget {
  final Pokemon pokemon;

  const PokemonInfoTable(this.pokemon, {super.key});

  @override
  Widget build(BuildContext context) {
    return Table(
      children: [
        _buildTableRow(context, 'Type(s)', _getTypesString(pokemon.types)),
        _buildTableRow(context, 'Height (cm)', '${pokemon.height}'),
        _buildTableRow(context, 'Weight (kg)', '${pokemon.weight}'),
      ],
    );
  }

TableRow _buildTableRow(BuildContext context, String key, String value) {
    return TableRow(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          alignment: Alignment.center,
          child: Text(
            key,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 18
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          alignment: Alignment.centerLeft,
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 18
            ),
          ),
        )
      ]
    );
  }

  String _getTypesString(List<PokemonType> types) {
    var buffer = StringBuffer();
    
    if (types.isNotEmpty) {
      buffer.write(types.first.name);
      for (var type in types.skip(1)) {
        buffer.writeln();
        buffer.write(type.name);
      }
    }

    return buffer.toString();
  }
}
