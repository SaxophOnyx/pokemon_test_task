// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon_test_task/app/contracts/service/i_pokemon_service.dart';
import 'package:pokemon_test_task/domain/pokemon_type.dart';
import 'package:pokemon_test_task/ui/blocs/details_bloc/details_bloc.dart';
import 'package:pokemon_test_task/ui/blocs/details_bloc/details_events.dart';
import 'package:pokemon_test_task/ui/blocs/details_bloc/details_state.dart';

class DetailsPage extends StatefulWidget {
  final IPokemonService service;
  final int pageNumber;
  final int entryNumber;

  DetailsPage({
    required this.service,
    required this.pageNumber,
    required this.entryNumber,
    super.key
  });
  
  @override
  State<StatefulWidget> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late final DetailsBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = DetailsBloc(
      service: widget.service,
      initialState: DetailsState.loading()
    )..add(ShowPokemonEvent(widget.pageNumber, widget.entryNumber));
  }

  @override
  void dispose() {
    bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<DetailsBloc, DetailsState>(
        bloc: bloc,
        builder: (context, state) {
          if (state.isLoading) {
            return _buildLoadingState(context, state);
          }

          if (state.error != null) {
            return _buildErrorState(context, state);
          }

          return _buildNormalState(context, state);
        },
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, DetailsState state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Data is unavalialbe'),
          IconButton(
            icon: Icon(Icons.replay),
            onPressed: () => bloc.add(ShowPokemonEvent(widget.pageNumber, widget.entryNumber)),
          )
        ],
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context, DetailsState state) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildNormalState(BuildContext context, DetailsState state) {
    final pokemon = state.data.pokemon!;
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Center(
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  border: Border.all(),
                  color: Color.fromARGB(255, 240, 240, 240)
                ),
                child: Image.memory(pokemon.image),
              ),
            ),
          )
        ),
        Expanded(
          flex: 3,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Table(
              border: TableBorder.symmetric(
                inside: BorderSide(),
              ),
              children: [
                _buildTableRow(context, 'Name', pokemon.name),
                _buildTableRow(context, 'Types', _getTypesString(pokemon.types)),
                _buildTableRow(context, 'Weight (kg)', pokemon.weight.toString()),
                _buildTableRow(context, 'Height (cm)', pokemon.height.toString())
              ],
            ),
          )
        )
      ],
    );
  }

  TableRow _buildTableRow(BuildContext context, String key, String value) {
    return TableRow(
      children: [
        Container(
          alignment: Alignment.center,
          constraints: BoxConstraints(minHeight: 40),
          child: Text(key)
        ),
        Container(
          alignment: Alignment.center,
          constraints: BoxConstraints(minHeight: 40),
          child: Text(value)
        ),
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
