import 'dart:async';
import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shuttler/models/notification.dart';
import 'package:shuttler/services/online_db.dart';
import 'package:shuttler/utilities/contants.dart';

class NotificationState extends ChangeNotifier {
  // PRIVATE VARIABLES //
  StreamSubscription<List<Notification>> _notificationSubscription;
  List<Notification> _notifications;
  List<String> _seenIds;
  Completer<SharedPreferences> _prefs = Completer();

  NotificationState() {
    // // Get SharedPreferences instance
    SharedPreferences.getInstance().then((prefs) => _prefs.complete(prefs));

    fetchData();
  }

  @override
  void dispose() {
    print('disposing notification state...');
    cancelSubcriptions();
    super.dispose();
  }

  // GETTERS //

  List<Notification> get notifications => _notifications ?? [];

  /// List of notification ids that has been read on this device
  List<String> get readNotifications => _seenIds ?? [];

  bool get hasUnreadNotification =>
      notifications.where((item) => !item.seen).length != 0;

  // PRIVATE METHODS //

  fetchData() async {
    SharedPreferences prefs = await _prefs.future;
    _seenIds = prefs.getStringList(PrefsKey.SEEN_NOTIFICATION.toString()) ?? [];

    //
    _notificationSubscription =
        OnlineDB().notificationsStream().listen((notifications) {
      _notifications = notifications;
      _notifications.forEach((notification) {
        if (_seenIds.contains(notification.id)) {
          notification.seen = true;
        }

        return notification;
      });
      notifyListeners();
    });
  }

  /// Save seen ids to SharedPreferences and
  /// update notification list
  _updateSeenNotifications(List<String> ids) async {
    SharedPreferences prefs = await _prefs.future;
    await prefs.setStringList(PrefsKey.SEEN_NOTIFICATION.toString(), ids);

    _notifications.forEach((notification) {
      if (_seenIds.contains(notification.id)) notification.seen = true;

      return notification;
    });
  }

  // PUBLIC METHODS //

  markAsSeen(Notification notification) async {
    print('markAsSeen called');
    if (_seenIds.contains(notification.id)) return;

    _seenIds.add(notification.id);

    await _updateSeenNotifications(_seenIds);
    print("updated seenIds $_seenIds");
    notifyListeners();
  }

  cancelSubcriptions() async {
    print('cancelling all subscriptions from notification state...');
    await _notificationSubscription.cancel();
  }
}
