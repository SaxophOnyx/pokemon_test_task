import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon_test_task/domain/services/i_pokemon_service.dart';
import 'package:pokemon_test_task/domain/services/errors/pokemon_not_found_error.dart';
import 'package:pokemon_test_task/ui/blocs/common/state_template.dart';
import 'package:pokemon_test_task/ui/blocs/details_bloc/details_events.dart';
import 'package:pokemon_test_task/ui/blocs/details_bloc/details_state.dart';

class DetailsBloc extends Bloc<DetailsEvent, DetailsState> {
  final IPokemonService service;

  DetailsBloc({required this.service, required DetailsState initialState})
    : super(initialState) {
    on<ShowPokemonEvent>(_onShowPokemonEvent);
  }

  Future<void> _onShowPokemonEvent(ShowPokemonEvent event, Emitter<DetailsState> emitter) async {
    emitter.call(const DetailsState.loading());
    try {
      final pokemon = await service.fetchPokemonDetails(event.pageNumber, event.entryNumber);
      final newState = DetailsState(
        data: DetailsData(
          pageNumber: event.pageNumber,
          entryNumber: event.entryNumber,
          pokemon: pokemon
        )
      );

      emitter.call(newState);
    } on PokemonNotFoundError {
      const errorState = DetailsState.error(errorInfo: ErrorInfo('Pokemon not found'));
      emitter.call(errorState);
    } catch(e) {
      const errorState = DetailsState.error(errorInfo: ErrorInfo('Unknown error'));
      emitter.call(errorState);
    }
  }
}
