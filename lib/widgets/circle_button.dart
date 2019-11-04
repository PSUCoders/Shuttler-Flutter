import 'package:flutter/material.dart';
import 'package:shuttler/utilities/theme.dart';

class CircleButton extends StatelessWidget {
  const CircleButton({
    Key key,
    @required this.onPressed,
    this.icon,
  }) : super(key: key);

  final VoidCallback onPressed;
  // final Widget icon;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: onPressed,
      color: Colors.white70,
      padding: EdgeInsets.all(10),
      shape: CircleBorder(
        side: BorderSide(
          width: 0,
          color: Colors.transparent,
        ),
      ),
      child: Icon(
        icon,
        color: ShuttlerTheme.of(context).accentColor,
      ),
    );
  }
}
