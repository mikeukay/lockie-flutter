import 'package:flutter/material.dart';
import 'package:lockie/repositories/user_repository.dart';
import 'package:lockie/screens/authenticate/register_screen.dart';

import 'components/login_button.dart';
import '../shared/logo.dart';
import 'components/orseparator.dart';
import 'components/signup_button.dart';
import 'login_screen.dart';
class AuthenticateScreen extends StatelessWidget {

  final UserRepository userRepository;

  AuthenticateScreen({this.userRepository});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          width: double.infinity,
          child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Spacer(flex: 3,),
                Logo(),
                Spacer(flex: 2),
                SignUpButton(onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => RegisterScreen(userRepository: userRepository))),),
                SizedBox(height: 20),
                OrSeparator(),
                SizedBox(height: 10),
                LogInButton(onTap: () =>  Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreen(userRepository: userRepository))),),
                SizedBox(height: 16),
              ]
          ),
        )
    );
  }
}


