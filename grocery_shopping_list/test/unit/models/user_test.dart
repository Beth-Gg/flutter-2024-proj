import 'package:flutter_test/flutter_test.dart';
import '../../../lib/models/user.dart';

void main() {
  group('User Model Test', () {
    test('User model should be instantiated correctly', () {
      final user = User('testUser', 'testLocation', ['item1', 'item2']);

      print('Running instantiation test...');
      expect(user.username, 'testUser');
      expect(user.location, 'testLocation');
      expect(user.items, ['item1', 'item2']);
      print('Instantiation test passed.');
    });

    test('User model properties should be accessible', () {
      final user = User('anotherUser', 'anotherLocation', ['itemA', 'itemB']);

      print('Running property access test...');
      expect(user.username, isNotEmpty);
      expect(user.location, isNotEmpty);
      expect(user.items, isList);
      expect(user.items.length, 2);
      print('Property access test passed.');
    });
  });
}
