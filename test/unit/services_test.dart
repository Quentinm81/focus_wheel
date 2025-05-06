import 'package:flutter_test/flutter_test.dart';
import 'package:focus_wheel/services/hive_service.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';




void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() {
    PathProviderPlatform.instance = FakePathProviderPlatform();
    // Mock FlutterSecureStorage globally
    FlutterSecureStorage.setMockInitialValues({});
  });
  test('HiveService initSecure does not throw', () async {
    await HiveService.initSecure();
    expect(true, isTrue);
  });
}

class FakePathProviderPlatform extends PathProviderPlatform {
  @override
  Future<String?> getApplicationDocumentsPath() async {
    return '.';
  }
}

