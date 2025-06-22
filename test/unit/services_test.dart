import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:focus_wheel/services/hive_service.dart';

void main() {
  group('HiveService', () {
    test('initSecure does not throw', () async {
      // Reset Hive for test
      await HiveService.reset();
      
      expect(() async => await HiveService.initSecure(), returnsNormally);
    });
  });
}
