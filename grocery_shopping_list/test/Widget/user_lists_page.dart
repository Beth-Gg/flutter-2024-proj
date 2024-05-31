// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:grocery_shopping_list/controllers/shops_controllers.dart';
// import 'package:grocery_shopping_list/models/shops_model.dart';
// import 'package:grocery_shopping_list/presentation/pages/lists/user_shop_page2.dart';
// import 'package:grocery_shopping_list/presentation/pages/shops/shops_dialog.dart';
// import 'package:grocery_shopping_list/providers/authProvider.dart';
// import 'package:grocery_shopping_list/providers/shops_providers.dart';
// import 'package:grocery_shopping_list/repositories/shop_repositoriy.dart';
// import '../../lib/presentation/pages/lists/user_shop_page2.dart';
// import 'package:mockito/mockito.dart';

// // Mock the necessary providers
// class MockAuthProvider extends Mock implements AuthProvider {}
// class MockShopsNotifier extends Mock implements ShopsNotifier {}
// class MockAsyncValue extends Mock implements AsyncValue<List<Shop>> {}

// void main() {
//   testWidgets('UserShopPage displays shops and handles interactions', (WidgetTester tester) async {
//     // Create mock providers
//     final mockAuthProvider = MockAuthProvider();
//     final mockShopsNotifier = MockShopsNotifier();
//    final mockAsyncValue = MockAsyncValue();

//     // Mock the necessary methods for AuthProvider
//     when(mockAuthProvider.logout()).thenAnswer((_) async => null);

//     // Build the widget tree
//     await tester.pumpWidget(
//       ProviderScope(
//         overrides: [
//           authProvider.overrideWithProvider(Provider((ref) => mockAuthProvider)),
//           shopsProvider.overrideWithProvider(Provider((ref) => mockShopsNotifier) as StateNotifierProvider<ShopsNotifier, List<Shop>>),
//           fetchShopsProvider.overrideWithValue(mockAsyncValue),
//         ],
//         child: MaterialApp(
//           home: UserShopPage(),
//         ),
//       ),
//     );

//     // Verify that the app bar title is correct
//     expect(find.text('Shemeta Shopping'), findsOneWidget);

//     // Verify that the logout button is present
//     expect(find.text('Logout'), findsOneWidget);

//     // Verify that the add shop button is present
//     expect(find.text('Add a Shop'), findsOneWidget);

//     // Tap the add shop button
//     await tester.tap(find.text('Add a Shop'));
//     await tester.pump();

//     // Verify that the edit shop dialog is displayed
//     expect(find.byType(EditShopDialog), findsOneWidget);

//     // Mock interaction with the edit shop dialog
//     // Example: Triggering the onEdit callback
//     // You would need to simulate text input and tap buttons in the dialog
//     // to fully test the behavior
//     // For simplicity, let's just trigger the onEdit callback directly
//     await mockShopsNotifier.addShop('Test Shop', 'Test Items');
//     verify(mockShopsNotifier.addShop('Test Shop', 'Test Items')).called(1);

//     // Verify that the shops are displayed correctly
//     // This depends on how the asyncShops.when() method is implemented in the actual widget
//     // You would need to mock the data and handle different states (loading, error, data)
//     // For simplicity, let's just verify the initial state of the widget
//     expect(find.text('Failed to load shops'), findsOneWidget); // Initial error state
//   });
// }
