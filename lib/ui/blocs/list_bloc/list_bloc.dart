// ignore_for_file: prefer_const_constructors

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon_test_task/domain/services/errors/data_error.dart';
import 'package:pokemon_test_task/domain/services/i_pokemon_service.dart';
import 'package:pokemon_test_task/domain/services/errors/page_not_found_error.dart';
import 'package:pokemon_test_task/ui/blocs/common/state_template.dart';
import 'package:pokemon_test_task/ui/blocs/list_bloc/list_events.dart';
import 'package:pokemon_test_task/ui/blocs/list_bloc/list_state.dart';

class ListBloc extends Bloc<ListEvent, ListState> {
  final IPokemonService service;

  ListBloc({required this.service, required ListState initialState})
    : super(initialState) {
    on<ShowNextPageEvent>(_onShowNextPageEvent);
    on<ShowPrevPageEvent>(_onShowPrevPageEvent);
    on<ShowExactPageEvent>(_onShowExactPageEvent);
  }

  Future<void> _onShowNextPageEvent(ShowNextPageEvent event, Emitter<ListState> emitter) async {
    emitter.call(state.copyWith(isLoading: true, error: null));

    final int nextPageNumber = state.data.pageNumber + 1;
    final names = await _handleFetchingPokemonNames(nextPageNumber, emitter);

    if (names != null) {
      emitter.call(ListState(
        data: ListData(
          pageNumber: nextPageNumber,
          // pokemonNames: List.from(state.data.pokemonNames)..addAll(names)
          pokemonNames: names
        )
      ));
    }
  }

  Future<void> _onShowPrevPageEvent(ShowPrevPageEvent event, Emitter<ListState> emitter) async {
    emitter.call(state.copyWith(isLoading: true, error: null));

    final int prevPageNumber = state.data.pageNumber - 1;
    final names = await _handleFetchingPokemonNames(prevPageNumber, emitter);

    if (names != null) {
      emitter.call(ListState(
        data: ListData(
          pageNumber: prevPageNumber,
          // pokemonNames: List.from(names)..addAll(state.data.pokemonNames)
          pokemonNames: names
        )
      ));
    }
  }

  Future<void> _onShowExactPageEvent(ShowExactPageEvent event, Emitter<ListState> emitter) async {
    emitter.call(state.copyWith(isLoading: true, error: null));

    final names = await _handleFetchingPokemonNames(event.pageNumber, emitter);

    if (names != null) {
      emitter.call(ListState(
        data: ListData(
          pageNumber: event.pageNumber,
          pokemonNames: names
        )
      ));
    }
  }

  Future<List<String>?> _handleFetchingPokemonNames(int pageNumber, Emitter<ListState> emitter) async {
    try {
      return await service.fetchPokemonNamesFromPage(pageNumber);

    } on PageNotFoundError {
      emitter.call(ListState.error(errorInfo: ErrorInfo('Page $pageNumber not found')));

    } on DataError {
      emitter.call(ListState.error(errorInfo: ErrorInfo('Data error occured')));

    } catch(e) {
      emitter.call(ListState.error(errorInfo: ErrorInfo('Unknown error occured')));
    }

    return null;
  }
}
