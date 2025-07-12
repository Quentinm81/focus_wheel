import 'package:flutter_test/flutter_test.dart';
import 'package:focus_wheel/services/hive_service.dart';
import '../helpers/test_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await setupTestHive();
    setupTestSecureStorage();
  });

  tearDown(() async {
    await cleanupTestHive();
  });

  test('HiveService initSecure does not throw', () async {
    await expectLater(HiveService.initSecure(), completes);
  });
}
