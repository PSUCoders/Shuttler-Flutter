import 'dart:async';
import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:shuttler_flutter/models/notification.dart';
import 'package:shuttler_flutter/services/db_service.dart';

class NotificationState extends ChangeNotifier {
  // PRIVATE VARIABLES //
  StreamSubscription<List<Notification>> _locationSubscription;
  List<Notification> _notifications;

  NotificationState() {
    ///
    _locationSubscription =
        DBService().notificationsStream.listen((notifications) {
      _notifications = notifications;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    cancelSubcriptions();
    super.dispose();
  }

  // GETTERS //

  List<Notification> get notifications => _notifications;

  // METHODS //

  cancelSubcriptions() async {
    print('cancelling all subscriptions from notification state...');
    await _locationSubscription.cancel();
  }
}
