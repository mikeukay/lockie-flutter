import 'package:flutter/material.dart';
import 'package:lockie/screens/constants.dart';

class SignUpButton extends StatelessWidget {

  final Function onTap;

  const SignUpButton({
    this.onTap,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'signup',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          child: Container(
              width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: kPrimaryColor
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                child: Text(
                    'Sign Up',
                    style: TextStyle(
                      color: kBackgroundColor,
                      fontSize: 25,
                    ),
                  textAlign: TextAlign.center,
                ),
              )
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}