import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskapp/features/auth/data/datasources/auth_local_data_source.dart';

// Mock class for SharedPreferences
class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late AuthLocalDataSourceImplementation authLocalDataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    authLocalDataSource = AuthLocalDataSourceImplementation(mockSharedPreferences);
  });

  group('AuthLocalDataSourceImplementation', () {
    const testUserId = 'user_1';

    test('saveUserId should save the userId successfully', () async {
      // Arrange
      when(() => mockSharedPreferences.setString(any(), any())).thenAnswer((_) async => true);

      // Act
      await authLocalDataSource.saveUserId(testUserId);

      // Assert
      verify(() => mockSharedPreferences.setString('userId', testUserId)).called(1);
    });

    test('getUserId should return the saved userId', () async {
      // Arrange
      when(() => mockSharedPreferences.getString(any())).thenReturn(testUserId);

      // Act
      final result = await authLocalDataSource.getUserId();

      // Assert
      expect(result, testUserId);
      verify(() => mockSharedPreferences.getString('userId')).called(1);
    });

    test('getUserId should return null if no userId is saved', () async {
      // Arrange
      when(() => mockSharedPreferences.getString(any())).thenReturn(null);

      // Act
      final result = await authLocalDataSource.getUserId();

      // Assert
      expect(result, isNull);
      verify(() => mockSharedPreferences.getString('userId')).called(1);
    });

    test('clearUserId should remove the userId successfully', () async {
      // Arrange
      when(() => mockSharedPreferences.remove(any())).thenAnswer((_) async => true);

      // Act
      await authLocalDataSource.clearUserId();

      // Assert
      verify(() => mockSharedPreferences.remove('userId')).called(1);
    });
  });
}
