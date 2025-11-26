import 'dart:typed_data';

import 'package:hive/hive.dart';

part 'ai_history_model.g.dart';

@HiveType(typeId: 0)
class MessageModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String userMessage;
  @HiveField(2)
  final String aiResponse;
  @HiveField(3)
  final DateTime messageTime;
  @HiveField(4)
  final Uint8List? userImage;
  @HiveField(5)
  final String? path;

  MessageModel({
    required this.userMessage,
    required this.aiResponse,
    required this.messageTime,
    this.userImage,
    this.path, 
  }) : id = messageTime.toIso8601String();
}

