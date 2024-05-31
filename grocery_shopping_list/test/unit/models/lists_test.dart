import 'package:flutter_test/flutter_test.dart';
import '../../../lib/models/lists_model.dart';

void main() {
  group('GroceryList Model Test', () {
    test('GroceryList model should be instantiated correctly', () {
      final groceryList = GroceryList(
          id: '1', date: '2023-05-30', content: 'Buy milk and eggs');

      expect(groceryList.id, '1');
      expect(groceryList.date, '2023-05-30');
      expect(groceryList.content, 'Buy milk and eggs');
    });

    test('GroceryList model should be created from JSON correctly', () {
      final json = {
        '_id': '1',
        'date': '2023-05-30',
        'content': 'Buy milk and eggs'
      };
      final groceryList = GroceryList.fromJson(json);

      expect(groceryList.id, '1');
      expect(groceryList.date, '2023-05-30');
      expect(groceryList.content, 'Buy milk and eggs');
    });

    test('GroceryList model should convert to JSON correctly', () {
      final groceryList = GroceryList(
          id: '1', date: '2023-05-30', content: 'Buy milk and eggs');
      final json = groceryList.toJson();

      expect(json, {'date': '2023-05-30', 'content': 'Buy milk and eggs'});
    });
  });
}
