import 'package:flutter/cupertino.dart' hide Notification;
import 'package:flutter/material.dart' hide Notification;
import 'package:intl/intl.dart';
import 'package:shuttler/models/notification.dart';
import 'package:shuttler/utilities/theme.dart';

class NotificationTile extends StatelessWidget {
  const NotificationTile({
    Key key,
    this.onPressed,
    this.notification,
  })  : assert(notification != null),
        super(key: key);

  final VoidCallback onPressed;
  final Notification notification;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Title of the notification
                Expanded(
                  child: Text(
                    notification.title,
                    style: ShuttlerTheme.of(context).textTheme.headline,
                  ),
                ),
                // Description of the notification
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    notification.description,
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: Text(
                      DateFormat("EEEE, MMM dd, yyyy '•' h:mm a")
                          .format(this.notification.date),
                      style: ShuttlerTheme.of(context).textTheme.display1,
                    ),
                  ),
                ),
                Icon(
                  this.notification.seen
                      ? Icons.check_circle
                      : Icons.check_circle_outline,
                  size: 14,
                  color: Colors.black54,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
