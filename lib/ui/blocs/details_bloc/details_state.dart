import 'package:pokemon_test_task/domain/pokemon.dart';
import 'package:pokemon_test_task/ui/blocs/common/state_template.dart';

class DetailsState extends StateTemplate<DetailsData, ErrorInfo> {
  const DetailsState({
    required super.data,
    super.error,
    super.isLoading
  });

  const DetailsState.loading()
    : super(data: const DetailsData.empty(), isLoading: true);

  const DetailsState.error({ErrorInfo? errorInfo})
    : super(data: const DetailsData.empty(), error: errorInfo ?? const ErrorInfo.empty());
}

class DetailsData extends Data {
  final int pageNumber;
  final int entryNumber;
  final Pokemon? pokemon;

  const DetailsData({
    required this.pageNumber,
    required this.entryNumber,
    required Pokemon this.pokemon
  });

  const DetailsData.empty()
    : pageNumber = 0, entryNumber = 0, pokemon = null;
}