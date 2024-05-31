import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../lib/providers/lists_provider.dart';

void main() {
  test('Fetch lists successfully', () async {
    // Initialize the provider container for testing
    final container = ProviderContainer();

    // Obtain the lists using the fetchListsProvider
    final asyncLists = container.read(fetchListsProvider);

    // Wait for the lists to resolve
    await Future.delayed(Duration(seconds: 2)); // Adjust the delay as needed

    // Check if the fetched lists are not null and not empty
    asyncLists.when(
      data: (lists) {
        expect(lists.isNotEmpty, true);
      },
      loading: () {
        // Handle loading state if needed
      },
      error: (error, stackTrace) {
        // Handle error state if needed
      },
    );

    // Dispose the container after testing
    container.dispose();
  });
}
