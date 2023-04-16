import 'package:flutter/cupertino.dart';

import '../model/notificationCount.dart';
import '../services/notification_services.dart';

class NotificationClass extends ChangeNotifier {
  NotificationCountModel? notificationCountModel;
  // int? notificationCountModel;
  fetchCount(context) async {
    notificationCountModel = await getCount(context);
    // log("unread count${notificationCountModel!.unreadCount.toString()}");

    notifyListeners();
  }
}
