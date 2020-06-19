import 'package:flutter/material.dart';

import 'separator.dart';

class OrSeparator extends StatelessWidget {
  const OrSeparator({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Separator(),
        Text(
          'OR',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        Separator(),
      ],
    );
  }
}