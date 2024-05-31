import 'package:flutter_test/flutter_test.dart';
import '../../../lib/models/shops_model.dart';

void main() {
  group('Shop Model Test', () {
    test('Shop model should be instantiated correctly', () {
      final shop = Shop(id: '1', name: 'Shop 1', items: 'Item 1');

      expect(shop.id, '1');
      expect(shop.name, 'Shop 1');
      expect(shop.items, 'Item 1');
    });

    test('Shop model should be created from JSON correctly', () {
      final json = {'id': '1', 'name': 'Shop 1', 'items': 'Item 1'};
      final shop = Shop.fromJson(json);

      expect(shop.id, '1');
      expect(shop.name, 'Shop 1');
      expect(shop.items, 'Item 1');
    });

    test('Shop model should convert to JSON correctly', () {
      final shop = Shop(id: '1', name: 'Shop 1', items: 'Item 1');
      final json = shop.toJson();

      expect(json, {'name': 'Shop 1', 'items': 'Item 1'});
    });
  });
}
