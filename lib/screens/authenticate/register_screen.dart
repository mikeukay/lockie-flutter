import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockie/blocs/register_bloc/bloc.dart';
import 'package:lockie/repositories/user_repository.dart';
import 'package:lockie/screens/authenticate/register_body.dart';

class RegisterScreen extends StatelessWidget {

  final UserRepository userRepository;

  RegisterScreen({this.userRepository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RegisterBloc>(
      create: (context) => RegisterBloc(userRepository: userRepository),
      child: RegisterBody(userRepository: userRepository),
    );
  }
}
