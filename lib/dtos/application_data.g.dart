// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ApplicationDataAdapter extends TypeAdapter<ApplicationData> {
  @override
  final int typeId = 0;

  @override
  ApplicationData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ApplicationData(
      fields[1] as String,
      fields[0] as String,
      fields[2] as Uint8List?,
    );
  }

  @override
  void write(BinaryWriter writer, ApplicationData obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.appId)
      ..writeByte(1)
      ..write(obj.appName)
      ..writeByte(2)
      ..write(obj.icon);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ApplicationDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
