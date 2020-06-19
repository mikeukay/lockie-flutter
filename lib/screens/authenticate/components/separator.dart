import 'package:flutter/material.dart';
import 'package:lockie/screens/constants.dart';

class Separator extends StatelessWidget {

  final double width;

  const Separator({
    this.width = 100.0,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        width: width,
        height: 2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: kPrimaryColor,
        ),
      ),
    );
  }
}