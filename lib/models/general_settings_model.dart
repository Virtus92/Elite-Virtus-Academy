import 'package:socialv/models/members/profile_field_model.dart';
import 'package:socialv/models/posts/media_model.dart';
import 'package:socialv/models/reactions/reactions_model.dart';

class GeneralSettingModel {
  int isAccountVerificationRequire;
  bool isPaidMembershipEnable;
  int showAds;
  int showBlogs;
  int showSocialLogin;
  int showShop;
  int showGamipress;
  int showLearnpress;
  int showMembership;
  int showForums;
  int isGamipressEnable;
  int isWoocommerceEnable;
  int isShopEnable;
  String wooCurrency;
  int isLmsEnable;
  int isCourseEnable;
  String lmsCurrency;
  int isWebsocketEnable;
  int isReactionEnable;
  ReactionsModel defaultReaction;
  List<Reactions> reactions;
  List<MediapressAllowedTypes> mediapressAllowedTypes;
  List<String> storyAllowedTypes;
  int isHighlightStoryEnable;
  List<StoryActions> storyActions;
  int displayPostCount;
  int displayCommentsCount;
  int displayProfileViews;
  int displayFriendRequestBtn;
  InAppPurchaseConfig inAppPurchaseConfig;
  String giphyKey;
  String membershipPaymentType;
  String iosGiphyKey;
  List<Visibilities> accountPrivacyVisibility;
  List<Visibilities> visibilities;
  List<ReportTypes> reportTypes;
  List<SignupFields> signupFields;
  List<String>? storyAllowedType;

  List<GamipressAchievementTypes> gamipressAchievementTypes;

  GeneralSettingModel({
    this.isAccountVerificationRequire = -1,
    this.isPaidMembershipEnable = false,
    this.showAds = -1,
    this.showBlogs = -1,
    this.showSocialLogin = -1,
    this.showShop = -1,
    this.showGamipress = -1,
    this.showLearnpress = -1,
    this.showMembership = -1,
    this.showForums = -1,
    this.isGamipressEnable = -1,
    this.isWoocommerceEnable = -1,
    this.isShopEnable = -1,
    this.wooCurrency = "",
    this.isLmsEnable = -1,
    this.isCourseEnable = -1,
    this.lmsCurrency = "",
    this.isWebsocketEnable = -1,
    this.isReactionEnable = -1,
    required this.defaultReaction,
    required this.inAppPurchaseConfig,
    this.reactions = const <Reactions>[],
    this.mediapressAllowedTypes = const <MediapressAllowedTypes>[],
    this.storyAllowedTypes = const <String>[],
    this.isHighlightStoryEnable = -1,
    this.storyActions = const <StoryActions>[],
    this.displayPostCount = -1,
    this.displayCommentsCount = -1,
    this.displayProfileViews = -1,
    this.displayFriendRequestBtn = -1,
    this.giphyKey = "",
    this.membershipPaymentType = "",
    this.iosGiphyKey = "",
    this.accountPrivacyVisibility = const <Visibilities>[],
    this.visibilities = const <Visibilities>[],
    this.reportTypes = const <ReportTypes>[],
    this.signupFields = const <SignupFields>[],
    this.storyAllowedType = const <String>[],
    this.gamipressAchievementTypes = const <GamipressAchievementTypes>[],
  });

  factory GeneralSettingModel.fromJson(Map<String, dynamic> json) {
    return GeneralSettingModel(
      isAccountVerificationRequire: json['is_account_verification_require'] is int ? json['is_account_verification_require'] : -1,
      isPaidMembershipEnable: json['is_paid_membership_enable'] is bool ? json['is_paid_membership_enable'] : false,
      showAds: json['show_ads'] is int ? json['show_ads'] : -1,
      showBlogs: json['show_blogs'] is int ? json['show_blogs'] : -1,
      showSocialLogin: json['show_social_login'] is int ? json['show_social_login'] : -1,
      showShop: json['show_shop'] is int ? json['show_shop'] : -1,
      showGamipress: json['show_gamipress'] is int ? json['show_gamipress'] : -1,
      showLearnpress: json['show_learnpress'] is int ? json['show_learnpress'] : -1,
      showMembership: json['show_membership'] is int ? json['show_membership'] : -1,
      showForums: json['show_forums'] is int ? json['show_forums'] : -1,
      isGamipressEnable: json['is_gamipress_enable'] is int ? json['is_gamipress_enable'] : -1,
      isWoocommerceEnable: json['is_woocommerce_enable'] is int ? json['is_woocommerce_enable'] : -1,
      isShopEnable: json['is_shop_enable'] is int ? json['is_shop_enable'] : -1,
      wooCurrency: json['woo_currency'] is String ? json['woo_currency'] : "",
      isLmsEnable: json['is_lms_enable'] is int ? json['is_lms_enable'] : -1,
      isCourseEnable: json['is_course_enable'] is int ? json['is_course_enable'] : -1,
      lmsCurrency: json['lms_currency'] is String ? json['lms_currency'] : "",
      isWebsocketEnable: json['is_websocket_enable'] is int ? json['is_websocket_enable'] : -1,
      isReactionEnable: json['is_reaction_enable'] is int ? json['is_reaction_enable'] : -1,
      defaultReaction: json['default_reaction'] is Map ? ReactionsModel.fromJson(json['default_reaction']) : ReactionsModel(),
      inAppPurchaseConfig: json['in_app_purchase_config'] is Map ? InAppPurchaseConfig.fromJson(json['in_app_purchase_config']) : InAppPurchaseConfig(),
      reactions: json['reactions'] is List ? (json['reactions'] as List).map((e) => Reactions.fromJson(e)).toList() : [],
      mediapressAllowedTypes: json['mediapress'] is List ? List<MediapressAllowedTypes>.from(json['mediapress'].map((x) => MediapressAllowedTypes.fromJson(x))) : [],
      storyAllowedTypes: json['story_allowed_types'] is List ? List<String>.from(json['story_allowed_types'].map((x) => x)) : [],
      isHighlightStoryEnable: json['is_highlight_story_enable'] is int ? json['is_highlight_story_enable'] : -1,
      storyActions: json['story_actions'] is List ? List<StoryActions>.from(json['story_actions'].map((x) => StoryActions.fromJson(x))) : [],
      displayPostCount: json['display_post_count'] is int ? json['display_post_count'] : -1,
      displayCommentsCount: json['display_comments_count'] is int ? json['display_comments_count'] : -1,
      displayProfileViews: json['display_profile_views'] is int ? json['display_profile_views'] : -1,
      displayFriendRequestBtn: json['display_friend_request_btn'] is int ? json['display_friend_request_btn'] : -1,
      giphyKey: json['giphy_key'] is String ? json['giphy_key'] : "",
      membershipPaymentType: json['membership_payment_type'] is String ? json['membership_payment_type'] : "",
      iosGiphyKey: json['ios_giphy_key'] is String ? json['ios_giphy_key'] : "",
      accountPrivacyVisibility: json['account_privacy_visibility'] is List ? List<Visibilities>.from(json['account_privacy_visibility'].map((x) => Visibilities.fromJson(x))) : [],
      visibilities: json['visibilities'] is List ? List<Visibilities>.from(json['visibilities'].map((x) => Visibilities.fromJson(x))) : [],
      reportTypes: json['report_types'] is List ? List<ReportTypes>.from(json['report_types'].map((x) => ReportTypes.fromJson(x))) : [],
      signupFields: json['signup_fields'] is List ? List<SignupFields>.from(json['signup_fields'].map((x) => SignupFields.fromJson(x))) : [],
      storyAllowedType: json['story_allowed_types'] is List ? List<String>.from(json['story_allowed_types']) : [],
      gamipressAchievementTypes: json['gamipress_achievement_types'] is List ? List<GamipressAchievementTypes>.from(json['gamipress_achievement_types'].map((x) => GamipressAchievementTypes.fromJson(x))) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'is_account_verification_require': isAccountVerificationRequire,
      'is_paid_membership_enable': isPaidMembershipEnable,
      'show_ads': showAds,
      'show_blogs': showBlogs,
      'show_social_login': showSocialLogin,
      'show_shop': showShop,
      'show_gamipress': showGamipress,
      'show_learnpress': showLearnpress,
      'show_membership': showMembership,
      'show_forums': showForums,
      'is_gamipress_enable': isGamipressEnable,
      'is_woocommerce_enable': isWoocommerceEnable,
      'is_shop_enable': isShopEnable,
      'woo_currency': wooCurrency,
      'is_lms_enable': isLmsEnable,
      'is_course_enable': isCourseEnable,
      'lms_currency': lmsCurrency,
      'is_websocket_enable': isWebsocketEnable,
      'is_reaction_enable': isReactionEnable,
      'default_reaction': defaultReaction.toJson(),
      'reactions': [],
      'mediapress': mediapressAllowedTypes.map((e) => e.toJson()).toList(),
      'story_allowed_types': storyAllowedTypes.map((e) => e).toList(),
      'is_highlight_story_enable': isHighlightStoryEnable,
      'story_actions': storyActions.map((e) => e.toJson()).toList(),
      'display_post_count': displayPostCount,
      'display_comments_count': displayCommentsCount,
      'display_profile_views': displayProfileViews,
      'display_friend_request_btn': displayFriendRequestBtn,
      'giphy_key': giphyKey,
      'membership_payment_type': membershipPaymentType,
      'in_app_purchase_config': inAppPurchaseConfig,
      'ios_giphy_key': iosGiphyKey,
      'account_privacy_visibility': accountPrivacyVisibility.map((e) => e.toJson()).toList(),
      'visibilities': visibilities.map((e) => e.toJson()).toList(),
      'report_types': reportTypes.map((e) => e.toJson()).toList(),
      'signup_fields': signupFields.map((e) => e.toJson()).toList(),
      'gamipress_achievement_types': gamipressAchievementTypes.map((e) => e.toJson()).toList(),
    };
  }
}

class DefaultReaction {
  String id;
  String name;
  String imageUrl;
  String defaultImageUrl;

  DefaultReaction({
    this.id = "",
    this.name = "",
    this.imageUrl = "",
    this.defaultImageUrl = "",
  });

  factory DefaultReaction.fromJson(Map<String, dynamic> json) {
    return DefaultReaction(
      id: json['id'] is String ? json['id'] : "",
      name: json['name'] is String ? json['name'] : "",
      imageUrl: json['image_url'] is String ? json['image_url'] : "",
      defaultImageUrl: json['default_image_url'] is String ? json['default_image_url'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image_url': imageUrl,
      'default_image_url': defaultImageUrl,
    };
  }
}

class Reactions {
  String id;
  String name;
  String imageUrl;

  Reactions({
    this.id = "",
    this.name = "",
    this.imageUrl = "",
  });

  factory Reactions.fromJson(Map<String, dynamic> json) {
    return Reactions(
      id: json['id'] is String ? json['id'] : "",
      name: json['name'] is String ? json['name'] : "",
      imageUrl: json['image_url'] is String ? json['image_url'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image_url': imageUrl,
    };
  }
}

class MediapressAllowedTypes {
  String component;
  List<MediaModel> allowedTypes;

  List<PrivacyStatus> privacyStatus;

  MediapressAllowedTypes({
    this.component = "",
    this.allowedTypes = const <MediaModel>[],
    this.privacyStatus = const <PrivacyStatus>[],
  });

  factory MediapressAllowedTypes.fromJson(Map<String, dynamic> json) {
    return MediapressAllowedTypes(
      component: json['component'] is String ? json['component'] : "",
      allowedTypes: json['allowed_types'] is List ? List<MediaModel>.from(json['allowed_types'].map((x) => MediaModel.fromJson(x))) : [],
      privacyStatus: json['privacy_status'] is List ? List<PrivacyStatus>.from(json['privacy_status'].map((x) => PrivacyStatus.fromJson(x))) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'component': component,
      'allowed_types': allowedTypes.map((e) => e.toJson()).toList(),
      'privacy_status': privacyStatus.map((e) => e.toJson()).toList(),
    };
  }
}

class InAppPurchaseConfig {
  InAppPurchaseConfig({
    this.id,
    this.enable,
    this.entitlementId,
    this.googleApiKey,
    this.appleApiKey,
  });

  InAppPurchaseConfig.fromJson(dynamic json) {
    id = json['id'];
    enable = json['enable'];
    entitlementId = json['entitlement_id'];
    googleApiKey = json['google_api_key'];
    appleApiKey = json['apple_api_key'];
  }

  String? id;
  num? enable;
  String? entitlementId;
  String? googleApiKey;
  String? appleApiKey;

  InAppPurchaseConfig copyWith({
    String? id,
    num? enable,
    String? entitlementId,
    String? googleApiKey,
    String? appleApiKey,
  }) =>
      InAppPurchaseConfig(
        id: id ?? this.id,
        enable: enable ?? this.enable,
        entitlementId: entitlementId ?? this.entitlementId,
        googleApiKey: googleApiKey ?? this.googleApiKey,
        appleApiKey: appleApiKey ?? this.appleApiKey,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['enable'] = enable;
    map['entitlement_id'] = entitlementId;
    map['google_api_key'] = googleApiKey;
    map['apple_api_key'] = appleApiKey;
    return map;
  }
}

class AllowedTypes {
  String title;
  String type;
  bool isActive;
  List<String> allowedType;

  AllowedTypes({
    this.title = "",
    this.type = "",
    this.isActive = false,
    this.allowedType = const <String>[],
  });

  factory AllowedTypes.fromJson(Map<String, dynamic> json) {
    return AllowedTypes(
      title: json['title'] is String ? json['title'] : "",
      type: json['type'] is String ? json['type'] : "",
      isActive: json['is_active'] is bool ? json['is_active'] : false,
      allowedType: json['allowed_type'] is List ? List<String>.from(json['allowed_type'].map((x) => x)) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'type': type,
      'is_active': isActive,
      'allowed_type': allowedType.map((e) => e).toList(),
    };
  }
}

class PrivacyStatus {
  int id;
  String label;
  String singularName;
  String pluralName;
  int ttId;
  String slug;
  String callback;
  String activityPrivacy;

  PrivacyStatus({
    this.id = -1,
    this.label = "",
    this.singularName = "",
    this.pluralName = "",
    this.ttId = -1,
    this.slug = "",
    this.callback = "",
    this.activityPrivacy = "",
  });

  factory PrivacyStatus.fromJson(Map<String, dynamic> json) {
    return PrivacyStatus(
      id: json['id'] is int ? json['id'] : -1,
      label: json['label'] is String ? json['label'] : "",
      singularName: json['singular_name'] is String ? json['singular_name'] : "",
      pluralName: json['plural_name'] is String ? json['plural_name'] : "",
      ttId: json['tt_id'] is int ? json['tt_id'] : -1,
      slug: json['slug'] is String ? json['slug'] : "",
      callback: json['callback'] is String ? json['callback'] : "",
      activityPrivacy: json['activity_privacy'] is String ? json['activity_privacy'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'singular_name': singularName,
      'plural_name': pluralName,
      'tt_id': ttId,
      'slug': slug,
      'callback': callback,
      'activity_privacy': activityPrivacy,
    };
  }
}

class MediapressGroupsAllowedTypes {
  String title;
  String type;
  bool isActive;
  List<String> allowedType;

  MediapressGroupsAllowedTypes({
    this.title = "",
    this.type = "",
    this.isActive = false,
    this.allowedType = const <String>[],
  });

  factory MediapressGroupsAllowedTypes.fromJson(Map<String, dynamic> json) {
    return MediapressGroupsAllowedTypes(
      title: json['title'] is String ? json['title'] : "",
      type: json['type'] is String ? json['type'] : "",
      isActive: json['is_active'] is bool ? json['is_active'] : false,
      allowedType: json['allowed_type'] is List ? List<String>.from(json['allowed_type'].map((x) => x)) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'type': type,
      'is_active': isActive,
      'allowed_type': allowedType.map((e) => e).toList(),
    };
  }
}

class MediapressSitewideAllowedTypes {
  String title;
  String type;
  bool isActive;
  List<String> allowedType;

  MediapressSitewideAllowedTypes({
    this.title = "",
    this.type = "",
    this.isActive = false,
    this.allowedType = const <String>[],
  });

  factory MediapressSitewideAllowedTypes.fromJson(Map<String, dynamic> json) {
    return MediapressSitewideAllowedTypes(
      title: json['title'] is String ? json['title'] : "",
      type: json['type'] is String ? json['type'] : "",
      isActive: json['is_active'] is bool ? json['is_active'] : false,
      allowedType: json['allowed_type'] is List ? List<String>.from(json['allowed_type'].map((x) => x)) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'type': type,
      'is_active': isActive,
      'allowed_type': allowedType.map((e) => e).toList(),
    };
  }
}

class StoryActions {
  String action;
  String name;

  StoryActions({
    this.action = "",
    this.name = "",
  });

  factory StoryActions.fromJson(Map<String, dynamic> json) {
    return StoryActions(
      action: json['action'] is String ? json['action'] : "",
      name: json['name'] is String ? json['name'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'action': action,
      'name': name,
    };
  }
}

class Visibilities {
  String id;
  String label;

  Visibilities({
    this.id = "",
    this.label = "",
  });

  factory Visibilities.fromJson(Map<String, dynamic> json) {
    return Visibilities(
      id: json['id'] is String ? json['id'] : "",
      label: json['label'] is String ? json['label'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
    };
  }
}

class ReportTypes {
  String key;
  String label;

  ReportTypes({
    this.key = "",
    this.label = "",
  });

  factory ReportTypes.fromJson(Map<String, dynamic> json) {
    return ReportTypes(
      key: json['key'] is String ? json['key'] : "",
      label: json['label'] is String ? json['label'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'label': label,
    };
  }
}

class SignupFields {
  int groupId;
  String groupName;
  List<ProfileFieldsModel> fields;

  SignupFields({
    this.groupId = -1,
    this.groupName = "",
    this.fields = const <ProfileFieldsModel>[],
  });

  factory SignupFields.fromJson(Map<String, dynamic> json) {
    return SignupFields(
      groupId: json['group_id'] is int ? json['group_id'] : -1,
      groupName: json['group_name'] is String ? json['group_name'] : "",
      fields: json['fields'] is List ? List<ProfileFieldsModel>.from(json['fields'].map((x) => ProfileFieldsModel.fromJson(x))) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'group_id': groupId,
      'group_name': groupName,
      'fields': fields.map((e) => e.toJson()).toList(),
    };
  }
}

class ProfileFieldsModel {
  int id;
  String type;
  String label;
  String value;
  List<OptionField> options;
  bool isRequired;

  ProfileFieldsModel({
    this.id = -1,
    this.type = "",
    this.label = "",
    this.value = "",
    this.options = const [],
    this.isRequired = false,
  });

  factory ProfileFieldsModel.fromJson(Map<String, dynamic> json) {
    return ProfileFieldsModel(
      id: json['id'] is int ? json['id'] : -1,
      type: json['type'] is String ? json['type'] : "",
      label: json['label'] is String ? json['label'] : "",
      value: json['value'] is String ? json['value'] : "",
      options: json['options'] is List && (json['options'] as List).isNotEmpty ? (json['options'] as List).map((e) => OptionField.fromJson(e)).toList() : [],
      isRequired: json['is_required'] is bool ? json['is_required'] : false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'label': label,
      'value': value,
      'options': options.map((e) => e.toJson()).toList(),
      'is_required': isRequired,
    };
  }
}

class GamipressAchievementTypes {
  String iD;
  String singularName;
  String pluralName;
  String slug;

  GamipressAchievementTypes({
    this.iD = "",
    this.singularName = "",
    this.pluralName = "",
    this.slug = "",
  });

  factory GamipressAchievementTypes.fromJson(Map<String, dynamic> json) {
    return GamipressAchievementTypes(
      iD: json['ID'] is String ? json['ID'] : "",
      singularName: json['singular_name'] is String ? json['singular_name'] : "",
      pluralName: json['plural_name'] is String ? json['plural_name'] : "",
      slug: json['slug'] is String ? json['slug'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID': iD,
      'singular_name': singularName,
      'plural_name': pluralName,
      'slug': slug,
    };
  }
}
