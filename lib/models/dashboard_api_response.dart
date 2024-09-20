import 'package:socialv/models/members/friend_request_model.dart';

class DashboardAPIResponse {
  int? unreadMessagesCount;
  int? notificationCount;
  List<FriendRequestModel>? suggestedUser;

  List<SuggestedGroup>? suggestedGroups;

  DashboardAPIResponse({
    this.notificationCount,
    this.unreadMessagesCount,
    this.suggestedUser,
    this.suggestedGroups,
  });

  factory DashboardAPIResponse.fromJson(Map<String, dynamic> json) {
    return DashboardAPIResponse(
      notificationCount: json['notification_count'],
      suggestedUser: json['suggested_user'] != null ? (json['suggested_user'] as List).map((i) => FriendRequestModel.fromJson(i)).toList() : null,
      suggestedGroups: json['suggested_groups'] != null ? (json['suggested_groups'] as List).map((i) => SuggestedGroup.fromJson(i)).toList() : null,
      unreadMessagesCount: json['unread_messages_count'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['notification_count'] = this.notificationCount;
    data['unread_messages_count'] = this.unreadMessagesCount;

    if (this.suggestedGroups != null) {
      data['suggested_groups'] = this.suggestedGroups!.map((v) => v.toJson()).toList();
    }

    if (this.suggestedUser != null) {
      data['suggested_groups'] = this.suggestedUser!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}


class SuggestedGroup {
  int? id;
  String? groupAvtarImage;
  String? name;

  SuggestedGroup({this.groupAvtarImage, this.name, this.id});

  factory SuggestedGroup.fromJson(Map<String, dynamic> json) {
    return SuggestedGroup(
      id: json['id'],
      groupAvtarImage: json['group_avtar_image'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['group_avtar_image'] = this.groupAvtarImage;
    data['name'] = this.name;
    return data;
  }
}

class EncryptedData {
  String? userName;
  String? userAvatar;

  EncryptedData({this.userName, this.userAvatar});

  factory EncryptedData.fromJson(Map<String, dynamic> json) {
    return EncryptedData(
      userName: json['user_name'],
      userAvatar: json['user_avatar'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_name'] = this.userName;
    data['user_avatar'] = this.userAvatar;
    return data;
  }
}
