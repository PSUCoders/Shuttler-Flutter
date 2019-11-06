import 'package:flutter/material.dart';

class ShuttlerLogo extends StatelessWidget {
  const ShuttlerLogo({
    Key key,
    this.size = 150,
  }) : super(key: key);

  final double size;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(180),
      child: Container(
        width: size,
        padding: EdgeInsets.all(size / 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(180),
          color: Colors.white,
        ),
        child: Container(
          child: AspectRatio(
            aspectRatio: 1,
            child: Image.asset(
              "assets/icons/shuttler_logo_labeled.png",
            ),
          ),
        ),
      ),
    );
  }
}
