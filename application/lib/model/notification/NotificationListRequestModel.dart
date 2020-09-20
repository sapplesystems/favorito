class NotificationListRequestModel {
  String status;
  String message;
  List<NotificationModel> notifications;

  NotificationListRequestModel(
      {this.status = '', this.message = '', this.notifications = const []});

  NotificationListRequestModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      notifications = new List<NotificationModel>();
      json['data'].forEach((v) {
        notifications.add(new NotificationModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.notifications != null) {
      data['notifications'] =
          this.notifications.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NotificationModel {
  int id;
  String title;
  String description;

  NotificationModel({this.id, this.title, this.description});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    return data;
  }
}
