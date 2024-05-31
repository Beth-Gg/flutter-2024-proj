import 'package:flutter_test/flutter_test.dart';
import 'package:grocery_shopping_list/repositories/shop_repositoriy.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Import your controller and other dependencies
import '../../../lib/controllers/shops_controllers.dart';
import '../../../lib/models/shops_model.dart';

class MockShopRepository extends Mock implements ShopRepository {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  group('ShopsNotifier', () {
    late ShopsNotifier shopsNotifier;
    late MockShopRepository mockShopRepository;
    late MockSharedPreferences mockSharedPreferences;

    setUp(() {
      mockShopRepository = MockShopRepository();
      mockSharedPreferences = MockSharedPreferences();
      shopsNotifier = ShopsNotifier(mockShopRepository);
    });

    // Test for addShop method
    test('addShop - Success', () async {
      final String newShopName = 'New Shop';
      final String newShopItems = 'Item 1, Item 2';

      // Mock successful response from addShop
      final String newShopId = '123'; // Mocked new shop ID
      when(mockShopRepository.addShop(newShopName, newShopItems))
          .thenAnswer((_) async => newShopId);

      // Trigger addShop and wait for completion
      await shopsNotifier.addShop(newShopName, newShopItems);

      // Verify that the shop was added to state
      expect(
        shopsNotifier.state,
        contains(Shop(id: newShopId, name: newShopName, items: newShopItems)),
      );
    });

    // Test for editShop method
    test('editShop - Success', () async {
      final String shopIdToUpdate = '123'; // ID of shop to update
      final String updatedShopName = 'Updated Shop';
      final String updatedShopItems = 'New Item 1, New Item 2';

      // Mock successful response from editShop
      when(mockShopRepository.editShop(
              shopIdToUpdate, updatedShopName, updatedShopItems))
          .thenAnswer((_) async => null); // Assuming editShop returns void

      // Trigger editShop and wait for completion
      await shopsNotifier.editShop(
          shopIdToUpdate, updatedShopName, updatedShopItems);

      // Verify that the shop was updated in state
      expect(
        shopsNotifier.state,
        contains(Shop(
            id: shopIdToUpdate,
            name: updatedShopName,
            items: updatedShopItems)),
      );
    });

    // Test for deleteShop method
    test('deleteShop - Success', () async {
      final String shopIdToDelete = '123'; // ID of shop to delete

      // Mock successful response from deleteShop
      when(mockShopRepository.deleteShop(shopIdToDelete))
          .thenAnswer((_) async => null);

      // Trigger deleteShop and wait for completion
      await shopsNotifier.deleteShop(shopIdToDelete);

      // Verify that the shop was removed from state
      expect(
          shopsNotifier.state,
          isNot(contains(
              Shop(id: shopIdToDelete, name: 'Anything', items: 'Anything'))));
    });

    tearDown(() {
      // Cleanup code if needed
    });
  });
}
