import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lockie/screens/constants.dart';
import 'package:otp/otp.dart';

class OtpWidget extends StatefulWidget {

  final String otpSeed;

  OtpWidget({this.otpSeed});

  @override
  _OtpWidgetState createState() => _OtpWidgetState();
}

class _OtpWidgetState extends State<OtpWidget> {

  Timer _timer;
  String a;

  Future<void> rebuildEverySecond() async{
    const oneSec = const Duration(seconds:1);
    new Timer.periodic(oneSec, (Timer t) => setState(() {
      _timer = t;
      a = "";
    }));
  }

  @override
  void initState() {
    super.initState();
    rebuildEverySecond();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int time = DateTime.now().millisecondsSinceEpoch;
    String code = OTP.generateTOTPCodeString(widget.otpSeed, time);
    code  = code.substring(0, 3) + " " + code.substring(3, 6);
    int roundEnd = (time / 1000  / 30).ceil() * 30 * 1000;
    int secondsLeft = ((roundEnd - time) / 1000).floor();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          code,
          style: TextStyle(
             color: kBackgroundColor,
             fontSize: 45,
          ),
        ),
        SizedBox(height: 16.0),
        Text(
          secondsLeft.toString() + ' second(s) left',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        )
      ],
    );
  }
}
