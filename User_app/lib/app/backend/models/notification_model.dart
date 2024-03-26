class NotificationModel {
  int? id;
  int? userId;
  String? notificationId;
  String? title;
  String? message;
  String? data;

  NotificationModel({
    this.id,
    this.userId,
    this.notificationId,
    this.title,
    this.message,
    this.data,
  });

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    userId = int.parse(json['user_id'].toString());
    notificationId = json['notification_id'];
    title = json['title'];
    message = json['message'];
    data = json['data'];
  }
}
