import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:shuttler_flutter/models/notification.dart' as N;

class NotificationTile extends StatelessWidget {
  const NotificationTile({
    Key key,
    this.onPressed,
    this.notification,
  })  : assert(notification != null),
        super(key: key);

  final VoidCallback onPressed;
  final N.Notification notification;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        title: Text(
          notification.title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(notification.description),
      ),
    );
  }
}
