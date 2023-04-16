class AllNotificationModel {
  int? count;
  String? next;
  String? previous;
  List<Results>? results;

  AllNotificationModel({this.count, this.next, this.previous, this.results});

  AllNotificationModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results!.add(Results.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    data['next'] = next;
    data['previous'] = previous;
    if (results != null) {
      data['results'] = results!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Results {
  int? id;
  int? notificationId;
  bool? isRead;
  String? notificationType;
  String? msg;
  String? createdDateAd;

  Results(
      {this.id,
      this.notificationId,
      this.isRead,
      this.notificationType,
      this.msg,
      this.createdDateAd});

  Results.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    notificationId = json['notification_id'];
    isRead = json['is_read'];
    notificationType = json['notification_type'];
    msg = json['msg'];
    createdDateAd = json['created_date_ad'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['notification_id'] = notificationId;
    data['is_read'] = isRead;
    data['notification_type'] = notificationType;
    data['msg'] = msg;
    data['created_date_ad'] = createdDateAd;
    return data;
  }
}
