import 'package:socialv/models/messages/message_users.dart';
import 'package:socialv/models/messages/messages_model.dart';
import 'package:socialv/models/messages/threads_model.dart';

class PrivateThreadResponse {
  PrivateThreadResponse({
    this.result = '',
    this.threadId = -1,
    this.threads = const <Threads>[],
    this.users = const <MessagesUsers>[],
    this.messages = const <Messages>[],
  });

  factory PrivateThreadResponse.fromJson(dynamic json) {
    return PrivateThreadResponse(
      result: json['result'] is String ? json['result'] : '',
      threadId: json['thread_id'] != null ? json['thread_id'] : -1,
      threads: json['threads'] is List ? List<Threads>.from(json['threads'].map((x) => Threads.fromJson(x))) : [],
      messages: json['messages'] is List ? List<Messages>.from(json['messages'].map((x) => Messages.fromJson(x))) : [],
      users: json['users'] is List ? List<MessagesUsers>.from(json['users'].map((x) => MessagesUsers.fromJson(x))) : [],
    );
  }

  String result;
  int threadId;
  List<Threads> threads;
  List<MessagesUsers> users;
  List<Messages> messages;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['result'] = result;
    map['thread_id'] = threadId;
    map['threads'] = threads.map((v) => v.toJson()).toList();
    map['users'] = users.map((v) => v.toJson()).toList();
    map['messages'] = messages.map((v) => v.toJson()).toList();
    return map;
  }
}
