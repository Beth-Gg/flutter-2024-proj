import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Infrastructure/api_service.dart';
import 'login_page.dart';
import '../Application/bloc/Login/Login_bloc.dart';
import '../Application/bloc/Login/Login_state.dart';
import '../Application/bloc/Login/Login_event.dart';


class SignUpScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up Screen'),
      ),
      body: BlocProvider(
        create: (context) => RoleBloc(),
        child: SignUpForm(
          formKey: _formKey,
          usernameController: _usernameController,
          passwordController: _passwordController,
        ),
      ),
    );
  }
}

class SignUpForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController usernameController;
  final TextEditingController passwordController;

  const SignUpForm({
    Key? key,
    required this.formKey,
    required this.usernameController,
    required this.passwordController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset("/assets/pic.svg"),
            SizedBox(height: 20),
            Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: usernameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a username';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  BlocBuilder<RoleBloc, RoleState>(
                    builder: (context, state) {
                      return SwitchListTile(
                        title: Text('Admin'),
                        value: state.isAdmin,
                        onChanged: (value) {
                          context.read<RoleBloc>().add(ToggleAdminEvent());
                        },
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        try {
                          final response = await ApiService().signUp(
                            usernameController.text,
                            passwordController.text,
                            context.read<RoleBloc>().state.isAdmin? 'admin' : 'user',
                          );
                          if (response.statusCode == 201) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Sign up failed. Please try again.'),
                              ),
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Sign up failed. Please try again.'),
                            ),
                          );
                        }
                      }
                    },
                    child: Text('Sign Up'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// RoleBloc
