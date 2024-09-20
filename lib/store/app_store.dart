import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/language/app_localizations.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/dashboard_api_response.dart';
import 'package:socialv/models/groups/group_response.dart';
import 'package:socialv/models/members/friend_request_model.dart';
import 'package:socialv/models/members/member_response.dart';
import 'package:socialv/models/reactions/reactions_model.dart';
import 'package:socialv/utils/colors.dart';
import 'package:socialv/utils/constants.dart';

import '../models/general_settings_model.dart';
import '../models/members/profile_visibility_model.dart';
import '../models/messages/emoji.dart';
import '../models/posts/media_model.dart';

part 'app_store.g.dart';

class AppStore = AppStoreBase with _$AppStore;

abstract class AppStoreBase with Store {
  @observable
  bool showAds = getBoolAsync(SharePreferencesKey.showAds);

  @observable
  bool hasInAppSubscription = getBoolAsync(SharePreferencesKey.hasInAppSubscription);

  @observable
  String inAppActiveSubscription = getStringAsync(SharePreferencesKey.inAppActiveSubscription);

  @observable
  bool showBlogs = getBoolAsync(SharePreferencesKey.showBlogs);

  bool isFreeSubscription = getBoolAsync(SharePreferencesKey.freeSubscription);

  @observable
  bool showSocialLogin = getBoolAsync(SharePreferencesKey.showSocialLogin);

  @observable
  bool showShop = getBoolAsync(SharePreferencesKey.showShop);

  @observable
  bool showGamiPress = getBoolAsync(SharePreferencesKey.showGamiPress);

  @observable
  bool showLearnPress = getBoolAsync(SharePreferencesKey.showLearnPress);

  @observable
  bool showMemberShip = getBoolAsync(SharePreferencesKey.showMembership);

  @observable
  bool showForums = getBoolAsync(SharePreferencesKey.showForums);

  @observable
  bool isSocialLogin = getBoolAsync(SharePreferencesKey.showSocialLogin);

  @observable
  bool filterContent = getBoolAsync(SharePreferencesKey.FILTER_CONTENT);

  @observable
  bool isAuthVerificationEnable = getBoolAsync(SharePreferencesKey.isAccountVerificationRequire);

  @observable
  bool isWebsocketEnable = getBoolAsync(SharePreferencesKey.isWebSocketEnable);

  @observable
  bool isReactionEnable = getBoolAsync(SharePreferencesKey.isReactionEnable);

  @observable
  ReactionsModel defaultReaction = ReactionsModel.fromJson(getJSONAsync(SharePreferencesKey.defaultReaction));

  @observable
  String giphyKey = getStringAsync(SharePreferencesKey.giphyKey);

  @observable
  String iosGiphyKey = getStringAsync(SharePreferencesKey.iosGiphyKey);

  @observable
  String wooCurrency = getStringAsync(SharePreferencesKey.wooCurrency);

  @observable
  String nonce = getStringAsync(SharePreferencesKey.NONCE);

  @observable
  String inAppEntitlementID = getStringAsync(SharePreferencesKey.entitlement_id);

  @observable
  String inAppGoogleApiKey = getStringAsync(SharePreferencesKey.google_api_key);

  @observable
  String inAppAppleApiKey = getStringAsync(SharePreferencesKey.apple_api_key);

  @observable
  String verificationStatus = getStringAsync(SharePreferencesKey.VERIFICATION_STATUS);

  @observable
  bool showStoryLoader = false;

  @observable
  bool showWoocommerce = getBoolAsync(SharePreferencesKey.isWooCommerceEnable);

  @observable
  bool showStoryHighlight = getBoolAsync(SharePreferencesKey.isHighlightStoryEnable);

  @observable
  bool showGif = false;

  @observable
  bool showAppbarAndBottomNavBar = true;

  @observable
  bool showShopBottom = true;

  @observable
  bool isLoggedIn = false;

  @observable
  bool doRemember = false;

  @observable
  bool isDarkMode = false;

  @observable
  String selectedLanguage = "";

  @observable
  bool isLoading = false;

  @observable
  bool isLoadingDots = false;

  @observable
  bool isLMSEnable = getBoolAsync(SharePreferencesKey.isLmsEnable);

  @observable
  bool isCourseEnable = getBoolAsync(SharePreferencesKey.isCourseEnable);

  @observable
  bool displayPostCount = getBoolAsync(SharePreferencesKey.displayPostCount);

  @observable
  bool displayPostCommentsCount = getBoolAsync(SharePreferencesKey.displayPostCount);

  @observable
  bool displayFriendRequestBtn = getBoolAsync(SharePreferencesKey.displayFriendRequestBtn);

  @observable
  bool isShopEnable = getBoolAsync(SharePreferencesKey.isShopEnable);

  @observable
  List<MemberResponse> recentMemberSearchList = [];

  @observable
  List<GroupResponse> recentGroupsSearchList = [];

  @observable
  List<FriendRequestModel> suggestedUserList = [];

  @observable
  List<SuggestedGroup> suggestedGroupsList = [];

  @observable
  int notificationCount = 0;

  @observable
  int createdAlbumId = 0;

  @observable
  int currentDashboardIndex = 0;

  @observable
  int cartCount = getIntAsync(SharePreferencesKey.cartCount);

  @observable
  bool isMultiSelect = false;

  @observable
  bool autoPlay = true;

  @observable
  bool isGamiPressEnable = getBoolAsync(SharePreferencesKey.isGamiPressEnable);

  @observable
  ObservableList<Visibilities> visibilities = ObservableList();

  @observable
  ObservableList<StoryActions> storyActions = ObservableList();

  @observable
  ObservableList<Visibilities> accountPrivacyVisibility = ObservableList();

  @observable
  ObservableList<ReportTypes> reportTypes = ObservableList();

  @observable
  ObservableList<Reactions> reactions = ObservableList();

  @observable
  MediapressAllowedTypes groupMediaAllowedType = MediapressAllowedTypes(); // Assuming this is observable

  @observable
  ObservableList<SignupFields> signUpFieldList = ObservableList();

  @observable
  ObservableList<MediapressAllowedTypes> allowedMedia = ObservableList();

  @observable
  ObservableList<String> storyAllowedMediaType = ObservableList();

  @observable
  ObservableList<PrivacyStatus> mediaStatusList = ObservableList();

  @observable
  ObservableList<Emojis> emojiList = ObservableList();

  ObservableList<ProfileVisibilityModel> profileVisibility = ObservableList();

  @observable
  ObservableList<GamipressAchievementTypes> achievementEndPoints = ObservableList();

  @observable
  MediaModel? selectedAlbumMedia;

  // Setter methods

  @action
  Future<void> setAchievementEndPointList(List<GamipressAchievementTypes> newList) async {
    achievementEndPoints.clear();
    achievementEndPoints.addAll(newList);
    await setValue(SharePreferencesKey.achievementType, jsonEncode(newList.map((e) => e.toJson()).toList()));
  }

  @action
  Future<void> setGroupMediaAllowedType(MediapressAllowedTypes newType) async {
    groupMediaAllowedType = newType;
    await setValue(SharePreferencesKey.mediapressGroupsAllowedTypes, newType.toJson());
  }

  @action
  Future<void> setVisibilities(List<Visibilities> newList) async {
    visibilities.clear();
    visibilities.addAll(newList);
    await setValue(SharePreferencesKey.visibilities, jsonEncode(newList.map((e) => e.toJson()).toList()));
  }

  @action
  Future<void> setStoryActions(List<StoryActions> newList) async {
    storyActions.clear();
    storyActions.addAll(newList);
    await setValue(SharePreferencesKey.storyActions, jsonEncode(newList.map((e) => e.toJson()).toList()));
  }

  @action
  Future<void> setAccountPrivacyVisibility(List<Visibilities> newList) async {
    accountPrivacyVisibility.clear();
    accountPrivacyVisibility.addAll(newList);
    await setValue(SharePreferencesKey.accountPrivacyVisibility, jsonEncode(newList.map((e) => e.toJson()).toList()));
  }

  @action
  Future<void> setReportTypes(List<ReportTypes> newList) async {
    reportTypes.clear();
    reportTypes.addAll(newList);
    await setValue(SharePreferencesKey.reportTypes, jsonEncode(newList.map((e) => e.toJson()).toList()));
  }

  @action
  Future<void> setReactions(List<Reactions> newList) async {
    reactions.clear();
    reactions.addAll(newList);
    await setValue(SharePreferencesKey.reactions, jsonEncode(newList.map((e) => e.toJson()).toList()));
  }

  @action
  Future<void> setEmojiList(List<Emojis> newList) async {
    emojiList.clear();
    emojiList.addAll(newList);
    await setValue(SharePreferencesKey.emojiList, jsonEncode(newList.map((e) => e.toJson()).toList()));
  }

  @action
  Future<void> setSignUpFieldList(List<SignupFields> newList) async {
    signUpFieldList.clear();
    signUpFieldList.addAll(newList);
    await setValue(SharePreferencesKey.signupFields, jsonEncode(newList.map((e) => e.toJson()).toList()));
  }

  @action
  Future<void> setAllowedMedia(List<MediapressAllowedTypes> newList) async {
    allowedMedia.clear();
    allowedMedia.addAll(newList);
    await setValue(SharePreferencesKey.mediapressAllowedTypes, jsonEncode(newList.map((e) => e.toJson()).toList()));
  }

  @action
  Future<void> setStoryAllowedMedia(List<String> newList) async {
    storyAllowedMediaType.clear();
    storyAllowedMediaType.addAll(newList);
    await setValue(SharePreferencesKey.storyAllowedTypes, jsonEncode(newList));
  }

  @action
  Future<void> setMediaStatusList(List<PrivacyStatus> newList) async {
    mediaStatusList.clear();
    mediaStatusList.addAll(newList);
    await setValue(SharePreferencesKey.mediaStatus, jsonEncode(newList.map((e) => e.toJson()).toList()));
  }

  @action
  Future<void> setAdsVisibility(bool val) async {
    showAds = val;
    setValue(SharePreferencesKey.showAds, val, print: true);
  }

  @action
  Future<void> setInAppSubscription(bool val) async {
    hasInAppSubscription = val;
    await setValue(SharePreferencesKey.hasInAppSubscription, val, print: true);
  }

  @action
  Future<void> setInAppActiveSubscription(String val) async {
    inAppActiveSubscription = val;
    await setValue(SharePreferencesKey.inAppActiveSubscription, val, print: true);
  }

  @action
  Future<void> setAutoPlay(bool val) async {
    autoPlay = val;
  }

  @action
  Future<void> setBlogsVisibility(bool val) async {
    showBlogs = val;
    setValue(SharePreferencesKey.showBlogs, val, print: true);
  }

  @action
  Future<void> setFreeSubscription(bool val) async {
    isFreeSubscription = val;
    setValue(SharePreferencesKey.freeSubscription, val, print: true);
  }

  @action
  Future<void> setSocialLoginVisibility(bool val) async {
    showSocialLogin = val;
    setValue(SharePreferencesKey.showSocialLogin, val, print: true);
  }

  @action
  Future<void> setShopVisibility(bool val) async {
    showShop = val;
    setValue(SharePreferencesKey.showShop, val, print: true);
  }

  @action
  Future<void> setGamiPressVisibility(bool val) async {
    showGamiPress = val;
    setValue(SharePreferencesKey.showGamiPress, val, print: true);
  }

  @action
  Future<void> setLearnPressVisibility(bool val) async {
    showLearnPress = val;
    setValue(SharePreferencesKey.showLearnPress, val, print: true);
  }

  @action
  Future<void> setMemberShipVisibility(bool val) async {
    showMemberShip = val;
    setValue(SharePreferencesKey.showMembership, val, print: true);
  }

  @action
  Future<void> setForumsVisibility(bool val) async {
    showForums = val;
    setValue(SharePreferencesKey.showForums, val, print: true);
  }

  @action
  Future<void> setGamiPressEnable(bool val) async {
    isGamiPressEnable = val;
    setValue(SharePreferencesKey.isGamiPressEnable, isGamiPressEnable, print: true);
  }

  @action
  Future<void> setAuthVerificationEnable(bool val) async {
    isAuthVerificationEnable = val;
    await setValue(SharePreferencesKey.isAccountVerificationRequire, val, print: true);
  }

  @action
  Future<void> setFilterContent(bool val) async {
    filterContent = val;
    await setValue(SharePreferencesKey.FILTER_CONTENT, val, print: true);
  }

  @action
  Future<void> setIsSocialLogin(bool val) async {
    isSocialLogin = val;
    await setValue(SharePreferencesKey.showSocialLogin, isSocialLogin);
  }

  @action
  Future<void> setReactionsEnable(bool val) async {
    isReactionEnable = val;
    setValue(SharePreferencesKey.isReactionEnable, isReactionEnable, print: true);
  }

  @action
  Future<void> setWebsocketEnable(bool val) async {
    isWebsocketEnable = val;
    setValue(SharePreferencesKey.isWebSocketEnable, isWebsocketEnable, print: true);
  }

  @action
  Future<void> setMultiSelect(bool val) async {
    isMultiSelect = val;
  }

  @action
  Future<void> setDefaultReaction(ReactionsModel val, {bool isInitializing = false}) async {
    defaultReaction = val;
    setValue(SharePreferencesKey.defaultReaction, val.toJson());
  }

  @action
  Future<void> setGiphyKey(String val) async {
    giphyKey = val;
    await setValue(SharePreferencesKey.GIPHY_API_KEY, '$val', print: true);
  }

  @action
  Future<void> setIOSGiphyKey(String val) async {
    iosGiphyKey = val;
    await setValue(SharePreferencesKey.IOS_GIPHY_API_KEY, '$val', print: true);
  }

  @action
  Future<void> setWooCurrency(String val) async {
    wooCurrency = val;
    await setValue(SharePreferencesKey.WOO_CURRENCY, '$val', print: true);
  }

  @action
  Future<void> setNonce(String val) async {
    nonce = val;
    await setValue(SharePreferencesKey.NONCE, '$val', print: true);
  }

  @action
  Future<void> setInAppEntitlementID(String val) async {
    inAppEntitlementID = val;
    await setValue(SharePreferencesKey.entitlement_id, '$val', print: true);
  }

  @action
  Future<void> setInAppGoogleApiKey(String val) async {
    inAppGoogleApiKey = val;
    await setValue(SharePreferencesKey.google_api_key, '$val', print: true);
  }

  @action
  Future<void> setInAppAppleApiKey(String val) async {
    inAppAppleApiKey = val;
    await setValue(SharePreferencesKey.apple_api_key, '$val', print: true);
  }

  @action
  Future<void> setVerificationStatus(String val, {bool isInitializing = false}) async {
    verificationStatus = val;
    await setValue(SharePreferencesKey.VERIFICATION_STATUS, '$val', print: true);
  }

  @action
  Future<void> setNotificationCount(int value) async {
    notificationCount = value;
  }

  @action
  Future<void> setLoggedIn(bool val) async {
    isLoggedIn = val;
    await setValue(SharePreferencesKey.IS_LOGGED_IN, val, print: true);
  }

  @action
  Future<void> setStoryLoader(bool val) async {
    showStoryLoader = val;
  }

  @action
  Future<void> setLMSEnable(bool val) async {
    isLMSEnable = val;
    setValue(SharePreferencesKey.isLmsEnable, isLMSEnable, print: true);
  }

  @action
  Future<void> setCourseEnable(bool val) async {
    isCourseEnable = val;
    setValue(SharePreferencesKey.isCourseEnable, isCourseEnable, print: true);
  }

  @action
  Future<void> setDisplayPostCount(bool val) async {
    displayPostCount = val;
    setValue(SharePreferencesKey.displayPostCount, displayPostCount, print: true);
  }

  @action
  Future<void> setDisplayPostCommentsCount(bool val) async {
    displayPostCommentsCount = val;
    setValue(SharePreferencesKey.displayCommentsCount, displayPostCommentsCount, print: true);
  }

  @action
  Future<void> setDisplayFriendRequestBtn(bool val) async {
    displayFriendRequestBtn = val;
    setValue(SharePreferencesKey.displayFriendRequestBtn, displayFriendRequestBtn, print: true);
  }

  @action
  Future<void> setShopEnable(bool val) async {
    isShopEnable = val;
    setValue(SharePreferencesKey.isShopEnable, isShopEnable, print: true);
  }

  @action
  Future<void> setShowWooCommerce(bool val) async {
    showWoocommerce = val;
    setValue(SharePreferencesKey.isWooCommerceEnable, showWoocommerce);
  }

  @action
  Future<void> setShowStoryHighlight(bool val) async {
    showStoryHighlight = val;
    setValue(SharePreferencesKey.isHighlightStoryEnable, showStoryHighlight);
  }

  @action
  Future<void> setShowGif(bool val) async {
    showGif = val;
    setValue(SharePreferencesKey.showGIF, showGif);
  }

  @action
  Future<void> setAppbarAndBottomNavBar(bool val) async {
    showAppbarAndBottomNavBar = val;
  }

  @action
  Future<void> setShopBottom(bool val) async {
    showShopBottom = val;
  }

  @action
  Future<void> setLoading(bool val) async {
    isLoading = val;
  }

  @action
  Future<void> setRemember(bool val) async {
    doRemember = val;
    await setValue(SharePreferencesKey.REMEMBER_ME, val);
  }

  @action
  Future<void> toggleDarkMode({bool? value, bool isFromMain = false}) async {
    isDarkMode = value ?? !isDarkMode;

    if (isDarkMode) {
      textPrimaryColorGlobal = Colors.white;
      textSecondaryColorGlobal = bodyDark;

      defaultLoaderBgColorGlobal = Colors.white;
      appButtonBackgroundColorGlobal = Colors.white;
      shadowColorGlobal = Colors.white12;
    } else {
      textPrimaryColorGlobal = textPrimaryColor;
      textSecondaryColorGlobal = bodyWhite;

      defaultLoaderBgColorGlobal = Colors.white;
      appButtonBackgroundColorGlobal = appColorPrimary;
      shadowColorGlobal = Colors.black12;
    }

    if (!isFromMain) setStatusBarColor(isDarkMode ? appBackgroundColorDark : appLayoutBackground, delayInMilliSeconds: 300);
  }

  @action
  Future<void> setLanguage(String aCode) async {
    selectedLanguageDataModel = getSelectedLanguageModel(defaultLanguage: Constants.defaultLanguage);
    selectedLanguage = getSelectedLanguageModel(defaultLanguage: Constants.defaultLanguage)!.languageCode!;
    language = await AppLocalizations().load(Locale(selectedLanguage));
  }

  @action
  Future<void> setLoadingDots(bool val) async {
    isLoadingDots = val;
  }

  @action
  Future<void> setSelectedMedia(MediaModel newData) async {
    selectedAlbumMedia = newData;
  }

  @action
  Future<void> setProfileVisibility(List<ProfileVisibilityModel> newList) async {
    profileVisibility.clear();
    profileVisibility.addAll(newList);
  }

  @action
  Future<void> updateProfileVisibility(int groupIndex, int fieldIndex, String newValue) async {
    profileVisibility[groupIndex].isChange = true;
    profileVisibility[groupIndex].fields.validate()[fieldIndex].level = newValue;
  }

  Future<void> setDashboardIndex(int index) async {
    currentDashboardIndex = index;
  }

  Future<void> setSelectedAlbumId(int id) async {
    createdAlbumId = id;
  }

  Future<void> setCartCount(int value) async {
    cartCount = value;
    setValue(SharePreferencesKey.cartCount, value);
  }
}
