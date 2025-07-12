import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:flutter_test/flutter_test.dart';
import 'package:focus_wheel/models/event.dart';
import 'package:focus_wheel/models/event_type.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<void> setupTestHive() async {
  final tempDir = await path_provider.getTemporaryDirectory();
  Hive.init(tempDir.path);
  if (!Hive.isAdapterRegistered(EventTypeAdapter().typeId)) {
    Hive.registerAdapter(EventTypeAdapter());
  }
  if (!Hive.isAdapterRegistered(EventAdapter().typeId)) {
    Hive.registerAdapter(EventAdapter());
  }
  await Hive.openBox<Event>('events');
}

void setupTestSecureStorage() {
  FlutterSecureStorage.setMockInitialValues({});
}

Future<void> cleanupTestHive() async {
  await Hive.deleteFromDisk();
}
