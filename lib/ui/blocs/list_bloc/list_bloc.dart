import 'package:flutter_bloc/flutter_bloc.dart';
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
    final int nextPageNumber = state.data.pageNumber + 1;
    return await _handleFetchOfPage(nextPageNumber, emitter);
  }

  Future<void> _onShowPrevPageEvent(ShowPrevPageEvent event, Emitter<ListState> emitter) async {
    final int prevPageNumber = state.data.pageNumber - 1;
    return await _handleFetchOfPage(prevPageNumber, emitter);
  }

  Future<void> _onShowExactPageEvent(ShowExactPageEvent event, Emitter<ListState> emitter) async {
    return await _handleFetchOfPage(event.pageNumber, emitter);
  }

  Future<void> _handleFetchOfPage(int pageNumber, Emitter<ListState> emitter) async {
    emitter.call(ListState.loading());
    try {
      final names = await service.fetchPokemonNamesFromPage(pageNumber);
      final newState = ListState(
        data: ListData(pageNumber: pageNumber, pokemonNames: names)
      );

      emitter.call(newState);
    } on PageNotFoundError {
      final errorState = ListState.error(errorInfo: ErrorInfo('Page number $pageNumber not found'));
      emitter.call(errorState);
    } catch(e) {
      final errorState = ListState.error(errorInfo: const ErrorInfo('Unknown error occured'));
      emitter.call(errorState);
    }
  }
}
