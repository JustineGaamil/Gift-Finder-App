// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gift.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GiftAdapter extends TypeAdapter<Gift> {
  @override
  final int typeId = 1;

  @override
  Gift read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Gift(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      price: fields[3] as double,
      category: fields[4] as String,
      occasions: (fields[5] as List).cast<String>(),
      interests: (fields[6] as List).cast<String>(),
      imagePath: fields[7] as String,
      isAvailable: fields[8] as bool,
      availabilityType: fields[9] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Gift obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.occasions)
      ..writeByte(6)
      ..write(obj.interests)
      ..writeByte(7)
      ..write(obj.imagePath)
      ..writeByte(8)
      ..write(obj.isAvailable)
      ..writeByte(9)
      ..write(obj.availabilityType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GiftAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
