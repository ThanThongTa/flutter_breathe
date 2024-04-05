// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preset.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PresetAdapter extends TypeAdapter<Preset> {
  @override
  final int typeId = 1;

  @override
  Preset read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Preset(
      name: fields[6] as String,
      showTexts: fields[1] as dynamic,
      showCount: fields[2] as dynamic,
      skipHolds: fields[3] as dynamic,
      isFavorite: fields[4] as dynamic,
      isStart: fields[5] as dynamic,
      durationsInSeconds: (fields[7] as Map?)?.cast<CirclePhase, double>(),
      texts: (fields[8] as Map?)?.cast<CirclePhase, String>(),
      breathsBeforeRetention: fields[9] as dynamic,
      hasRetention: fields[10] as dynamic,
      selectedBreathSpeedBeforeRetention: fields[11] as dynamic,
      key: fields[12] as String?,
    )..child = fields[0] as Widget?;
  }

  @override
  void write(BinaryWriter writer, Preset obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.child)
      ..writeByte(1)
      ..write(obj.showTexts)
      ..writeByte(2)
      ..write(obj.showCount)
      ..writeByte(3)
      ..write(obj.skipHolds)
      ..writeByte(4)
      ..write(obj.isFavorite)
      ..writeByte(5)
      ..write(obj.isStart)
      ..writeByte(6)
      ..write(obj.name)
      ..writeByte(7)
      ..write(obj.durationsInSeconds)
      ..writeByte(8)
      ..write(obj.texts)
      ..writeByte(9)
      ..write(obj.breathsBeforeRetention)
      ..writeByte(10)
      ..write(obj.hasRetention)
      ..writeByte(11)
      ..write(obj.selectedBreathSpeedBeforeRetention)
      ..writeByte(12)
      ..write(obj.key);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PresetAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
