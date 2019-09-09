import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomFlatButton extends StatelessWidget {
  const CustomFlatButton({
    Key key,
    this.onPressed,
    this.label = "",
  }) : super(key: key);

  final VoidCallback onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
        pressedOpacity: 0.5,
        borderRadius: BorderRadius.circular(30.0),
        color: Color(0xFFF2014B),
        onPressed: onPressed,
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ));
  }
}
