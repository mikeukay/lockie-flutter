import 'package:flutter/material.dart';

class Logo extends StatelessWidget {

  final double targetWidth;
  final double maxWidth = 200.0;

  const Logo({
    this.targetWidth = 150.0,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'logo',
      child: Material(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.lock_outline,
              size: targetWidth,
            ),
            Text(
              'Lockie'.toUpperCase(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
                fontSize: targetWidth / 9,
                fontStyle: FontStyle.normal,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
