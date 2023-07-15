import 'package:flutter/foundation.dart';

@immutable
abstract class StateTemplate<D extends Data, E extends ErrorInfo> {
  final D data;
  final E? error;
  final bool isLoading;

  const StateTemplate({required this.data, this.error, this.isLoading = false});
}

@immutable
abstract class Data {
  const Data();
}

@immutable
class ErrorInfo {
  final String message;

  const ErrorInfo(this.message);

  const ErrorInfo.empty()
    : message = '';
}
