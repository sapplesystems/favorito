class NotificationListRequestModel {
  List<NotificationModel> _notifications = [];
  List<NotificationModel> get notifications => _notifications;
  set notifications(List list) {
    _notifications = list.cast<NotificationModel>();
  }
}

class NotificationModel {
  String title = "";
  String description = "";
}
