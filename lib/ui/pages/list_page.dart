// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon_test_task/app/contracts/service/i_pokemon_service.dart';
import 'package:pokemon_test_task/ui/blocs/list_bloc/list_bloc.dart';
import 'package:pokemon_test_task/ui/blocs/list_bloc/list_events.dart';
import 'package:pokemon_test_task/ui/blocs/list_bloc/list_state.dart';
import 'package:pokemon_test_task/ui/pages/details_page.dart';

class ListPage extends StatefulWidget {
  final IPokemonService service;

  const ListPage({required this.service, super.key});
  
  @override
  State<StatefulWidget> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  late final ListBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = ListBloc(
      service: widget.service,
      initialState: ListState.loading()
    )..add(ShowExactPageEvent(1));
  }

  @override
  void dispose() {
    bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: BlocBuilder<ListBloc, ListState>(
            bloc: bloc,
            builder: (context, state) {
              if (state.isLoading) {
                return Text('Loading...');
              }

              if (state.error != null) {
                return Text('');
              }

              return Text('Page ${state.data.pageNumber}');
            },
          ),
        ),
        body: BlocBuilder<ListBloc, ListState>(
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
        )
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context, ListState state) {
    return Center(
      child: CircularProgressIndicator()
    );
  }

  Widget _buildErrorState(BuildContext context, ListState state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('An error occured!'),
          ElevatedButton(
            onPressed: () => bloc.add(ShowExactPageEvent(1)),
            child: Text('Try reload')
          )
        ],
      ),
    );
  }

  Widget _buildNormalState(BuildContext context, ListState state) {
    return GestureDetector(
      onHorizontalDragEnd: (details) => _onListHorizontalDragEnd(context, details),
      child: ListView.builder(
        padding: EdgeInsets.only(bottom: 5),
        itemCount: state.data.pokemonNames.length,
        itemBuilder: (context, index) => _buildListItem(context, index, state.data.pokemonNames[index])
      ),
    );
  }

  Widget _buildListItem(BuildContext context, int index, String pokemonName) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => DetailsPage(
            service: widget.service,
            pageNumber: bloc.state.data.pageNumber,
            entryNumber: index + 1,
          ),
        ));
      },
      child: Container(
        alignment: Alignment.center,
        constraints: BoxConstraints(minHeight: 50),
        decoration: BoxDecoration(
          border: Border.all(),
          color: (index % 2 == 0) ? null : Color.fromARGB(255, 230, 230, 230)
        ),
        margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
        child: Text(pokemonName),
      ),
    );
  }

  void _onListHorizontalDragEnd(BuildContext context, DragEndDetails details) {
    if (details.primaryVelocity != null) {
      debugPrint('Dragged');
      final currPageNumber = bloc.state.data.pageNumber;

      if (details.primaryVelocity! < 0) {
        bloc.add(ShowNextPageEvent());
      } else {
        if (currPageNumber > 1) {
          bloc.add(ShowPrevPageEvent());
        }
      }
    }
  }
}
