import 'package:flutter/material.dart';

Color kBackgroundColor = Colors.blue;
Color kPrimaryColor = Colors.white;
Color kCommentColor = Colors.grey[500];

InputDecoration kInputDecoration = InputDecoration(
  filled: false,
  contentPadding: EdgeInsets.all(12.0),
  enabledBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: kPrimaryColor, width: 2.5),
  ),
  focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: kPrimaryColor, width: 4.0),
  ),
  hintStyle: TextStyle(color: kPrimaryColor),
);

InputDecoration kInputDecorationRev = InputDecoration(
  filled: false,
  contentPadding: EdgeInsets.all(8.0),
  enabledBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: kBackgroundColor, width: 2.0),
  ),
  focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: kBackgroundColor, width: 3.0),
  ),
  hintStyle: TextStyle(color: kCommentColor),
  labelStyle: TextStyle(color: kCommentColor)
);