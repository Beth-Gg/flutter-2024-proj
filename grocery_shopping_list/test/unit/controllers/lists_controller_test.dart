import 'package:flutter_test/flutter_test.dart';
import 'package:grocery_shopping_list/controllers/lists_controller.dart';
import 'package:grocery_shopping_list/models/lists_model.dart';
import 'package:grocery_shopping_list/repositories/lists_repository.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockListRepository extends Mock implements ListRepository {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  group('ListsNotifier', () {
    late ListsNotifier listsNotifier;
    late MockListRepository mockListRepository;
    late MockSharedPreferences mockSharedPreferences;

    setUp(() {
      mockListRepository = MockListRepository();
      mockSharedPreferences = MockSharedPreferences();
      listsNotifier = ListsNotifier(mockListRepository);
    });

    // Test for fetchAllLists method
    test('fetchAllLists - Success', () async {
      final List<GroceryList> mockLists = [
        GroceryList(id: '1', date: '2023-05-30', content: 'Buy milk and eggs')
      ];

      // Mock successful response from fetchAllLists
      when(mockListRepository.fetchAllLists())
          .thenAnswer((_) async => mockLists);

      // Trigger fetchAllLists and wait for completion
      await listsNotifier.fetchAllLists();

      // Verify that the lists are added to state
      expect(listsNotifier.state, equals(mockLists));
    });

    // Test for addLists method
    test('addLists - Success', () async {
      final String newDate = '2023-05-30';
      final String newContent = 'Buy milk and eggs';

      // Mock successful response from addList
      final String newListId = '1'; // Mocked new list ID
      when(mockListRepository.addList(newDate, newContent))
          .thenAnswer((_) async => newListId);

      // Trigger addLists and wait for completion
      await listsNotifier.addLists(newDate, newContent);

      // Verify that the list was added to state
      expect(
        listsNotifier.state,
        contains(
            GroceryList(id: newListId, date: newDate, content: newContent)),
      );
    });

    // Test for editList method
    test('editList - Success', () async {
      final String listIdToUpdate = '1'; // ID of list to update
      final String updatedDate = '2023-05-31';
      final String updatedContent = 'Buy bread and milk';

      // Mock successful response from editList
      when(mockListRepository.editList(
              listIdToUpdate, updatedDate, updatedContent))
          .thenAnswer((_) async => null); // Assuming editList returns void

      // Trigger editList and wait for completion
      await listsNotifier.editList(listIdToUpdate, updatedDate, updatedContent);

      // Verify that the list was updated in state
      expect(
        listsNotifier.state,
        contains(GroceryList(
            id: listIdToUpdate, date: updatedDate, content: updatedContent)),
      );
    });

    // Test for deleteShop method
    test('deleteShop - Success', () async {
      final String listIdToDelete = '1'; // ID of list to delete

      // Mock successful response from deleteList
      when(mockListRepository.deleteList(listIdToDelete))
          .thenAnswer((_) async => null);

      // Trigger deleteShop and wait for completion
      await listsNotifier.deleteShop(listIdToDelete);

      // Verify that the list was removed from state
      expect(
          listsNotifier.state,
          isNot(contains(GroceryList(
              id: listIdToDelete, date: 'monday', content: 'onion'))));
    });

    tearDown(() {
      // Cleanup code if needed
    });
  });
}
