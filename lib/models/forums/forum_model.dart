import 'package:socialv/models/forums/common_models.dart';
import 'package:socialv/models/forums/topic_model.dart';

class ForumModel {
  String? description;
  List<FreshnessModel>? freshness;
  GroupDetail? groupDetails;
  int? id;
  String? postCount;
  String? title;
  String? topicCount;
  String? type;
  int? isPrivate;
  String? image;
  bool? isSubscribed;
  String? lastUpdate;
  List<TopicModel>? topicList;
  List<ForumModel>? forumList;

  ForumModel({
    this.description,
    this.freshness,
    this.groupDetails,
    this.id,
    this.postCount,
    this.title,
    this.topicCount,
    this.type,
    this.isPrivate,
    this.image,
    this.isSubscribed,
    this.lastUpdate,
    this.topicList,
    this.forumList,

  });

  factory ForumModel.fromJson(Map<String, dynamic> json) {
    return ForumModel(
      description: json['description'],
      freshness: json['freshness'] != null ? (json['freshness'] as List).map((i) => FreshnessModel.fromJson(i)).toList() : null,
      groupDetails: json['group_details'] != null && (json['group_details'] is Map<String,dynamic>)?  GroupDetail.fromJson(json['group_details']) : null,
      id: json['id'],
      postCount: json['post_count'],
      title: json['title'],
      topicCount: json['topic_count'],
      type: json['type'],
      isPrivate: json['is_private'],
      image: json['image'] == false ? '': json['image'],
      isSubscribed: json['is_subscribed'],
      lastUpdate: json['last_update'],
      topicList: json['topic_list'] != null ? (json['topic_list'] as List).map((i) => TopicModel.fromJson(i)).toList() : null,
      forumList: json['forum_list'] != null ? (json['forum_list'] as List).map((i) => ForumModel.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['id'] = this.id;
    data['post_count'] = this.postCount;
    data['title'] = this.title;
    data['topic_count'] = this.topicCount;
    data['type'] = this.type;
    data['is_private'] = this.isPrivate;
    data['image'] = this.image;
    data['is_subscribed'] = this.isSubscribed;
    data['last_update'] = this.lastUpdate;
    data['title'] = this.title;
    data['is_private'] = this.isPrivate;
    if (this.topicList != null) {
      data['topic_list'] = this.topicList!.map((v) => v.toJson()).toList();
    }
    if (this.freshness != null) {
      data['freshness'] = this.freshness!.map((v) => v.toJson()).toList();
    }
    if (this.groupDetails != null) {
      data['group_details'] = this.groupDetails!.toJson();
    }
    if (this.forumList != null) {
      data['forum_list'] = this.forumList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
