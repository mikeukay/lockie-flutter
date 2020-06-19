import 'package:flutter/material.dart';
import 'package:lockie/models/code.dart';

import 'components/otp_widget.dart';

void showCodeBottomSheet(BuildContext ctx, Code code) {
  showModalBottomSheet(
      context: ctx,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(bottom: 32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 16.0),
              Text(
                  code.name,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
              ),
              SizedBox(height: 32.0),
              OtpWidget(otpSeed: code.seed),
            ],
          ),
        );
      }
  );
}