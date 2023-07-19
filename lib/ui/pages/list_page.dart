import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon_test_task/domain/services/i_pokemon_service.dart';
import 'package:pokemon_test_task/ui/blocs/list_bloc/list_bloc.dart';
import 'package:pokemon_test_task/ui/blocs/list_bloc/list_events.dart';
import 'package:pokemon_test_task/ui/blocs/list_bloc/list_state.dart';
import 'package:pokemon_test_task/ui/pages/details_page.dart';
import 'package:pokemon_test_task/ui/widgets/page_number_input_dialog.dart';
import 'package:pokemon_test_task/ui/widgets/paginated_listview.dart';
import 'package:pokemon_test_task/ui/widgets/pokemon_card.dart';

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
    return Scaffold(
      appBar: _appBarBuilder(context),
      body: _bodyBuilder(context),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _onSelectPagePressed(context),
        shape: const BeveledRectangleBorder(),
        label: const Text('Select Page'),
      )
    );
  }

  AppBar _appBarBuilder(BuildContext context) {
    return AppBar(
      title: BlocBuilder<ListBloc, ListState>(
        bloc: bloc,
        builder: (context, state) {
          if (state.isLoading) {
            return const Text('Loading...');
          }

          if (state.hasErrors) {
            return const Text('Error...');
          }

          return Text('Page ${state.data.pageNumber}');
        },
      )
    );
  }

  Widget _bodyBuilder(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<ListBloc, ListState>(
        bloc: bloc,
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
    
          if (state.hasErrors) {
            return Center(
              child: Text(
                state.error!.message,
                style: Theme.of(context).textTheme.titleLarge
              )
            );
          }
    
          return Column(
            children: [
              Expanded(
                child: PaginatedListView(
                  itemsCount: state.data.pokemonNames.length,
                  itemBuilder: (context, index) {
                    return PokemonCard(
                      pokemonName: state.data.pokemonNames[index],
                      onTap: () => _onListItemTap(state.data.pageNumber, index),
                      color: (index % 2 == 0) ? null : const Color.fromARGB(255, 230, 230, 230),
                    );
                  },
                  onPrevPageRequested: () {
                    if (bloc.state.data.pageNumber > 1) {
                      bloc.add(const ShowPrevPageEvent());
                    }
                  },
                  onNextPageRequested: () => bloc.add(const ShowNextPageEvent()),
                ),
              ),
            ],
          );
        },
      ),
    );
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

  void _onListItemTap(int pageNumber, int itemIndex) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => DetailsPage(
        service: widget.service,
        pageNumber: bloc.state.data.pageNumber,
        entryNumber: itemIndex + 1,
      ),
    ));
  }
}
