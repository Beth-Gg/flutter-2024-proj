import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_shopping_list/services/signup_service.dart';
import 'package:mockito/mockito.dart';
import '../../../lib/providers/authProvider.dart'; // Update with your actual path


// Mock implementation of ApiService for testing
class MockApiService extends Mock implements ApiService {}

void main() {
  // Set up the Riverpod container for testing
  setUp(() {
    final container = ProviderContainer();
    container.read(apiServiceProvider.overrideWithProvider(
        Provider((ref) => MockApiService())) as ProviderListenable);
    container.read(authProvider);
  });

  test('signUp calls ApiService signUp method', () async {
    // Create a mock context for testing
    final mockContext = MockBuildContext();

    // Obtain the AuthState provider from the container
    final authState = ProviderContainer().read(authProvider);

    // Call the signUp method with dummy values
    await authState.signUp('testUser', 'testPassword', 'testRole', mockContext);

    // Verify that the signUp method of MockApiService is called with expected arguments
    verify(MockApiService()
            .signUp('testUser', 'testPassword', 'testRole', mockContext))
        .called(1);
  });
}

// Mock implementation of BuildContext for testing
class MockBuildContext extends Mock implements BuildContext {}
