class PaymentGatewayModel {
  String id;
  int enable;
  String mode;
  String name;
  Testing testing;
  Live live;

  PaymentGatewayModel({
    this.id = "",
    this.enable = -1,
    this.mode = "",
    this.name = "",
    required this.testing,
    required this.live,
  });

  factory PaymentGatewayModel.fromJson(Map<String, dynamic> json) {
    return PaymentGatewayModel(
      id: json['id'] is String ? json['id'] : "",
      enable: json['enable'] is int ? json['enable'] : -1,
      mode: json['mode'] is String ? json['mode'] : "",
      name: json['name'] is String ? json['name'] : "",
      testing: json['testing'] is Map
          ? Testing.fromJson(json['testing'])
          : Testing(),
      live: json['live'] is Map ? Live.fromJson(json['live']) : Live(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'enable': enable,
      'mode': mode,
      'name': name,
      'testing': testing.toJson(),
      'live': live.toJson(),
    };
  }
}

class Testing {
  String url;
  String key;
  String publicKey;

  Testing({
    this.url = "",
    this.key = "",
    this.publicKey = "",
  });

  factory Testing.fromJson(Map<String, dynamic> json) {
    return Testing(
      url: json['url'] is String ? json['url'] : "",
      key: json['key'] is String ? json['key'] : "",
      publicKey: json['public_key'] is String ? json['public_key'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'key': key,
      'public_key': publicKey,
    };
  }
}

class Live {
  String url;
  String key;
  String publicKey;

  Live({
    this.url = "",
    this.key = "",
    this.publicKey = "",
  });

  factory Live.fromJson(Map<String, dynamic> json) {
    return Live(
      url: json['url'] is String ? json['url'] : "",
      key: json['key'] is String ? json['key'] : "",
      publicKey: json['public_key'] is String ? json['public_key'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'key': key,
      'public_key': publicKey,
    };
  }
}

