import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../../../lib/models/lists_model.dart';
import '../../../lib/repositories/lists_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'lists_repository_test.mocks.dart';

@GenerateMocks([http.Client, SharedPreferences])
void main() {
  group('ListRepository', () {
    late ListRepository listRepository;
    late MockClient mockClient;
    late MockSharedPreferences mockSharedPreferences;

    setUp(() {
      mockClient =
          MockClient(); // This MockClient is from lists_repository_test.mocks.dart
      mockSharedPreferences = MockSharedPreferences();
      listRepository = ListRepository(
          client: mockClient); // Ensure the repository uses the mock client
    });

    void setMockSharedPreferencesValues() {
      when(mockSharedPreferences.getString('access_token'))
          .thenReturn('mock_access_token');
      when(mockSharedPreferences.getString('id')).thenReturn('mock_user_id');
    }

    test('fetchAllLists returns list of GroceryList on success', () async {
      setMockSharedPreferencesValues();
      final mockResponse = [
        {'_id': '1', 'date': '2023-05-30', 'content': 'Buy milk and eggs'}
      ];

      when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
          (_) async => http.Response(json.encode(mockResponse), 200));

      final result = await listRepository.fetchAllLists();

      expect(result, isA<List<GroceryList>>());
      expect(result.length, 1);
      expect(result[0].id, '1');
      expect(result[0].date, '2023-05-30');
      expect(result[0].content, 'Buy milk and eggs');
    });

    test('addList returns list ID on success', () async {
      setMockSharedPreferencesValues();

      final mockResponse = {'id': '1'};

      when(mockClient.post(any,
              headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer(
              (_) async => http.Response(json.encode(mockResponse), 201));

      final result =
          await listRepository.addList('2023-05-30', 'Buy milk and eggs');

      expect(result, '1');
    });

    test('editList completes on success', () async {
      setMockSharedPreferencesValues();

      when(mockClient.put(any,
              headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response('', 200));

      await listRepository.editList('1', '2023-05-30', 'Buy milk and eggs');

      verify(mockClient.put(any,
              headers: anyNamed('headers'), body: anyNamed('body')))
          .called(1);
    });

    test('deleteList completes on success', () async {
      setMockSharedPreferencesValues();

      when(mockClient.delete(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('', 204));

      await listRepository.deleteList('1');

      verify(mockClient.delete(any, headers: anyNamed('headers'))).called(1);
    });
  });
}
