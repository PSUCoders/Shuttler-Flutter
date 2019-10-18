import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shuttler_flutter/providers/notification_state.dart';
import 'package:shuttler_flutter/widgets/notification_tile.dart';

/// Notification Screen
class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final notifications =
        Provider.of<NotificationState>(context).notifications ?? [];
    print('notifications $notifications');

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Nofitications'),
      ),
      child: SafeArea(
        child: Container(
          color: Colors.grey[200],
          child: ListView.builder(
            itemCount:
                notifications.isNotEmpty ? notifications.length * 2 - 1 : 0,
            itemBuilder: (context, index) {
              if (index.isOdd) return Divider();

              return NotificationTile(notification: notifications[index ~/ 2]);
            },
          ),
        ),
      ),
    );
  }
}
