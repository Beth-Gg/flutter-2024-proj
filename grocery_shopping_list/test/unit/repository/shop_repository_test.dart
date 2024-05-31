import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../lib/repositories/shop_repositoriy.dart';
import '../../../lib/models/shops_model.dart';
import './shop_repository_test.mock.dart';

// Generate a MockClient and MockSharedPreferences using the Mockito package.
@GenerateMocks([http.Client, SharedPreferences])
class MockClient extends Mock implements http.Client {}

void main() {
  group('ShopRepository', () {
    late ShopRepository shopRepository;
    late MockClient mockClient;
    late MockSharedPreferences mockSharedPreferences;

    setUp(() {
      mockClient = MockClient();
      mockSharedPreferences = MockSharedPreferences();
      shopRepository =
          ShopRepository(); // Assuming ShopRepository doesn't take a client parameter
    });

    void setMockSharedPreferencesValues() {
      when(mockSharedPreferences.getString('access_token'))
          .thenReturn('mock_access_token');
      // Mock other SharedPreferences methods as needed
    }

    test('fetchAllShops returns list of Shop on success', () async {
      setMockSharedPreferencesValues();
      final mockResponse = [
        {'id': '1', 'name': 'Shop 1', 'items': 'Item 1, Item 2'}
      ];

      when(mockClient.get(any as Uri, headers: anyNamed('headers'))).thenAnswer(
          (_) async => http.Response(json.encode(mockResponse), 200));

      final result = await shopRepository.fetchAllShops();

      expect(result, isA<List<Shop>>());
      expect(result.length, 1);
      expect(result[0].id, '1');
      expect(result[0].name, 'Shop 1');
      expect(result[0].items, 'Item 1, Item 2');
    });

    test('addShop returns shop ID on success', () async {
      setMockSharedPreferencesValues();

      final mockResponse = {'id': '1'};

      when(mockClient.post(any as Uri,
              headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer(
              (_) async => http.Response(json.encode(mockResponse), 201));

      final result = await shopRepository.addShop('Shop 1', 'Item 1, Item 2');

      expect(result, '1');
    });

    test('editShop completes on success', () async {
      setMockSharedPreferencesValues();

      when(mockClient.put(any as Uri,
              headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response('', 200));

      await shopRepository.editShop('1', 'Shop 1', 'Item 1, Item 2');

      verify(mockClient.put(any as Uri,
              headers: anyNamed('headers'), body: anyNamed('body')))
          .called(1);
    });

    test('deleteShop completes on success', () async {
      setMockSharedPreferencesValues();

      when(mockClient.delete(any as Uri, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('', 204));

      await shopRepository.deleteShop('1');

      verify(mockClient.delete(any as Uri, headers: anyNamed('headers')))
          .called(1);
    });
  });
}
