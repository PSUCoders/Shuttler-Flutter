import 'package:flutter/cupertino.dart' hide Notification;
import 'package:flutter/material.dart' hide Notification;

import 'package:provider/provider.dart';
import 'package:rect_getter/rect_getter.dart';
import 'package:shuttler/providers/notification_state.dart';
import 'package:shuttler/widgets/notification_tile.dart';
import 'package:shuttler/models/notification.dart';
import 'package:video_player/video_player.dart';

/// Notification Screen
class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  var _itemKeys = {};
  var _listViewKey = RectGetter.createGlobalKey();
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    // Mark read notifications after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) => _handleScroll(null));

    _controller =
        VideoPlayerController.asset('assets/animations/no-notification.mp4')
          ..initialize().then((_) {
            _controller.play();
            _controller.setLooping(true);

            // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
            setState(() {});
          });
  }

  bool _handleScroll(ScrollUpdateNotification scrollUpdateNotification) {
    print("handling scroll update...");
    final indexes = _getVisible();
    final notifications = Provider.of<NotificationState>(context).notifications;
    List<Notification> notis = [];
    indexes.forEach((index) {
      notis.add(notifications[index]);
    });
    _handleVisibleItemChange(notis);
    return true;
  }

  List<int> _getVisible() {
    /// First, get the rect of ListView, and then traver the _keys
    /// get rect of each item by keys in _keys, and if this rect in the range of ListView's rect,
    /// add the index into result list.
    var rect = RectGetter.getRectFromKey(_listViewKey);
    var _items = <int>[];
    _itemKeys.forEach((index, key) {
      var itemRect = RectGetter.getRectFromKey(key);
      if (itemRect != null &&
          !(itemRect.top > rect.bottom || itemRect.bottom < rect.top))
        _items.add(index);
    });

    /// so all visible item's index are in this _items.
    return _items;
  }

  _handleVisibleItemChange(List<Notification> items) {
    // TODOS
    final notificationState = Provider.of<NotificationState>(context);
    items.forEach((item) {
      if (item.seen) return;
      notificationState.markAsSeen(item);
    });
  }

  Widget _buildNotificationList(List<Notification> notifications) {
    return RectGetter(
      key: _listViewKey,
      child: NotificationListener<ScrollUpdateNotification>(
        onNotification: _handleScroll,
        child: ListView.separated(
          itemCount: notifications.length,
          separatorBuilder: (_, index) => Divider(height: 0),
          itemBuilder: (context, index) {
            _itemKeys[index] = RectGetter.createGlobalKey();
            return RectGetter(
              key: _itemKeys[index],
              child: NotificationTile(
                notification: notifications[index],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildNoNotification() {
    return Center(
      child: _controller.value.initialized
          ? AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            )
          : Container(),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('building notification screen...');
    final notificationState = Provider.of<NotificationState>(context);
    final notifications = notificationState.notifications ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text('Nofitications'),
      ),
      backgroundColor: Color.fromRGBO(255, 254, 255, 1),
      body: Container(
        child: notifications.isEmpty
            ? _buildNoNotification()
            : _buildNotificationList(notifications),
      ),
    );
  }
}
