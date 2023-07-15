import 'package:flutter/material.dart';

@immutable
abstract class DetailsEvent {
  const DetailsEvent();
}

class ShowPokemonEvent extends DetailsEvent {
  final int pageNumber;
  final int entryNumber;

  const ShowPokemonEvent(this.pageNumber, this.entryNumber);
}
