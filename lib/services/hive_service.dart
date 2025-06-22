import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import '../models/event.dart';
import '../models/task.dart';
import '../models/reminder.dart';
import '../models/mood.dart';
import '../models/timer_session.dart';
import '../models/quote.dart';

class HiveService {
  static const _hiveKeyName = 'hive_encryption_key';
  static final _secureStorage = const FlutterSecureStorage();

  static Future<List<int>> _getEncryptionKey() async {
    String? base64Key = await _secureStorage.read(key: _hiveKeyName);
    if (base64Key == null) {
      throw Exception('Encryption key not found in secure storage');
    }
    return base64Decode(base64Key);
  }

  static Future<void> initSecure() async {
    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    Hive.registerAdapter(EventAdapter());
    Hive.registerAdapter(TaskAdapter());
    Hive.registerAdapter(TaskStatusAdapter());
    Hive.registerAdapter(ReminderAdapter());
    Hive.registerAdapter(MoodEntryAdapter());
    Hive.registerAdapter(MoodStatusAdapter());
    Hive.registerAdapter(TimerSessionAdapter());
    Hive.registerAdapter(MotivationalQuoteAdapter());
    Hive.registerAdapter(QuoteCategoryAdapter());

    final key = await _getEncryptionKey();
    await Hive.openBox<Event>('agendaBox',
        encryptionCipher: HiveAesCipher(key));
    await Hive.openBox<Task>('tasksBox', encryptionCipher: HiveAesCipher(key));
    await Hive.openBox<Reminder>('remindersBox',
        encryptionCipher: HiveAesCipher(key));
    await Hive.openBox<MoodEntry>('moodBox',
        encryptionCipher: HiveAesCipher(key));
    await Hive.openBox<TimerSession>('timerBox',
        encryptionCipher: HiveAesCipher(key));
    await Hive.openBox('settingsBox', encryptionCipher: HiveAesCipher(key));
  }

  static Future<void> deleteAllData() async {
    await Hive.deleteFromDisk();
    await _secureStorage.delete(key: _hiveKeyName);
  }
}

  static Future<void> reset() async {
    await Hive.close();
    _initialized = false;
  }
