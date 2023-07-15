import 'package:flutter/material.dart';

@immutable
abstract class ListEvent {
  const ListEvent();
}

class ShowNextPageEvent extends ListEvent {
  const ShowNextPageEvent();
}

class ShowPrevPageEvent extends ListEvent {
  const ShowPrevPageEvent();
}

class ShowExactPageEvent extends ListEvent {
  final int pageNumber;

  const ShowExactPageEvent(this.pageNumber);
}
