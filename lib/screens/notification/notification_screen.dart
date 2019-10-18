import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:shuttler_flutter/providers/notification_state.dart';
import 'package:shuttler_flutter/widgets/notification_tile.dart';

/// Notification Screen
class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final notifications =
        Provider.of<NotificationState>(context).notifications ?? [];

    // final notifications = []; // Uncomment to mimic empty notification

    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text('Nofitications'),
      ),
      body: SafeArea(
        child: Container(
          child: notifications.isEmpty
              ? Container(
                  // TODO replace with appropriate child
                  child: Text("Empty"),
                )
              : ListView.separated(
                  itemCount: notifications.length,
                  separatorBuilder: (_, index) => Divider(),
                  itemBuilder: (context, index) {
                    return NotificationTile(
                      notification: notifications[index],
                    );
                  },
                ),
        ),
      ),
    );
  }
}
