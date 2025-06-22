import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mocktail/mocktail.dart';

class MockFlutterLocalNotificationsPlugin extends Mock implements FlutterLocalNotificationsPlugin {}

void setupTestDependencies() {
  // Setup mock pour les tests
  final mockNotifications = MockFlutterLocalNotificationsPlugin();
  when(() => mockNotifications.cancel(any())).thenAnswer((_) async {});
}
