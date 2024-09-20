import 'dart:convert';

import 'package:socialv/models/pmp_models/membership_model.dart';

class LoginResponse {
  String token;
  String userEmail;
  String userNicename;
  String userDisplayName;
  int userId;
  String userLogin;
  String storeApiNonce;
  String profilePicture;
  String verificationStatus;
  String? bmSecretKey;
  int isUserVerified;
  bool? isProfileUpdated;
  List<MembershipModel> subcriptionPlan;

  LoginResponse({
    this.token = "",
    this.userEmail = "",
    this.userNicename = "",
    this.userDisplayName = "",
    this.userId = -1,
    this.userLogin = "",
    this.storeApiNonce = "",
    this.profilePicture = "",
    this.isUserVerified = -1,
    this.verificationStatus = "",
    this.bmSecretKey,
    this.isProfileUpdated,
    this.subcriptionPlan = const <MembershipModel>[],
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] is String ? json['token'] : "",
      userEmail: json['user_email'] is String ? json['user_email'] : "",
      userNicename: json['user_nicename'] is String ? json['user_nicename'] : "",
      userDisplayName: json['user_display_name'] is String ? json['user_display_name'] : "",
      userId: json['user_id'] is int ? json['user_id'] : -1,
      userLogin: json['user_login'] is String ? json['user_login'] : "",
      bmSecretKey: json['bm_secret_key'] is String ? json['bm_secret_key'] : "",
      isProfileUpdated: json['is_profile_updated'] is bool ? json['is_profile_updated'] : false,
      storeApiNonce: json['store_api_nonce'] is String ? json['store_api_nonce'] : "",
      profilePicture: json['profile_picture'] is String ? json['profile_picture'] : "",
      isUserVerified: json['is_user_verified'] is int ? json['is_user_verified'] : -1,
      verificationStatus: json['verification_status'] is String ? json['verification_status'] : "",
      subcriptionPlan: json['subcription_plan'] is List
          ? List<MembershipModel>.from(json['subcription_plan'])
          : json['subcription_plan'] is Map<String, dynamic>
              ? [MembershipModel.fromJson(json['subcription_plan'])]
              : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'user_email': userEmail,
      'user_nicename': userNicename,
      'user_display_name': userDisplayName,
      'user_id': userId,
      'user_login': userLogin,
      'store_api_nonce': storeApiNonce,
      'profile_picture': profilePicture,
      'is_user_verified': isUserVerified,
      'verification_status': verificationStatus,
      'is_profile_updated': isProfileUpdated,
      'bm_secret_key': bmSecretKey,
      'subcription_plan': subcriptionPlan,
    };
  }
}
