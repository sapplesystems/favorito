// import 'package:json_parser/reflectable.dart';

// @reflectable
class NotificationListModel {
  List<NotificationModel> _notifications = [];
  List<NotificationModel> get notifications => _notifications;
  set notifications(List list) {
    _notifications = list.cast<NotificationModel>();
  }
}

// @reflectable
class NotificationModel {
  String title = "";
  String description = "";
}
