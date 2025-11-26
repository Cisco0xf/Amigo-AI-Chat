// ignore_for_file: constant_identifier_names

/* import 'dart:developer';

import 'package:amigo/data_layer/ai_models/ai_history_model.dart';
import 'package:amigo/data_layer/database/local_repository.dart';
import 'package:hive/hive.dart';

class AiHistoryDatabase implements LocalRepository {
  final String _aiHistoryBoxName = "AI_HISTORY_CHAT_7780";
  @override
  Future<Box> get openHiveBox async {
    final Box box = await Hive.openBox<AIHistoryModel>(_aiHistoryBoxName);

    return box;
  }

  @override
  Future<List<AIHistoryModel>> getHistoryFromDatabse({
    required Box box,
  }) async {
    List<AIHistoryModel> historyChat =
        box.values.toList() as List<AIHistoryModel>;

    return historyChat;
  }

  @override
  Future<void> addNewMessage({
    required Box box,
    required AIHistoryModel message,
  }) async {
    try {
      await box.add(message);
    } catch (error) {
      log("You Fucke Up : $error");
    }
  }

  @override
  Future<void> clearHistory({required Box box}) async {
    await box.clear();
  }
}
 */

import 'package:amigo/commons/my_logger.dart';
import 'package:amigo/commons/navigation_key.dart';
import 'package:amigo/data_layer/ai_models/ai_history_model.dart';
import 'package:amigo/statemanagement_layer/manage_AI_bot/ai_fitness_provider.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

abstract interface class ChatRepo {
  Future<Box> get openBox;

  List<MessageModel> getMessagesFromDB({required Box box});

  Future<void> addMessageToDatabase({
    required Box box,
    required MessageModel message,
  });

  Future<void> removeMessageFromDatabase({
    required Box box,
    required MessageModel message,
  });

  Future<void> clearDb({required Box box});
}

class HiveKeys {
  static const String CHAT_HISTORY_KEY = "nfoKNON-NIN_mni 843";
}

class ChatDatabase implements ChatRepo {
  @override
  Future<Box> get openBox async {
    final Box box = await Hive.openBox<MessageModel>(HiveKeys.CHAT_HISTORY_KEY);

    return box;
  }

  @override
  List<MessageModel> getMessagesFromDB({required Box box}) {
    final List<MessageModel> db = box.values.toList() as List<MessageModel>;

    return db;
  }

  @override
  Future<void> addMessageToDatabase({
    required Box box,
    required MessageModel message,
  }) async {
    await box.put(message.id, message);
  }

  @override
  Future<void> removeMessageFromDatabase({
    required Box box,
    required MessageModel message,
  }) async {
    await box.delete(message.id);
  }

  @override
  Future<void> clearDb({required Box box}) async {
    await box.clear();
  }
}

class ManageChatHistoryDb {
  static ChatRepo get _chatHistory => ChatDatabase();

  static Future<void> addNewMessage({required MessageModel msg}) async {
    final Box box = await _chatHistory.openBox;

    try {
      await _chatHistory.addMessageToDatabase(box: box, message: msg);
      Log.log("Message has been added to database...");
    } catch (error) {
      Log.error('Adding New DB mesg Error => $error');
    }
  }

  static Future<void> removeMessage({required MessageModel msg}) async {
    final Box box = await _chatHistory.openBox;

    try {
      await _chatHistory.removeMessageFromDatabase(box: box, message: msg);
    } catch (error) {
      Log.error('Remove form DB mesg Error => $error');
    }
  }

  static Future<void> initializeChathistoryFromDB(BuildContext context) async {
    final Box box = await _chatHistory.openBox;

    final List<MessageModel> chatDb = _chatHistory.getMessagesFromDB(box: box);

    navigatorKey.currentContext!
        .read<ManageAiProvider>()
        .initializeCurrentChatFromDBHistory(db: chatDb);
  }

  static Future<void> clearDb() async {
    final Box box = await _chatHistory.openBox;

    await _chatHistory.clearDb(box: box);
  }
}

class InitDatabases {
  static Future<void> initDatabases(BuildContext context) async {
    await ManageChatHistoryDb.initializeChathistoryFromDB(context);
    Log.log("Database has been initialized successfully..");
  }
}
