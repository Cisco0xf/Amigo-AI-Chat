// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_history_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MessageModelAdapter extends TypeAdapter<MessageModel> {
  @override
  final int typeId = 0;

  @override
  MessageModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MessageModel(
      userMessage: fields[1] as String,
      aiResponse: fields[2] as String,
      messageTime: fields[3] as DateTime,
      userImage: fields[4] as Uint8List?,
      path: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MessageModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userMessage)
      ..writeByte(2)
      ..write(obj.aiResponse)
      ..writeByte(3)
      ..write(obj.messageTime)
      ..writeByte(4)
      ..write(obj.userImage)
      ..writeByte(5)
      ..write(obj.path);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
