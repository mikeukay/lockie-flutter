import 'package:flutter/material.dart';

class LogInButton extends StatelessWidget {

  final Function onTap;

  const LogInButton({
    this.onTap,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'login',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
              child: Text(
                'Log in.',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
