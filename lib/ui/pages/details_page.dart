import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon_test_task/domain/services/i_pokemon_service.dart';
import 'package:pokemon_test_task/domain/models/pokemon_type.dart';
import 'package:pokemon_test_task/ui/blocs/details_bloc/details_bloc.dart';
import 'package:pokemon_test_task/ui/blocs/details_bloc/details_events.dart';
import 'package:pokemon_test_task/ui/blocs/details_bloc/details_state.dart';

class DetailsPage extends StatefulWidget {
  final IPokemonService service;
  final int pageNumber;
  final int entryNumber;

  const DetailsPage({
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
      initialState: const DetailsState.loading()
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
          const Text('Data is unavalialbe'),
          IconButton(
            icon: const Icon(Icons.replay),
            onPressed: () => bloc.add(ShowPokemonEvent(widget.pageNumber, widget.entryNumber)),
          )
        ],
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context, DetailsState state) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildNormalState(BuildContext context, DetailsState state) {
    final pokemon = state.data.pokemon!;
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
            alignment: Alignment.center,
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  border: Border.all(),
                  color: const Color.fromARGB(255, 240, 240, 240)
                ),
                child: Image.memory(pokemon.image),
              ),
            ),
          )
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 30),
          child: Text(
            pokemon.name,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context).primaryColor
            )
          ),
        ),
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Table(
              children: [
                _buildTableRow(context, 'Type(s)', _getTypesString(pokemon.types)),
                _buildTableRow(context, 'Height (cm)', '${pokemon.height}'),
                _buildTableRow(context, 'Weight (kg)', '${pokemon.weight}'),
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
