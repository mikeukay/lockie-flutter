import 'package:flutter/material.dart';
import 'package:lockie/screens/shared/logo.dart';

class SplashScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        child: Center(
            child: Logo(),
        ),
      ),
    );
  }
}

