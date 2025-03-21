// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipient.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecipientAdapter extends TypeAdapter<Recipient> {
  @override
  final int typeId = 0;

  @override
  Recipient read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Recipient(
      id: fields[0] as String,
      name: fields[1] as String,
      age: fields[2] as int,
      gender: fields[3] as String,
      interests: (fields[4] as List).cast<String>(),
      relationship: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Recipient obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.age)
      ..writeByte(3)
      ..write(obj.gender)
      ..writeByte(4)
      ..write(obj.interests)
      ..writeByte(5)
      ..write(obj.relationship);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecipientAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
