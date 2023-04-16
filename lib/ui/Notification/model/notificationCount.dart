// class NotificationCountModel {
//   int? unreadCount;
//   int? totalCount;

//   NotificationCountModel({this.unreadCount, this.totalCount});

//   NotificationCountModel.fromJson(Map<String, dynamic> json) {
//     unreadCount = json['unread_count'];
//     totalCount = json['total_count'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['unread_count'] = unreadCount;
//     data['total_count'] = totalCount;
//     return data;
//   }
// }
class NotificationCountModel {
  int? unreadCount;
  int? totalCount;

  NotificationCountModel({required this.unreadCount, required this.totalCount});

  factory NotificationCountModel.fromJson(Map<String, dynamic> json) {
    return NotificationCountModel(
        unreadCount: json['unread_count'], totalCount: json['total_count']);
  }
}
