// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gift_suggestion.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GiftSuggestionAdapter extends TypeAdapter<GiftSuggestion> {
  @override
  final int typeId = 4;

  @override
  GiftSuggestion read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GiftSuggestion(
      recipientId: fields[0] as String,
      giftId: fields[1] as String,
      suggestedAt: fields[2] as DateTime,
      isSelected: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, GiftSuggestion obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.recipientId)
      ..writeByte(1)
      ..write(obj.giftId)
      ..writeByte(2)
      ..write(obj.suggestedAt)
      ..writeByte(3)
      ..write(obj.isSelected);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GiftSuggestionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
