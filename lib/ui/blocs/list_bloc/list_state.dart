import 'package:pokemon_test_task/ui/blocs/common/state_template.dart';

class ListState extends StateTemplate<ListData, ErrorInfo> {
  const ListState({
    required super.data,
    super.error,
    super.isLoading
  });

  ListState.loading()
    : super(data: ListData.empty(), isLoading: true);

  ListState.error({ErrorInfo? errorInfo})
    : super(data: ListData.empty(), error: errorInfo ?? const ErrorInfo.empty());
}

class ListData extends Data {
  final List<String> pokemonNames;
  final int pageNumber;

  ListData({required List<String> pokemonNames, required this.pageNumber})
    : pokemonNames = List.unmodifiable(pokemonNames);

  ListData.empty()
    : pokemonNames = List.empty(), pageNumber = 0;
}
