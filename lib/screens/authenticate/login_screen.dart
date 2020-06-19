import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockie/blocs/login_bloc/bloc.dart';
import 'package:lockie/repositories/user_repository.dart';
import 'package:lockie/screens/authenticate/login_body.dart';

class LoginScreen extends StatelessWidget {

  final UserRepository userRepository;

  LoginScreen({this.userRepository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
      create: (context) => LoginBloc(userRepository: userRepository),
      child: LoginBody(userRepository: userRepository),
    );
  }
}
