import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon_test_task/app/contracts/service/i_pokemon_service.dart';
import 'package:pokemon_test_task/ui/blocs/list_bloc/list_bloc.dart';
import 'package:pokemon_test_task/ui/blocs/list_bloc/list_events.dart';
import 'package:pokemon_test_task/ui/blocs/list_bloc/list_state.dart';
import 'package:pokemon_test_task/ui/pages/details_page.dart';
import 'package:pokemon_test_task/ui/widgets/page_number_input_dialog.dart';

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
    )..add(const ShowExactPageEvent(1));
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
                return const Text('Loading...');
              }

              if (state.error != null) {
                return const Text('Error...');
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
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _onSelectPagePressed(context),
          shape: const BeveledRectangleBorder(),
          label: const Text('Select Page'),
        )
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context, ListState state) {
    return const Center(
      child: CircularProgressIndicator()
    );
  }

  Widget _buildErrorState(BuildContext context, ListState state) {
    return Center(
      child: Text(
        'Page Not Found',
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }

  Widget _buildNormalState(BuildContext context, ListState state) {
    return GestureDetector(
      onHorizontalDragEnd: (details) => _onListHorizontalDragEnd(context, details),
      child: ListView.builder(
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
        constraints: const BoxConstraints(minHeight: 50),
        color: (index % 2 == 0) ? null : const Color.fromARGB(255, 230, 230, 230),
        child: Text(
          pokemonName,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }

  void _onListHorizontalDragEnd(BuildContext context, DragEndDetails details) {
    if (details.primaryVelocity != null) {
      final currPageNumber = bloc.state.data.pageNumber;
      if (details.primaryVelocity! < 0) {
        bloc.add(const ShowNextPageEvent());
      } else {
        if (currPageNumber > 1) {
          bloc.add(const ShowPrevPageEvent());
        }
      }
    }
  }

  Future<void> _onSelectPagePressed(BuildContext context) async {
    final pageNumber = await showDialog<int?>(
      context: context,
      builder: (context) => const PageNumberInputDialog(),
    );

    if (pageNumber != null) {
      bloc.add(ShowExactPageEvent(pageNumber));
    }
  }
}
