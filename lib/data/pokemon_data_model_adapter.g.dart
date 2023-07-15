// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

import 'dart:typed_data';

import 'package:hive_flutter/hive_flutter.dart';

import 'pokemon_data_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PokemonDataModelAdapter extends TypeAdapter<PokemonDataModel> {
  @override
  final int typeId = 0;

  @override
  PokemonDataModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PokemonDataModel(
      fields[0] as String,
      (fields[1] as List).cast<String>(),
      fields[2] as double,
      fields[3] as int,
      fields[4] as Uint8List,
    );
  }

  @override
  void write(BinaryWriter writer, PokemonDataModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.types)
      ..writeByte(2)
      ..write(obj.weight)
      ..writeByte(3)
      ..write(obj.height)
      ..writeByte(4)
      ..write(obj.image);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PokemonDataModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
