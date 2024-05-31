import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Application/bloc/Login/Login_bloc.dart';
import 'Application/Usecase/login_usecase.dart';
import '/Presentation/shop_page.dart';
import 'Infrastructure/api_service.dart';
import 'presentation/signup_page.dart';
import 'presentation/login_page.dart';
import 'package:signup/Infrastructure/repositories/Auth_repository.dart';
import 'Application/bloc/Login/Login_state.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(apiService: ApiService()),
        ),
        BlocProvider<RoleBloc>(
          create: (context) => RoleBloc(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BLoC Demo',
      home: SignUpScreen(),
      routes: {
        '/login': (context) => BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state.isLoggedIn) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ShopPage()),
              );
            }
          },
          builder: (context, state) {
            return LoginScreen();
          },
        ),
        '/shops': (context) => ShopPage(),
      },
    );
  }
}