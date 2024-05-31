import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_shopping_list/controllers/shops_controllers.dart';
import 'package:grocery_shopping_list/models/shops_model.dart';
import 'package:grocery_shopping_list/presentation/pages/lists/user_shop_page2.dart';
import 'package:grocery_shopping_list/providers/authProvider.dart';
import 'package:grocery_shopping_list/providers/shops_providers.dart';
import 'package:mockito/mockito.dart';
import 'package:riverpod/src/framework.dart';

class MockAuthProvider extends Mock implements AuthProvider {}

class AuthProvider {
}

void main() {
  testWidgets('UserShopPage displays shop items', (WidgetTester tester) async {
    // Create a mock provider for AuthProvider
    final mockAuthProvider = MockAuthProvider();

    // Mock the data for shopsProvider
    final mockShops = [
      Shop(id: '1', name: 'Shop 1', items: 'Items 1, 2, 3'),
      Shop(id: '2', name: 'Shop 2', items: 'Items 4, 5, 6'),
    ];

    // Build the widget tree
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authProvider.overrideWith(Provider((ref) => mockAuthProvider) as Create<AuthState, ProviderRef<AuthState>>),
          shopsProvider.overrideWith(Provider((ref) => mockShops) as Create<ShopsNotifier, StateNotifierProviderRef<ShopsNotifier, List<Shop>>>),
        ],
        child: MaterialApp(
          home: UserShopPage(),
        ),
      ),
    );

    // Verify that the app bar title is correct
    expect(find.text('Shemeta Shopping'), findsOneWidget);

    // Verify that the shop items are displayed correctly
    expect(find.text('Shop 1'), findsOneWidget);
    expect(find.text('Items 1, 2, 3'), findsOneWidget);
    expect(find.text('Shop 2'), findsOneWidget);
    expect(find.text('Items 4, 5, 6'), findsOneWidget);

    await tester.tap(find.text('Logout'));
    await tester.pump();

  
    // verify(mockAuthProvider.logout()).called(1); 
  });
}
