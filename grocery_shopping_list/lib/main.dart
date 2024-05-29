import 'package:flutter/material.dart';
import 'package:grocery_shopping_list/presentation/pages/login/login.dart';
import 'package:grocery_shopping_list/presentation/pages/sign_in/signup.dart';
import 'presentation/pages/lists/user_shop_page2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'presentation/pages/shops/admin_shops_page.dart';
import 'package:go_router/go_router.dart';
import './presentation/pages/lists/user_lists.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

// GoRouter configuration
final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => Signup(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: '/shops',
      builder: (context, state) => AdminShopPage(),
    ),
    GoRoute(
      path: '/userShops',
      builder: (context, state) => UserListPage(),
    ),
    GoRoute(
      path: '/userLists',
      builder: (context, state) => UserShopPage(),
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
    );
  }
}
