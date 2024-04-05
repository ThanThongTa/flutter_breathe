// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'circle_phase.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CirclePhaseAdapter extends TypeAdapter<CirclePhase> {
  @override
  final int typeId = 2;

  @override
  CirclePhase read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return CirclePhase.growing;
      case 1:
        return CirclePhase.holdIn;
      case 2:
        return CirclePhase.shrinking;
      case 3:
        return CirclePhase.holdOut;
      default:
        return CirclePhase.growing;
    }
  }

  @override
  void write(BinaryWriter writer, CirclePhase obj) {
    switch (obj) {
      case CirclePhase.growing:
        writer.writeByte(0);
        break;
      case CirclePhase.holdIn:
        writer.writeByte(1);
        break;
      case CirclePhase.shrinking:
        writer.writeByte(2);
        break;
      case CirclePhase.holdOut:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CirclePhaseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
