import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/activity_response.dart';
import 'package:socialv/models/auth_verification_model.dart';
import 'package:socialv/models/block_report/blocked_accounts_model.dart';
import 'package:socialv/models/common_models.dart';
import 'package:socialv/models/common_models/avatar_urls.dart';
import 'package:socialv/models/common_models/common_message_response.dart';
import 'package:socialv/models/common_models/coverimage_response.dart';
import 'package:socialv/models/dashboard_api_response.dart';
import 'package:socialv/models/delete_avatar_response.dart';
import 'package:socialv/models/delete_cover_image_response.dart';
import 'package:socialv/models/forums/common_models.dart';
import 'package:socialv/models/forums/forum_model.dart';
import 'package:socialv/models/forums/subsription_list_model.dart';
import 'package:socialv/models/forums/topic_model.dart';
import 'package:socialv/models/general_settings_model.dart';
import 'package:socialv/models/groups/accept_group_request_model.dart';
import 'package:socialv/models/groups/delete_group_response.dart';
import 'package:socialv/models/groups/group_membership_requests_model.dart';
import 'package:socialv/models/groups/group_model.dart';
import 'package:socialv/models/groups/group_request_model.dart';
import 'package:socialv/models/groups/group_response.dart';
import 'package:socialv/models/groups/reject_group_invite_response.dart';
import 'package:socialv/models/groups/remove_group_member.dart';
import 'package:socialv/models/login_response.dart';
import 'package:socialv/models/members/friend_request_model.dart';
import 'package:socialv/models/members/friendship_response_model.dart';
import 'package:socialv/models/members/member_detail_model.dart';
import 'package:socialv/models/members/member_model.dart';
import 'package:socialv/models/members/member_response.dart';
import 'package:socialv/models/members/profile_visibility_model.dart';
import 'package:socialv/models/members/remove_existing_friend.dart';
import 'package:socialv/models/notifications/delete_notification_response_model.dart';
import 'package:socialv/models/notifications/notification_model.dart';
import 'package:socialv/models/notifications/notification_settings_model.dart';
import 'package:socialv/models/posts/comment_model.dart';
import 'package:socialv/models/posts/get_post_likes_model.dart';
import 'package:socialv/models/posts/post_model.dart';
import 'package:socialv/models/posts/wp_comments_model.dart';
import 'package:socialv/models/posts/wp_post_response.dart';
import 'package:socialv/models/reactions/reactions_model.dart';
import 'package:socialv/models/register_user_model.dart';
import 'package:socialv/models/story/common_story_model.dart';
import 'package:socialv/models/story/highlight_category_list_model.dart';
import 'package:socialv/models/story/highlight_stories_model.dart';
import 'package:socialv/models/story/story_response_model.dart';
import 'package:socialv/models/story/story_views_model.dart';
import 'package:socialv/models/woo_commerce/cart_model.dart';
import 'package:socialv/models/woo_commerce/category_model.dart';
import 'package:socialv/models/woo_commerce/country_model.dart';
import 'package:socialv/models/woo_commerce/coupon_model.dart';
import 'package:socialv/models/woo_commerce/customer_model.dart';
import 'package:socialv/models/woo_commerce/order_model.dart';
import 'package:socialv/models/woo_commerce/order_notes_model.dart';
import 'package:socialv/models/woo_commerce/payment_model.dart';
import 'package:socialv/models/woo_commerce/product_detail_model.dart';
import 'package:socialv/models/woo_commerce/product_list_model.dart';
import 'package:socialv/models/woo_commerce/product_review_model.dart';
import 'package:socialv/models/woo_commerce/wishlist_model.dart';
import 'package:socialv/network/network_utils.dart';
import 'package:socialv/services/in_app_purchase_service.dart';
import 'package:socialv/utils/app_constants.dart';
import 'package:socialv/utils/push_notification_service.dart';

import '../models/gallery/album_media_list_model.dart';
import '../models/gallery/albums.dart';
import '../models/invitations/invite_list_model.dart';
import '../models/reactions/activity_reaction_model.dart';
import '../models/reactions/reactions_count_model.dart';
import '../models/woo_commerce/common_models.dart';
import '../screens/auth/screens/sign_in_screen.dart';

bool get isTokenExpire => getStringAsync(SharePreferencesKey.TOKEN).isNotEmpty ? JwtDecoder.isExpired(getStringAsync(SharePreferencesKey.TOKEN)) : true;

// region Auth
Future<RegisterUserModel> createUser(Map request) async {
  return RegisterUserModel.fromJson(await handleResponse(await buildHttpResponse('${APIEndPoint.membersEndPoint}/${APIEndPoint.registerEndPoint}', request: request, method: HttpMethod.POST, isAuth: true)));
}

Future<LoginResponse> loginUser({required Map request, required bool isSocialLogin, bool setLoggedIn = true}) async {
  LoginResponse response = LoginResponse.fromJson(await handleResponse(await buildHttpResponse(
    isSocialLogin ? '${APIEndPoint.membersEndPoint}/${APIEndPoint.loginEndPoint}' : APIEndPoint.login,
    request: request,
    method: HttpMethod.POST,
    isAuth: true,
  )));
  userStore.setToken(response.token.validate());
  if (setLoggedIn) appStore.setLoggedIn(true);
  userStore.setLoginUserId(response.userId.toString());

  await PushNotificationService().subscribeToFirebaseTopic().then((v) async {
    await manageFirebaseToken(1).then((value) {}).catchError((e) {
      log("firebase token error : ${e.toString()}");
    });
  });

  userStore.setLoginName(response.userNicename.validate());
  userStore.setLoginFullName(response.userDisplayName.validate());
  userStore.setLoginEmail(response.userEmail.validate());
  userStore.setLoginAvatarUrl(response.profilePicture.validate());
  appStore.setNonce(response.storeApiNonce.validate());
  setValue(SharePreferencesKey.lastTimeWoocommerceNonceGenerated, DateTime.now().millisecondsSinceEpoch);
  messageStore.setBmSecretKey(response.bmSecretKey.validate());
  if (response.subcriptionPlan.isNotEmpty && pmpStore.pmpEnable) {
    pmpStore.setPmpMembership(response.subcriptionPlan.first.planId);
    appStore.setFreeSubscription(response.subcriptionPlan.first.isFree.validate());
  }
  checkApiCallIsWithinTimeSpan(callback: () => generalSettings, sharePreferencesKey: SharePreferencesKey.LAST_APP_CONFIGURATION_CALL_TIME, forceConfigSync: !getBoolAsync(SharePreferencesKey.isAPPConfigurationCalledAtLeastOnce));
  setRestrictions(levelId: response.subcriptionPlan.isNotEmpty ? response.subcriptionPlan.first.planId.validate() : "");
  if (pmpStore.pmpEnable) {
    if (appStore.hasInAppSubscription) InAppPurchase.init();
  }

  appStore.setIsSocialLogin(isSocialLogin);
  appStore.setVerificationStatus(response.verificationStatus.validate());

  return response;
}

Future<NonceModel> getNonce() async {
  return NonceModel.fromJson(await handleResponse(await buildHttpResponse('${APIEndPoint.storeNonce}', passParameters: true)));
}

Future<CommonMessageResponse> forgetPassword({required String email}) async {
  Map request = {"email": email};

  return CommonMessageResponse.fromJson(
    await handleResponse(await buildHttpResponse('${APIEndPoint.membersEndPoint}/${APIEndPoint.forgotPasswordEndPoint}', method: HttpMethod.POST, request: request, isAuth: true)),
  );
}

Future<void> logout(BuildContext context, {bool setId = true}) async {
  appStore.setLoading(true);
  await manageFirebaseToken(0).then((value) {}).catchError((e) {
    log("firebase token error : ${e.toString()}");
  });
  await removeKey(SharePreferencesKey.LOGIN_FULL_NAME);
  await removeKey(SharePreferencesKey.LOGIN_DISPLAY_NAME);
  await removeKey(SharePreferencesKey.LOGIN_PASSWORD);
  await removeKey(SharePreferencesKey.LOGIN_USER_ID);
  await removeKey(SharePreferencesKey.LOGIN_AVATAR_URL);
  if (!appStore.doRemember) {
    removeKey(SharePreferencesKey.LOGIN_DISPLAY_NAME);
    removeKey(SharePreferencesKey.LOGIN_PASSWORD);
  }
  await messageStore.setBmSecretKey('');
  await appStore.setNonce('');
  await userStore.setToken('');

  appStore.setVerificationStatus('');
  appStore.setNotificationCount(0);
  messageStore.setMessageCount(0);
  appStore.recentMemberSearchList.clear();
  appStore.recentGroupsSearchList.clear();
  lmsStore.quizList.clear();
  pmpStore.setPmpMembership(null);
  removeKey(SharePreferencesKey.PMP_MEMBERSHIP);
  setValue(SharePreferencesKey.LMS_QUIZ_LIST, '');
  await removeKey(SharePreferencesKey.cachedPostList);

  appStore.setSelectedAlbumId(0);
  appStore.setDashboardIndex(0);
  await appStore.setLoggedIn(false);
  removeKey(SharePreferencesKey.cartCount);
  removeKey(SharePreferencesKey.lastTimeCheckChatUserSettings);
  removeKey(SharePreferencesKey.lastTimeCheckMessagesSettings);
  removeKey(SharePreferencesKey.emojiList);
  finish(context);
  await removeKey(SharePreferencesKey.TOKEN);

  SignInScreen().launch(context, pageRouteAnimation: PageRouteAnimation.Scale, isNewTask: true);
}

Future<CommonMessageResponse> deleteAccount() async {
  return CommonMessageResponse.fromJson(
    await handleResponse(
      await buildHttpResponse('${APIEndPoint.membersEndPoint}/${APIEndPoint.deleteAccountEndPoint}', method: HttpMethod.DELETE),
    ),
  );
}

Future<AuthVerificationModel> verifyKey({required String key}) async {
  Map request = {"verification_key": key};
  return AuthVerificationModel.fromJson(
    await handleResponse(await buildHttpResponse('${APIEndPoint.activateAccount}', method: HttpMethod.POST, request: request)),
  );
}

Future<AuthVerificationModel> resendActivationKey({required Map request}) async {
  return AuthVerificationModel.fromJson(
    await handleResponse(await buildHttpResponse('${APIEndPoint.activateAccount}/${APIEndPoint.activationKey}', method: HttpMethod.POST, request: request)),
  );
}

Future<CommonMessageResponse> updateProfile({required Map request}) async {
  return CommonMessageResponse.fromJson(
    await handleResponse(
      await buildHttpResponse('${APIEndPoint.membersEndPoint}/${APIEndPoint.settingsEndPoint}/${APIEndPoint.profileEndPoint}', method: HttpMethod.POST, request: request),
    ),
  );
}

//endregion

//region Members
Future<List<MemberResponse>> getAllMembers({
  int page = 1,
  String searchText = '',
  String type = '',
  required List<MemberResponse> memberList,
  Function(bool)? lastPageCallback,
}) async {
  List<String> params = [];

  if (searchText.isNotEmpty) {
    params.add('search=$searchText');
    params.add('current_user=${userStore.loginUserId}');
  }
  params.add('per_page=$PER_PAGE');
  params.add('page=$page');
  if (type.isNotEmpty) params.add('type=$type');

  Iterable it = await handleResponse(
    await buildHttpResponse(getEndPoint(endPoint: '${APIEndPoint.getMembers}', params: params)),
  );

  if (page == 1) memberList.clear();

  lastPageCallback?.call(it.validate().length != PER_PAGE);

  memberList.addAll(it.map((e) => MemberResponse.fromJson(e)).toList());

  return memberList;
}

Future<List<AvatarUrls>> getMemberAvatarImage({required int memberId}) async {
  Iterable it = await handleResponse(
    await buildHttpResponse('${APIEndPoint.getMembers}/$memberId/avatar'),
  );

  return it.map((e) => AvatarUrls.fromJson(e)).toList();
}

Future<List<MemberResponse>> getOnlineMembers() async {
  Iterable it = await handleResponse(
    await buildHttpResponse('${APIEndPoint.getMembers}?type=${MemberType.online}&page=1&per_page=$PER_PAGE&user_id=${userStore.loginUserId}'),
  );

  return it.map((e) => MemberResponse.fromJson(e)).toList();
}

Future<MemberResponse> updateLoginUser({required Map request}) async {
  return MemberResponse.fromJson(await handleResponse(await buildHttpResponse('${APIEndPoint.getMembers}/me', method: HttpMethod.PUT, request: request)));
}

/// Friendship Connection

Future<List<FriendshipResponseModel>> requestNewFriend(Map request) async {
  Iterable it = await handleResponse(await buildHttpResponse('${APIEndPoint.getFriends}', request: request, method: HttpMethod.POST));

  return it.map((e) => FriendshipResponseModel.fromJson(e)).toList();
}

Future<RemoveExistingFriend> removeExistingFriendConnection({required String friendId, required bool passRequest}) async {
  Map request = {"force": true};

  return RemoveExistingFriend.fromJson(await handleResponse(await buildHttpResponse('${APIEndPoint.getFriends}/$friendId', method: HttpMethod.DELETE, request: passRequest ? request : null)));
}

Future<List<FriendshipResponseModel>> acceptFriendRequest({required int id}) async {
  Iterable it = await handleResponse(await buildHttpResponse('${APIEndPoint.getFriends}/$id', method: HttpMethod.PUT));

  return it.map((e) => FriendshipResponseModel.fromJson(e)).toList();
}

//endregion

// region Images

Future<DeleteCoverImageResponse> deleteGroupCoverImage({required int id}) async {
  return DeleteCoverImageResponse.fromJson(await handleResponse(await buildHttpResponse('${APIEndPoint.buddyPressGroupEndpoint}/$id/${APIEndPoint.coverImage}', method: HttpMethod.DELETE)));
}

Future<DeleteCoverImageResponse> deleteMemberCoverImage({required int id}) async {
  return DeleteCoverImageResponse.fromJson(await handleResponse(await buildHttpResponse('${APIEndPoint.getMembers}/$id/${APIEndPoint.coverImage}', method: HttpMethod.DELETE)));
}

Future<void> attachMemberImage({required String id, File? image, bool isCover = false}) async {
  appStore.setLoading(true);

  MultipartRequest multiPartRequest = await getMultiPartRequest('${APIEndPoint.getMembers}/$id/${isCover ? APIEndPoint.coverImage : APIEndPoint.avatarImage}');

  multiPartRequest.headers['authorization'] = 'Bearer ${userStore.token}';

  multiPartRequest.fields['action'] = isCover ? GroupImageKeys.coverActionKey : GroupImageKeys.avatarActionKey;
  multiPartRequest.files.add(await MultipartFile.fromPath('file', image!.path));

  await sendMultiPartRequest(
    multiPartRequest,
    onSuccess: (data) async {
      List<AvatarUrls> imageList = [];

      List jsonResponse = json.decode(data);
      jsonResponse.map((i) {
        imageList.add(AvatarUrls.fromJson(i));
      }).toList();

      if (!isCover) userStore.setLoginAvatarUrl(imageList.first.full.validate());
      appStore.setLoading(false);
      toast(language.profilePictureUpdatedSuccessfully, print: true);
    },
    onError: (error) {
      log('error: ${error.toString()}');
    },
  );
}

Future<void> groupAttachImage({required int id, File? image, bool isCoverImage = false}) async {
  MultipartRequest multiPartRequest = await getMultiPartRequest('${APIEndPoint.buddyPressGroupEndpoint}/$id/${isCoverImage ? APIEndPoint.coverImage : APIEndPoint.avatarImage}');

  multiPartRequest.headers['authorization'] = 'Bearer ${userStore.token}';

  multiPartRequest.fields['action'] = isCoverImage ? GroupImageKeys.coverActionKey : GroupImageKeys.avatarActionKey;
  multiPartRequest.files.add(await MultipartFile.fromPath('file', image!.path));

  await sendMultiPartRequest(
    multiPartRequest,
    onSuccess: (data) async {
      List<CoverImageResponse> imageList = [];

      toast(isCoverImage ? language.coverUpdatedSuccessfully : language.avatarUpdatedSuccessfully);

      List jsonResponse = json.decode(data);
      jsonResponse.map((i) {
        imageList.add(CoverImageResponse.fromJson(i));
      }).toList();
    },
    onError: (error) {
      log(error.toString());
    },
  );
}

Future<void> deleteMemberAvatarImage({required String id}) async {
  appStore.setLoading(true);
  await deleteAvatarImage(id: id).then((value) async {
    await getMemberAvatarUrls(id: id).then((value) {
      userStore.setLoginAvatarUrl(value.first.full.validate());
      appStore.setLoading(false);
      toast(language.profilePictureRemovedSuccessfully);
    });
  }).catchError((e) {
    appStore.setLoading(false);
    toast(e.toString(), print: true);
    throw e;
  });
}

Future<List<AvatarUrls>> getMemberAvatarUrls({required String id}) async {
  Iterable it = await handleResponse(await buildHttpResponse('${APIEndPoint.getMembers}/$id/${APIEndPoint.avatarImage}'));

  return it.map((e) => AvatarUrls.fromJson(e)).toList();
}

Future<DeleteAvatarResponse> deleteAvatarImage({required String id, bool isGroup = false}) async {
  return DeleteAvatarResponse.fromJson(await handleResponse(await buildHttpResponse('${isGroup ? APIEndPoint.buddyPressGroupEndpoint : APIEndPoint.getMembers}/$id/${APIEndPoint.avatarImage}', method: HttpMethod.DELETE)));
}

Future<List<CoverImageResponse>> getMemberCoverImage({required String id}) async {
  Iterable it = await handleResponse(await buildHttpResponse('${APIEndPoint.getMembers}/$id/${APIEndPoint.coverImage}'));

  return it.map((e) => CoverImageResponse.fromJson(e)).toList();
}

//endregion

// region Groups

Future<List<GroupResponse>> getBuddyPressGroupList({
  required List<GroupResponse> groupList,
  String searchText = '',
  int page = 1,
  Function(bool)? lastPageCallback,
}) async {
  List<String> params = [];
  if (searchText.isNotEmpty) params.add('search=$searchText');
  params.add('per_page=$PER_PAGE');
  params.add('page=$page');

  Iterable it = await handleResponse(await buildHttpResponse(
    getEndPoint(endPoint: APIEndPoint.buddyPressGroupEndpoint, params: params),
  ));

  if (page == 1) groupList.clear();

  lastPageCallback?.call(it.validate().length != PER_PAGE);

  groupList.addAll(it.map((e) => GroupResponse.fromJson(e)).toList());

  return groupList;
}

Future<List<GroupModel>> getUserGroupList({
  required List<GroupModel> groupList,
  String groupType = GroupRequestType.all,
  String searchText = '',
  int? userId,
  int page = 1,
  Function(bool)? lastPageCallback,
}) async {
  List<String> params = [];
  params.add('type=$groupType');
  params.add('user_id=${userId ?? userStore.loginUserId}');
  if (searchText.isNotEmpty) params.add('search=$searchText');
  params.add('per_page=$PER_PAGE');
  params.add('page=$page');

  Iterable it = await handleResponse(await buildHttpResponse(
    getEndPoint(
      endPoint: '${APIEndPoint.socialVApiEndPoint}/${APIEndPoint.groupsEndpoint}',
      params: params,
    ),
    method: HttpMethod.GET,
  ));

  if (page == 1) groupList.clear();

  lastPageCallback?.call(it.validate().length != PER_PAGE);

  groupList.addAll(it.map((e) => GroupModel.fromJson(e)).toList());

  return groupList;
}

Future<GroupModel> getGroupDetail({int? groupId}) async {
  List<String> params = [];
  params.add('posts_per_page=$PER_PAGE');
  return GroupModel.fromJson(await handleResponse(await buildHttpResponse(getEndPoint(endPoint: '${APIEndPoint.socialVApiEndPoint}/${APIEndPoint.groupsEndpoint}/${groupId}', params: params), method: HttpMethod.GET)));
}

Future<List<MemberModel>> getGroupMembersList({int? groupId, int page = 1, String search = ''}) async {
  List<String> params = [];

  params.add('per_page=$PER_PAGE');
  params.add('page=$page');

  if (search.isNotEmpty) params.add('search_terms=$search');
  Iterable it = await handleResponse(
    await buildHttpResponse(
      getEndPoint(endPoint: '${APIEndPoint.socialVApiEndPoint}/${APIEndPoint.groupsEndpoint}/${APIEndPoint.membersEndpoint}/${groupId}', params: params),
      method: HttpMethod.GET,
    ),
  );
  return it.map((e) => MemberModel.fromJson(e)).toList();
}

Future<List<GroupRequestModel>> getGroupMembershipRequest({int? groupId, int page = 1}) async {
  List<String> params = [];

  params.add('per_page=20');
  params.add('page=$page');

  Iterable it = await handleResponse(
    await buildHttpResponse(
      getEndPoint(endPoint: '${APIEndPoint.socialVApiEndPoint}/${APIEndPoint.groupsEndpoint}/${APIEndPoint.requestEndpoint}/${groupId}', params: params),
      method: HttpMethod.GET,
    ),
  );
  return it.map((e) => GroupRequestModel.fromJson(e)).toList();
}

Future<List<GroupInviteModel>> getGroupInviteList({int? groupId, int page = 1}) async {
  List<String> params = [];
  params.add('per_page=$PER_PAGE');
  params.add('page=$page');

  Iterable it = await handleResponse(await buildHttpResponse(getEndPoint(endPoint: '${APIEndPoint.socialVApiEndPoint}/${APIEndPoint.groupsEndpoint}/${APIEndPoint.invitesEndPoint}/${groupId}', params: params), method: HttpMethod.GET));
  return it.map((e) => GroupInviteModel.fromJson(e)).toList();
}

Future<CommonMessageResponse> invite({required int isInviting, required int userId, required int groupId}) async {
  Map request = {"user_id": userId, "is_inviting": isInviting};
  return CommonMessageResponse.fromJson(await handleResponse(await buildHttpResponse('${APIEndPoint.socialVApiEndPoint}/${APIEndPoint.groupsEndpoint}/${APIEndPoint.invitesEndPoint}/$groupId', method: HttpMethod.POST, request: request)));
}

Future<List<SuggestedGroup>> getSuggestedGroupList({int page = 1}) async {
  Iterable it = await handleResponse(await buildHttpResponse('${APIEndPoint.buddyPressGroupEndpoint}?type=suggestions&per_page=20&page=$page', method: HttpMethod.GET));

  return it.map((e) => SuggestedGroup.fromJson(e)).toList();
}

Future<CommonMessageResponse> removeSuggestedGroup({required int groupId}) async {
  return CommonMessageResponse.fromJson(
    await handleResponse(
      await buildHttpResponse(
        '${APIEndPoint.membersEndPoint}/${APIEndPoint.suggestionEndpoint}/${APIEndPoint.refuseEndPoint}/${APIEndPoint.groupEndPoint}/${groupId}',
        method: HttpMethod.POST,
      ),
    ),
  );
}

Future<DeleteGroupResponse> deleteGroup({String? id}) async {
  return DeleteGroupResponse.fromJson(await handleResponse(await buildHttpResponse('${APIEndPoint.buddyPressGroupEndpoint}/$id', method: HttpMethod.DELETE)));
}

Future<List<GroupResponse>> createGroup(Map request) async {
  Iterable it = await handleResponse(await buildHttpResponse(APIEndPoint.buddyPressGroupEndpoint, request: request, method: HttpMethod.POST));

  return it.map((e) => GroupResponse.fromJson(e)).toList();
}

Future<GroupResponse> updateGroup({required Map request, required int groupId}) async {
  Iterable it = await handleResponse(await buildHttpResponse('${APIEndPoint.buddyPressGroupEndpoint}/$groupId', request: request, method: HttpMethod.PUT));

  it.map((e) => GroupResponse.fromJson(e)).toList();

  return it.map((e) => GroupResponse.fromJson(e)).toList().firstWhere((element) => element.id == groupId);
}

/// Group Invites

Future<RejectGroupInviteResponse> rejectGroupInvite({required int id}) async {
  return RejectGroupInviteResponse.fromJson(await handleResponse(await buildHttpResponse('${APIEndPoint.buddyPressGroupEndpoint}/${APIEndPoint.invitesEndPoint}/$id', method: HttpMethod.DELETE)));
}

Future<List<GroupRequestsModel>> acceptGroupInvite({required String id}) async {
  Iterable it = await handleResponse(await buildHttpResponse('${APIEndPoint.buddyPressGroupEndpoint}/${APIEndPoint.invitesEndPoint}/$id', method: HttpMethod.PUT));

  return it.map((e) => GroupRequestsModel.fromJson(e)).toList();
}

/// Group Membership Requests

Future<List<GroupRequestsModel>> joinPublicGroup({required int groupId}) async {
  Map request = {"user_id": userStore.loginUserId.toInt()};

  Iterable it = await handleResponse(await buildHttpResponse('${APIEndPoint.buddyPressGroupEndpoint}/$groupId/${APIEndPoint.groupMembers}', method: HttpMethod.POST, request: request));
  return it.map((e) => GroupRequestsModel.fromJson(e)).toList();
}

Future<RemoveGroupMember> leaveGroup({required int groupId}) async {
  return RemoveGroupMember.fromJson(await handleResponse(await buildHttpResponse('${APIEndPoint.buddyPressGroupEndpoint}/$groupId/${APIEndPoint.groupMembers}/${userStore.loginUserId}', method: HttpMethod.DELETE)));
}

Future<RemoveGroupMember> removeGroupMember({required int groupId, required int memberId}) async {
  return RemoveGroupMember.fromJson(await handleResponse(await buildHttpResponse('${APIEndPoint.buddyPressGroupEndpoint}/$groupId/${APIEndPoint.groupMembers}/$memberId', method: HttpMethod.DELETE)));
}

Future<List<GroupRequestsModel>> groupMemberRoles({required int groupId, required int memberId, required String role, required String action}) async {
  Map request = {"role": role, "action": action};
  Iterable it = await handleResponse(await buildHttpResponse('${APIEndPoint.buddyPressGroupEndpoint}/$groupId/${APIEndPoint.groupMembers}/$memberId', method: HttpMethod.PUT, request: request));

  return it.map((e) => GroupRequestsModel.fromJson(e)).toList();
}

Future<List<GroupMembershipRequestsModel>> sendGroupMembershipRequest(Map request) async {
  Iterable it = await handleResponse(await buildHttpResponse('${APIEndPoint.buddyPressGroupEndpoint}/${APIEndPoint.groupMembershipRequests}', method: HttpMethod.POST, request: request));
  return it.map((e) => GroupMembershipRequestsModel.fromJson(e)).toList();
}

Future<List<GroupRequestsModel>> acceptGroupMembershipRequest({required int requestId}) async {
  Iterable it = await handleResponse(await buildHttpResponse('${APIEndPoint.buddyPressGroupEndpoint}/${APIEndPoint.groupMembershipRequests}/$requestId', method: HttpMethod.PUT));
  return it.map((e) => GroupRequestsModel.fromJson(e)).toList();
}

Future<RejectGroupInviteResponse> rejectGroupMembershipRequest({required int requestId}) async {
  return RejectGroupInviteResponse.fromJson(await handleResponse(await buildHttpResponse('${APIEndPoint.buddyPressGroupEndpoint}/${APIEndPoint.groupMembershipRequests}/$requestId', method: HttpMethod.DELETE)));
}

/// Group Settings Requests

Future<CommonMessageResponse> editGroupSettings({int? groupId, required Map<String, dynamic> request}) async {
  return CommonMessageResponse.fromJson(await handleResponse(await buildHttpResponse('${APIEndPoint.socialVApiEndPoint}/${APIEndPoint.groupsEndpoint}/${APIEndPoint.settingsEndPoint}/$groupId', method: HttpMethod.POST, request: request)));
}

//endregion

// region notifications

Future<void> manageFirebaseToken(int add) async {
  Map req = {"firebase_token": getStringAsync(SharePreferencesKey.firebaseToken), "add": add};

  await handleResponse(await buildHttpResponse('${APIEndPoint.manageFirebaseToken}', method: HttpMethod.POST, request: req));
}

Future<DeleteNotificationResponseModel> deleteNotification({required String notificationId}) async {
  return DeleteNotificationResponseModel.fromJson(await handleResponse(await buildHttpResponse('${APIEndPoint.buddypressNotifications}/$notificationId', method: HttpMethod.DELETE)));
}

Future<List<NotificationModel>> notificationsList({
  int page = 1,
  required List<NotificationModel> notificationList,
  Function(bool)? lastPageCallback,
}) async {
  List<String> params = [];
  params.add('per_page=$PER_PAGE');
  params.add('page=$page');

  Iterable it = await handleResponse(await buildHttpResponse(getEndPoint(endPoint: '${APIEndPoint.getNotifications}', params: params)));

  if (page == 1) notificationList.clear();

  lastPageCallback?.call(it.validate().length != PER_PAGE);

  notificationList.addAll(it.map((e) => NotificationModel.fromJson(e)).toList());

  return notificationList;
}

Future<List<ActivityResponse>> latestActivity({int page = 1}) async {
  Iterable it = await handleResponse(await buildHttpResponse('${APIEndPoint.activity}?page=1&per_page=5'));
  return it.map((e) => ActivityResponse.fromJson(e)).toList();
}

Future<CommonMessageResponse> clearNotification() async {
  return CommonMessageResponse.fromJson(
    await handleResponse(
      await buildHttpResponse('${APIEndPoint.socialVApiEndPoint}/${APIEndPoint.notificationsEndPoint}', method: HttpMethod.DELETE),
    ),
  );
}

/// Custom apis

// region Post
Future<List<PostModel>> getPost({
  int page = 1,
  required int userId,
  int? groupId,
  required String type,
  required List<PostModel> postList,
  Function(bool)? lastPageCallback,
}) async {
  if (!await isNetworkAvailable()) return [];

  List<String> params = [];

  params.add('page=$page');
  params.add('per_page=$PER_PAGE');
  if (groupId != null) params.add('group_id=$groupId');

  String endPoint = '${APIEndPoint.socialVActivityEndpoint}' + '/$type';

  if (type == PostRequestType.favorites || type == PostRequestType.timeline) {
    endPoint = endPoint + '/${userId}';
  } else if (type == PostRequestType.group) {
    if (groupId != null) endPoint = endPoint + '/${groupId}';
  }

  Iterable it = await handleResponse(await buildHttpResponse(getEndPoint(endPoint: endPoint, params: params), method: HttpMethod.GET));

  if (page == 1) postList.clear();

  lastPageCallback?.call(it.validate().length != PER_PAGE);

  postList.addAll(it.map((e) => PostModel.fromJson(e)).toList());

  if (type == PostRequestType.newsFeed) await setValue(SharePreferencesKey.cachedPostList, jsonEncode(postList.map((e) => e.toJson()).toList()));
  return postList;
}

Future<PostModel> getSinglePost({required int postId}) async {
  List<String> params = [];
  params.add('comments_per_page=6');
  return PostModel.fromJson(
    await handleResponse(await buildHttpResponse(getEndPoint(endPoint: '${APIEndPoint.socialVActivityEndpoint}/$postId', params: params), method: HttpMethod.GET)),
  );
}

Future<void> uploadPost({
  List<PostMedia>? postMedia,
  String? content,
  bool isMedia = false,
  String postIn = "0",
  String? mediaType,
  int? id,
  String? gif,
  String? type,
  String? parentPostId,
  String? mediaId,
  String? currentActivityType,
}) async {
  MultipartRequest multiPartRequest = await getMultiPartRequest('${APIEndPoint.socialVActivityEndpoint}');

  multiPartRequest.headers['authorization'] = 'Bearer ${userStore.token}';

  if (id != null) multiPartRequest.fields['id'] = id.validate().toString();
  multiPartRequest.fields['content'] = content.validate();
  multiPartRequest.fields['activity_type'] = type != null
      ? type
      : isMedia
          ? gif != null
              ? PostActivityType.activityUpdate
              : PostActivityType.mppMediaUpload
          : PostActivityType.activityUpdate;
  multiPartRequest.fields['post_in'] = postIn.validate();
  if (postMedia.validate().isNotEmpty) multiPartRequest.fields['media_count'] = postMedia.validate().length.toString();
  if (gif.validate().isNotEmpty) multiPartRequest.fields['media_count'] = "1";
  multiPartRequest.fields['media_type'] = isMedia ? mediaType.validate() : "0";
  multiPartRequest.fields['media_id'] = mediaId.validate();
  multiPartRequest.fields['child_id'] = parentPostId.validate();
  multiPartRequest.fields['current_type'] = currentActivityType != null
      ? currentActivityType
      : isMedia
          ? gif != null
              ? PostActivityType.activityUpdate
              : PostActivityType.mppMediaUpload
          : PostActivityType.activityUpdate;
  multiPartRequest.fields['component'] = postIn.validate() != '0' ? Component.groups : Component.activity;

  if (postMedia.validate().isNotEmpty) {
    await Future.forEach(postMedia.validate(), (PostMedia element) async {
      int index = postMedia.validate().indexOf(element);

      if (element.isLink) {
        multiPartRequest.fields['media_$index'] = element.link.validate();
      } else {
        multiPartRequest.files.add(await MultipartFile.fromPath("media_$index", element.file!.path));
      }
    });
  } else if (gif.validate().isNotEmpty) {
    multiPartRequest.fields['media_0'] = gif.validate();
  }

  log('files ${multiPartRequest.files.map((e) => e.filename).toList()}');
  log('fields ${multiPartRequest.fields}');

  await sendMultiPartRequest(
    multiPartRequest,
    onSuccess: (data) async {
      CommonMessageResponse message = CommonMessageResponse.fromJson(jsonDecode(data));
      appStore.setLoading(false);
      toast(message.message);
    },
    onError: (error) {
      appStore.setLoading(false);
      if (error is Map && error.containsKey('message')) {
        toast(error['message'], print: true);
      } else
        toast("Post upload failed");
    },
  );
}

Future<List<GetPostLikesModel>> getPostLikes({required int id, int page = 1}) async {
  Iterable it = await handleResponse(
    await buildHttpResponse(getEndPoint(endPoint: "${APIEndPoint.socialVActivityEndpoint}/${APIEndPoint.likesEndpoint}/$id", page: page, perPages: PER_PAGE), method: HttpMethod.GET),
  );

  return it.map((e) => GetPostLikesModel.fromJson(e)).toList();
}

Future<CommonMessageResponse> likePost({required int postId}) async {
  return CommonMessageResponse.fromJson(
    await handleResponse(await buildHttpResponse('${APIEndPoint.socialVActivityEndpoint}/${APIEndPoint.likesEndpoint}/$postId', method: HttpMethod.POST)),
  );
}

Future<CommonMessageResponse> deletePost({required int postId}) async {
  return CommonMessageResponse.fromJson(
    await handleResponse(await buildHttpResponse('${APIEndPoint.socialVActivityEndpoint}/$postId', method: HttpMethod.DELETE)),
  );
}

Future<CommonMessageResponse> savePostComment({required int postId, required Map<String, dynamic> request}) async {
  return CommonMessageResponse.fromJson(await handleResponse(await buildHttpResponse(
    '${APIEndPoint.socialVActivityEndpoint}/$postId/${APIEndPoint.commentsEndPoint}',
    method: request.containsKey('comment_id') ? HttpMethod.PUT : HttpMethod.POST,
    request: request,
  )));
}

Future<CommonMessageResponse> deletePostComment({required int commentId, required int postId}) async {
  Map request = {"comment_id": commentId};
  return CommonMessageResponse.fromJson(await handleResponse(await buildHttpResponse(
    '${APIEndPoint.socialVActivityEndpoint}/$postId/${APIEndPoint.commentsEndPoint}',
    method: HttpMethod.DELETE,
    request: request,
  )));
}

Future<List<CommentModel>> getComments({
  required int id,
  int? page,
  required List<CommentModel> commentList,
  Function(bool)? lastPageCallback,
}) async {
  List<String> params = [];
  params.add('per_page=$PER_PAGE');
  params.add('page=$page');

  Iterable it = await handleResponse(await buildHttpResponse(getEndPoint(endPoint: '${APIEndPoint.socialVActivityEndpoint}/$id/${APIEndPoint.commentsEndPoint}', params: params), method: HttpMethod.GET));
  lastPageCallback?.call(it.validate().length != PER_PAGE);
  if (page == 1) commentList.clear();

  commentList.addAll(it.map((e) => CommentModel.fromJson(e)).toList());
  return commentList;
}

Future<void> hidePost({required int id}) async {
  await handleResponse(await buildHttpResponse('${APIEndPoint.socialVActivityEndpoint}/${APIEndPoint.hideEndpoint}/$id', method: HttpMethod.POST));
}

Future<WpPostResponse> wpPostById({required int postId, String? password}) async {
  return WpPostResponse.fromJson(await handleResponse(await buildHttpResponse('${APIEndPoint.wpPost}/$postId?_embed${password.validate().isNotEmpty ? '&password=$password' : ''}')));
}

Future<List<ReactionsModel>> getReactions() async {
  Iterable it = await handleResponse(await buildHttpResponse('${APIEndPoint.getReactionList}'));
  return it.map((e) => ReactionsModel.fromJson(e)).toList();
}

Future<ActivityReactionModel> addPostReaction({required int id, required int reactionId, required bool isComments}) async {
  Map request = {
    "reaction_id": reactionId,
    "user_id": userStore.loginUserId,
  };

  return ActivityReactionModel.fromJson(
    await handleResponse(await buildHttpResponse('${isComments ? APIEndPoint.commentsReaction : APIEndPoint.activityReaction}/$id', method: HttpMethod.POST, request: request)),
  );
}

Future<ActivityReactionModel> deletePostReaction({required int id, required bool isComments}) async {
  Map request = {
    "user_id": userStore.loginUserId,
  };

  return ActivityReactionModel.fromJson(
    await handleResponse(await buildHttpResponse('${isComments ? APIEndPoint.commentsReaction : APIEndPoint.activityReaction}/$id', method: HttpMethod.DELETE, request: request)),
  );
}

Future<ReactionCountModel> getUsersReaction({required int id, required bool isComments, int page = 1, required String reactionID}) async {
  return ReactionCountModel.fromJson(
    await handleResponse(await buildHttpResponse('${isComments ? APIEndPoint.commentsReaction : APIEndPoint.activityReaction}/$id?page=$page&per_page=$PER_PAGE&reaction_id=$reactionID')),
  );
}

Future<CommonMessageResponse> favoriteActivity({required Map<String, dynamic> request, required int activityId}) async {
  return CommonMessageResponse.fromJson(await handleResponse(await buildHttpResponse(
    '${APIEndPoint.socialVActivityEndpoint}/${PostRequestType.favorites}/$activityId',
    method: HttpMethod.POST,
    request: request,
  )));
}

Future<CommonMessageResponse> pinActivity({required int activityId, required Map<String, dynamic> request}) async {
  return CommonMessageResponse.fromJson(await handleResponse(await buildHttpResponse('${APIEndPoint.socialVActivityEndpoint}/${APIEndPoint.pinActivity}/$activityId', method: HttpMethod.POST, request: request)));
}

Future<List<WpPostResponse>> getBlogList({int? page, String? searchText}) async {
  Iterable it = await handleResponse(await buildHttpResponse('${APIEndPoint.wpPost}?_embed&page=$page&per_page=$PER_PAGE&search=$searchText', method: HttpMethod.GET));
  return it.map((e) => WpPostResponse.fromJson(e)).toList();
}

Future<List<WpCommentModel>> getBlogComments({int? id, int page = 1}) async {
  Iterable it = await handleResponse(await buildHttpResponse('${APIEndPoint.wpComments}?post=$id&order=asc&page=$page&per_page=$PER_PAGE', method: HttpMethod.GET));
  return it.map((e) => WpCommentModel.fromJson(e)).toList();
}

Future<WpCommentModel> addBlogComment({required int postId, String? content, int? parentId}) async {
  Map request = {"post": postId, "content": content, "parent": parentId};
  return WpCommentModel.fromJson(await handleResponse(await buildHttpResponse('${APIEndPoint.wpComments}', method: HttpMethod.POST, request: request)));
}

Future<CommonMessageResponse> deleteBlogComment({required int commentId}) async {
  return CommonMessageResponse.fromJson(await handleResponse(await buildHttpResponse('${APIEndPoint.blogComment}/$commentId', method: HttpMethod.DELETE)));
}

Future<WpCommentModel> updateBlogComment({required int commentId, String? content}) async {
  Map request = {"content": content};
  return WpCommentModel.fromJson(await handleResponse(await buildHttpResponse('${APIEndPoint.blogComment}/$commentId', method: HttpMethod.PUT, request: request)));
}

Future<List<ActivityResponse>> searchPost({
  String? searchText,
  int page = 1,
}) async {
  Iterable it = await handleResponse(await buildHttpResponse('${APIEndPoint.activity}?search=$searchText&component=activity&page=$page&per_page=$PER_PAGE'));
  return it.map((e) => ActivityResponse.fromJson(e)).toList();
}

//endregion

// region member
Future<MemberDetailModel> getMemberDetail({required int userId}) async {
  List<String> params = [];
  params.add('posts_per_page=$PER_PAGE');
  return MemberDetailModel.fromJson(await handleResponse(await buildHttpResponse(getEndPoint(endPoint: '${APIEndPoint.membersEndPoint}/$userId', params: params), method: HttpMethod.GET)));
}

/*Future<List<FriendRequestModel>> getFriendList({required int userId, int page = 1,required List<FriendRequestModel> membersList, Function(int)? countCall}) async {
  Map request = {"user_id": userId, "per_page": 20, "page": page};

  FriendListResponse res=FriendListResponse.fromJson(await handleResponse(await buildHttpResponse('${APIEndPoint.getFriendList}', method: HttpMethod.POST, request: request)));
  countCall?.call(res.count.validate());
  membersList.addAll(res.friendList.validate());

  return res.friendList.validate();
}*/

Future<List<FriendRequestModel>> getFriendList({
  int? userId,
  String? searchString,
  required List<FriendRequestModel> membersList,
  required int page,
  Function(bool)? lastPageCallback,
  Function(int)? countCall,
}) async {
  List<String> param = [];

  param.add('per_page=$PER_PAGE');
  param.add('page=$page');

  FriendListResponse res = FriendListResponse.fromJson(
    await handleResponse(
      await buildHttpResponse(getEndPoint(endPoint: '${APIEndPoint.membersEndPoint}/${APIEndPoint.friendsEndPoint}/${userId}', params: param), method: HttpMethod.GET),
      isFriendList: true,
    ),
  );

  countCall?.call(res.count.validate());
  if (page == 1) membersList.clear();

  lastPageCallback?.call(res.friendList.validate().length != PER_PAGE);

  membersList.addAll(res.friendList.validate());

  return membersList;
}

Future<List<FriendRequestModel>> getFriendRequestList({int page = 1}) async {
  List<String> param = [];

  param.add('per_page=$PER_PAGE');
  param.add('page=$page');
  Iterable it = await handleResponse(await buildHttpResponse(getEndPoint(endPoint: '${APIEndPoint.membersEndPoint}/${APIEndPoint.friendsRequestEndPoint}', params: param), method: HttpMethod.GET));

  return it.map((e) => FriendRequestModel.fromJson(e)).toList();
}

Future<List<FriendRequestModel>> getFriendRequestSent({
  int page = 1,
}) async {
  List<String> param = [];
  param.add('per_page=$PER_PAGE');
  param.add('page=$page');
  Iterable it = await handleResponse(await buildHttpResponse(getEndPoint(endPoint: '${APIEndPoint.membersEndPoint}/${APIEndPoint.friendsRequestEndPoint}/${APIEndPoint.sentEndPoint}', params: param)));

  return it.map((e) => FriendRequestModel.fromJson(e)).toList();
}

Future<List<FriendRequestModel>> getSuggestedUserList({
  int page = 1,
  required List<FriendRequestModel> suggestedUserList,
  Function(bool)? lastPageCallback,
}) async {
  List<String> param = [];
  param.add('per_page=20');
  param.add('page=$page');
  Iterable it = await handleResponse(await buildHttpResponse(getEndPoint(endPoint: '${APIEndPoint.membersEndPoint}/${APIEndPoint.suggestionEndpoint}', params: param)));
  if (page == 1) suggestedUserList.clear();

  lastPageCallback?.call(it.validate().length != PER_PAGE);

  suggestedUserList.addAll(it.map((e) => FriendRequestModel.fromJson(e)).toList());

  return suggestedUserList;
}

Future<CommonMessageResponse> removeSuggestedUser({required int userId}) async {
  return CommonMessageResponse.fromJson(
    await handleResponse(await buildHttpResponse('${APIEndPoint.membersEndPoint}/${APIEndPoint.suggestionEndpoint}/${APIEndPoint.refuseEndPoint}/${APIEndPoint.userEndPoint}/${userId}', method: HttpMethod.POST)),
  );
}

//endregion

// region settings and dashboard
Future<DashboardAPIResponse> getDashboardDetails() async {
  return DashboardAPIResponse.fromJson(
    await handleResponse(await buildHttpResponse('${APIEndPoint.membersEndPoint}/${APIEndPoint.dashboardEndPoint}', method: HttpMethod.GET)),
  );
}

Future<CommonMessageResponse> updateProfileFields({required Map request}) async {
  return CommonMessageResponse.fromJson(
    await handleResponse(
      await buildHttpResponse(
        '${APIEndPoint.membersEndPoint}/${APIEndPoint.settingsEndPoint}/${APIEndPoint.profileEndPoint}/${APIEndPoint.fieldsEndPoint}',
        method: HttpMethod.POST,
        request: request,
      ),
    ),
  );
}

Future<List<SignupFields>> getProfileFields() async {
  Iterable it = await handleResponse(
    await buildHttpResponse(
      '${APIEndPoint.membersEndPoint}/${APIEndPoint.settingsEndPoint}/${APIEndPoint.profileEndPoint}/${APIEndPoint.fieldsEndPoint}',
      method: HttpMethod.GET,
    ),
  );

  return it.map((e) => SignupFields.fromJson(e)).toList();
}

Future<List<ProfileVisibilityModel>> getProfileVisibility() async {
  Iterable it = await handleResponse(await buildHttpResponse('${APIEndPoint.membersEndPoint}/${APIEndPoint.settingsEndPoint}/${APIEndPoint.profileEndPoint}/${APIEndPoint.visibilityEndPoint}', method: HttpMethod.GET));

  return it.map((e) => ProfileVisibilityModel.fromJson(e)).toList();
}

Future<CommonMessageResponse> saveProfileVisibility({required Map request}) async {
  return CommonMessageResponse.fromJson(
    await handleResponse(await buildHttpResponse('${APIEndPoint.membersEndPoint}/${APIEndPoint.settingsEndPoint}/${APIEndPoint.profileEndPoint}/${APIEndPoint.visibilityEndPoint}', method: HttpMethod.POST, request: request)),
  );
}

Future<CommonMessageResponse> changePassword({required Map request}) async {
  return CommonMessageResponse.fromJson(
    await handleResponse(await buildHttpResponse('${APIEndPoint.membersEndPoint}/${APIEndPoint.changePasswordEndPoint}', method: HttpMethod.POST, request: request)),
  );
}

Future<List<NotificationSettingsModel>> notificationsSettings() async {
  Iterable it = await handleResponse(await buildHttpResponse('${APIEndPoint.socialVApiEndPoint}/${APIEndPoint.notificationsEndPoint}/${APIEndPoint.settingsEndPoint}'));

  return it.map((e) => NotificationSettingsModel.fromJson(e)).toList();
}

Future<CommonMessageResponse> saveNotificationsSettings({List? requestList}) async {
  return CommonMessageResponse.fromJson(
    await handleResponse(await buildHttpResponse('${APIEndPoint.socialVApiEndPoint}/${APIEndPoint.notificationsEndPoint}/${APIEndPoint.settingsEndPoint}', requestList: requestList, method: HttpMethod.POST)),
  );
}

Future<CommonMessageResponse> updateActiveStatus() async {
  return CommonMessageResponse.fromJson(
    await handleResponse(
      await buildHttpResponse('${APIEndPoint.membersEndPoint}/${APIEndPoint.userActivityStatusEndPoint}', method: HttpMethod.POST),
    ),
  );
}

Future<GeneralSettingModel> generalSettings() async {
  GeneralSettingModel value = GeneralSettingModel.fromJson(
    await handleResponse(await buildHttpResponse('${APIEndPoint.generalSettingEndPoint}')),
  );

  await appStore.setInAppEntitlementID(value.inAppPurchaseConfig.entitlementId.validate());
  await appStore.setInAppGoogleApiKey(value.inAppPurchaseConfig.googleApiKey.validate());
  await appStore.setInAppAppleApiKey(value.inAppPurchaseConfig.appleApiKey.validate());
  await appStore.setAuthVerificationEnable(value.isAccountVerificationRequire.getBoolInt());
  await appStore.setAdsVisibility(value.showAds.validate().getBoolInt());
  await appStore.setShopVisibility(value.showShop.validate().getBoolInt());
  await appStore.setBlogsVisibility(value.showBlogs.validate().getBoolInt());
  await appStore.setLearnPressVisibility(value.showLearnpress.validate().getBoolInt());
  await appStore.setGamiPressVisibility(value.showGamipress.validate().getBoolInt());
  await appStore.setMemberShipVisibility(value.showMembership.validate().getBoolInt());
  await appStore.setSocialLoginVisibility(value.showSocialLogin.validate().getBoolInt());
  await appStore.setForumsVisibility(value.showForums.validate().getBoolInt());
  await appStore.setWebsocketEnable(value.isWebsocketEnable.validate().getBoolInt());
  await appStore.setGamiPressEnable(value.isGamipressEnable.validate().getBoolInt());
  await appStore.setShowStoryHighlight(value.isHighlightStoryEnable.validate().getBoolInt());
  await appStore.setShowWooCommerce(value.isWoocommerceEnable.validate().getBoolInt());
  await appStore.setWooCurrency(parseHtmlString(value.wooCurrency.validate()));
  await appStore.setGiphyKey(parseHtmlString(value.giphyKey.validate()));
  await appStore.setReactionsEnable(value.isReactionEnable.validate().getBoolInt());
  await appStore.setLMSEnable(value.isLmsEnable.validate().getBoolInt());
  await appStore.setCourseEnable(value.isCourseEnable.validate().getBoolInt());
  await appStore.setDisplayPostCount(value.displayPostCount.validate().getBoolInt());
  await appStore.setDisplayFriendRequestBtn(value.displayFriendRequestBtn.validate().getBoolInt());
  await appStore.setShopEnable(value.isShopEnable.validate().getBoolInt());
  await appStore.setIOSGiphyKey(parseHtmlString(value.iosGiphyKey.validate()));

  await appStore.setDefaultReaction(value.defaultReaction);

  appStore.setStoryActions(value.storyActions.validate());
  appStore.setVisibilities(value.visibilities.validate());
  appStore.setAccountPrivacyVisibility(value.accountPrivacyVisibility);
  appStore.setReportTypes(value.reportTypes.validate());
  appStore.setReactions(value.reactions.validate());
  appStore.setSignUpFieldList(value.signupFields.validate());
  appStore.setAllowedMedia(value.mediapressAllowedTypes.validate());
  appStore.setStoryAllowedMedia(value.storyAllowedTypes);
  appStore.setAchievementEndPointList(value.gamipressAchievementTypes.validate());
  if (value.mediapressAllowedTypes.isNotEmpty) appStore.setGroupMediaAllowedType(value.mediapressAllowedTypes.firstWhere((element) => element.component == Component.groups));
  appStore.setShowGif(appStore.allowedMedia.any((element) => element.allowedTypes.any((e) => e.type == MediaTypes.gif)));
  await checkIsAppInReview(value).then((val) {
    if (!getBoolAsync(SharePreferencesKey.HAS_IN_REVIEW)) {
      pmpStore.setPmpEnable(value.showMembership.validate().getBoolInt());
      if (appStore.isLoggedIn && pmpStore.pmpMembership != null && pmpStore.pmpMembership.validate().isNotEmpty) setRestrictions(levelId: value.showMembership.validate().getBoolInt() ? pmpStore.pmpMembership : "");
      appStore.setInAppSubscription(value.membershipPaymentType.validate() == PaymentMethods.inAppPayment && value.isPaidMembershipEnable.validate());
      if (appStore.isLoggedIn && appStore.hasInAppSubscription) {
        log("*-*-*-*-*-*-*-*-*-*-*-*- Initializing In App purchase *-*-*-*-*-*-*-*-*-*-*-*-");
        InAppPurchase.init();
      }
    }
  });

  setValue(SharePreferencesKey.LAST_APP_CONFIGURATION_CALL_TIME, DateTime.timestamp().millisecondsSinceEpoch);
  await setValue(SharePreferencesKey.isAPPConfigurationCalledAtLeastOnce, true);

  return value;
}

//endregion

// region block report

Future<CommonMessageResponse> blockUser({required String key, required int userId}) async {
  return CommonMessageResponse.fromJson(
    await handleResponse(await buildHttpResponse('${APIEndPoint.moderationEndPoint}/${APIEndPoint.moderationMembersEndPoint}/${userId}/${key}', method: HttpMethod.POST)),
  );
}

Future<List<BlockedAccountsModel>> getBlockedAccounts() async {
  Iterable it = await handleResponse(await buildHttpResponse('${APIEndPoint.getBlockedMembers}'));

  return it.map((e) => BlockedAccountsModel.fromJson(e)).toList();
}

Future<CommonMessageResponse> reportPost({required String report, required String reportType, required int postId, required int userId}) async {
  Map request = {"user_id": userId, "report_type": reportType, "details": report};
  return CommonMessageResponse.fromJson(
    await handleResponse(await buildHttpResponse('${APIEndPoint.moderationEndPoint}/${APIEndPoint.reportEndPoint}/${APIEndPoint.postEndPoint}/$postId', method: HttpMethod.POST, request: request)),
  );
}

Future<CommonMessageResponse> reportUser({required String report, required int userId, required String reportType}) async {
  Map request = {"report_type": reportType, "details": report};
  return CommonMessageResponse.fromJson(
    await handleResponse(await buildHttpResponse('${APIEndPoint.moderationEndPoint}/${APIEndPoint.reportEndPoint}/${APIEndPoint.memberEndPoint}/${userId}', method: HttpMethod.POST, request: request)),
  );
}

Future<CommonMessageResponse> reportGroup({required String report, required int groupId, required String reportType}) async {
  Map request = {"report_type": reportType, "details": report};
  return CommonMessageResponse.fromJson(
    await handleResponse(await buildHttpResponse('${APIEndPoint.moderationEndPoint}/${APIEndPoint.reportEndPoint}/${APIEndPoint.groupEndPoint}/$groupId,', method: HttpMethod.POST, request: request)),
  );
}

//endregion

// region story
Future<void> uploadStory(
  BuildContext context, {
  required List<MediaSourceModel> fileList,
  required List<CreateStoryModel> contentList,
  String? highlightId,
  String? highlightName,
  File? highlightImage,
  bool isHighlight = false,
  String? status,
}) async {
  Future.forEach<MediaSourceModel>(fileList, (element) async {
    int index = fileList.indexOf(element);

    MultipartRequest multiPartRequest = await getMultiPartRequest('${APIEndPoint.socialVApiEndPoint}/${APIEndPoint.storiesEndPoint}');

    multiPartRequest.headers['authorization'] = 'Bearer ${userStore.token}';

    multiPartRequest.fields['story_text'] = contentList[index].storyText.validate();
    multiPartRequest.fields['story_link'] = contentList[index].storyLink.validate().isNotEmpty ? contentList[index].storyLink.validate() : "";
    multiPartRequest.fields['parent_title'] = highlightName.validate().isNotEmpty ? highlightName.validate() : "";
    multiPartRequest.fields['parent_id'] = highlightId.validate().isNotEmpty ? highlightId.validate() : "";
    multiPartRequest.fields['type'] = isHighlight ? StoryType.highlight : StoryType.global;
    multiPartRequest.fields['status'] = status ?? StoryHighlightOptions.draft;
    multiPartRequest.fields['duration'] = contentList[index].storyDuration.validate();
    multiPartRequest.files.add(await MultipartFile.fromPath(
      'media',
      element.mediaFile.path,
      contentType: MediaType(element.mediaType, element.extension),
    ));

    if (highlightImage != null) {
      multiPartRequest.files.add(
        await MultipartFile.fromPath(
          'parent_thumb',
          highlightImage.path,
          contentType: MediaType(MediaTypes.image, highlightImage.path.validate().split("/").last.split(".").last),
        ),
      );
    } else {
      multiPartRequest.fields['parent_thumb'] = "";
    }

    await sendMultiPartRequest(
      multiPartRequest,
      onSuccess: (data) async {
        appStore.setLoading(false);
        CommonMessageResponse message = CommonMessageResponse.fromJson(jsonDecode(data));
        log(message.message);
        toast(language.storyPublishedSuccessfully);
        finish(context, true);
      },
      onError: (error) {
        appStore.setLoading(false);
        if (error is Map && error.containsKey('message')) {
          toast(error['message'], print: true);
        } else
          toast("Story upload failed");
      },
    );
  });
}

Future<List<StoryResponseModel>> getUserStories({int? userId}) async {
  Iterable it;
  List<String> params = [];
  if (userId != null) params.add('user_id=$userId');
  it = await handleResponse(await buildHttpResponse(getEndPoint(endPoint: '${APIEndPoint.socialVApiEndPoint}/${APIEndPoint.storiesEndPoint}', params: params)));
  return it.map((e) => StoryResponseModel.fromJson(e)).toList();
}

Future<List<StoryResponseModel>> getStories({int? userId, required List<StoryResponseModel> storiesList}) async {
  Iterable it;
  List<String> params = [];
  storiesList.clear();

  it = await handleResponse(await buildHttpResponse(getEndPoint(endPoint: '${APIEndPoint.socialVApiEndPoint}/${APIEndPoint.storiesListEndPoint}', params: params)));
  storiesList.addAll(it.map((e) => StoryResponseModel.fromJson(e)).toList());
  return storiesList;
}

Future<CommonMessageResponse> viewStory({required int storyId}) async {
  Map request = {"story_id": storyId};

  return CommonMessageResponse.fromJson(
    await handleResponse(await buildHttpResponse('${APIEndPoint.socialVApiEndPoint}/${APIEndPoint.storiesEndPoint}/${APIEndPoint.viewStory}/${storyId}', method: HttpMethod.POST, request: request)),
  );
}

Future<List<StoryViewsModel>> getStoryViews({required int storyId}) async {
  Iterable it = await handleResponse(await buildHttpResponse('${APIEndPoint.socialVApiEndPoint}/${APIEndPoint.storiesEndPoint}/${APIEndPoint.viewStory}/${storyId}', method: HttpMethod.GET));

  return it.map((e) => StoryViewsModel.fromJson(e)).toList();
}

Future<CommonMessageResponse> deleteStory({required int storyId, required String type, required String status}) async {
  List<String> params = [];
  params.add('type=$type');
  params.add('status=$status');
  return CommonMessageResponse.fromJson(
    await handleResponse(await buildHttpResponse(
      getEndPoint(endPoint: '${APIEndPoint.socialVApiEndPoint}/${APIEndPoint.storiesEndPoint}/${storyId}', params: params),
      method: HttpMethod.DELETE,
    )),
  );
}

Future<List<HighlightCategoryListModel>> getHighlightList() async {
  Iterable it = await handleResponse(await buildHttpResponse('${APIEndPoint.socialVApiEndPoint}/${APIEndPoint.storiesEndPoint}/${APIEndPoint.highlightEndPoint}/${APIEndPoint.categoryEndPoint}'));

  return it.map((e) => HighlightCategoryListModel.fromJson(e)).toList();
}

Future<List<HighlightStoriesModel>> getHighlightStories({required String status}) async {
  Map request = {"status": status};

  Iterable it = await handleResponse(await buildHttpResponse('${APIEndPoint.socialVApiEndPoint}/${APIEndPoint.storiesEndPoint}/${APIEndPoint.highlightEndPoint}', request: request, method: HttpMethod.POST));

  return it.map((e) => HighlightStoriesModel.fromJson(e)).toList();
}

//endregion

// region woo commerce

/// products
Future<List<ProductListModel>> getProductsList({int page = 1, int? categoryId, String? orderBy, String? searchText}) async {
  Iterable it;

  if (categoryId != null) {
    it = await handleResponse(
      await buildHttpResponse(
        '${APIEndPoint.productsList}?category=$categoryId${searchText.validate().isNotEmpty ? '&search=$searchText' : ''}&page=$page&per_page=$PER_PAGE',
        passParameters: true,
        passToken: false,
      ),
    );
  } else {
    it = await handleResponse(await buildHttpResponse('${APIEndPoint.productsList}?orderby=$orderBy${searchText.validate().isNotEmpty ? '&search=$searchText' : ''}&page=$page&per_page=$PER_PAGE', passParameters: true, passToken: false));
  }

  return it.map((e) => ProductListModel.fromJson(e)).toList();
}

/// product reviews

Future<List<ProductReviewModel>> getProductReviews({required int productId}) async {
  Iterable it = await handleResponse(await buildHttpResponse('${APIEndPoint.productReviews}?product=$productId', passParameters: true, passToken: false));

  return it.map((e) => ProductReviewModel.fromJson(e)).toList();
}

Future<ProductReviewModel> addProductReview({required Map request}) async {
  return ProductReviewModel.fromJson(await handleResponse(await buildHttpResponse('${APIEndPoint.productReviews}', request: request, method: HttpMethod.POST, passParameters: true, passToken: false)));
}

Future<ProductReviewModel> updateProductReview({required Map request, required int reviewId}) async {
  return ProductReviewModel.fromJson(await handleResponse(await buildHttpResponse('${APIEndPoint.productReviews}/$reviewId', request: request, method: HttpMethod.POST, passParameters: true, passToken: false)));
}

Future<ProductReviewModel> deleteProductReview({required int reviewId}) async {
  Map request = {"force": true};

  return ProductReviewModel.fromJson(await handleResponse(await buildHttpResponse('${APIEndPoint.productReviews}/$reviewId', request: request, method: HttpMethod.DELETE, passParameters: true, passToken: false)));
}

/// Cart

Future<CartModel> getCartDetails() async {
  return CartModel.fromJson(await handleResponse(await buildHttpResponse('${APIEndPoint.cart}', requiredNonce: true)));
}

Future<CartModel> applyCoupon({required String code}) async {
  return CartModel.fromJson(await handleResponse(await buildHttpResponse('${APIEndPoint.applyCoupon}?code=$code', method: HttpMethod.POST, requiredNonce: true)));
}

Future<CartModel> removeCoupon({required String code}) async {
  return CartModel.fromJson(await handleResponse(await buildHttpResponse('${APIEndPoint.removeCoupon}?code=$code', method: HttpMethod.POST, requiredNonce: true)));
}

Future<List<CouponModel>> getCouponsList() async {
  Iterable it = await handleResponse(await buildHttpResponse('${APIEndPoint.coupons}', passHeaders: false, passParameters: true));

  return it.map((e) => CouponModel.fromJson(e)).toList();
}

Future<CartModel> addItemToCart({required int productId, required int quantity, Map? req}) async {
  Map request = {"id": productId, "quantity": quantity};
  return CartModel.fromJson(await handleResponse(await buildHttpResponse('${APIEndPoint.addCartItems}', method: HttpMethod.POST, request: req ?? request, requiredNonce: true)));
}

Future<CartModel> updateCartItem({required String productKey, required int quantity}) async {
  Map request = {"key": productKey, "quantity": quantity};

  return CartModel.fromJson(await handleResponse(await buildHttpResponse('${APIEndPoint.updateCartItems}', method: HttpMethod.POST, request: request, requiredNonce: true)));
}

Future<CartModel> removeCartItem({required String productKey}) async {
  Map request = {"key": productKey};

  return CartModel.fromJson(await handleResponse(await buildHttpResponse('${APIEndPoint.removeCartItems}', method: HttpMethod.POST, request: request, requiredNonce: true)));
}

Future<List<PaymentModel>> getPaymentMethods() async {
  Iterable it = await handleResponse(await buildHttpResponse('${APIEndPoint.getPaymentMethods}', passHeaders: false, passParameters: true));

  return it.map((e) => PaymentModel.fromJson(e)).toList();
}

Future<List<CategoryModel>> getCategoryList() async {
  Iterable it = await handleResponse(await buildHttpResponse('${APIEndPoint.categories}', passParameters: true, passToken: false));

  return it.map((e) => CategoryModel.fromJson(e)).toList();
}

Future<List<OrderModel>> getOrderList({String? status}) async {
  Iterable it = await handleResponse(await buildHttpResponse('${APIEndPoint.orders}?customer=${userStore.loginUserId}&status=$status', passParameters: true, passToken: false));

  return it.map((e) => OrderModel.fromJson(e)).toList();
}

Future<OrderModel> createOrder({required Map request}) async {
  return OrderModel.fromJson(await handleResponse(
    await buildHttpResponse('${APIEndPoint.orders}', method: HttpMethod.POST, request: request, requiredNonce: true, passParameters: true, passToken: false),
  ));
}

Future<OrderNotesModel> createOrderNotes({required Map request, required int orderId}) async {
  return OrderNotesModel.fromJson(await handleResponse(
    await buildHttpResponse('${APIEndPoint.orders}/$orderId/notes', method: HttpMethod.POST, request: request, requiredNonce: true, passParameters: true, passToken: false),
  ));
}

Future<OrderModel> cancelOrder({required int orderId, required String note}) async {
  Map request = {"status": "cancelled", "customer_note": note};

  return OrderModel.fromJson(await handleResponse(await buildHttpResponse(
    '${APIEndPoint.orders}/$orderId',
    method: HttpMethod.POST,
    requiredNonce: true,
    passParameters: true,
    passToken: false,
    request: request,
  )));
}

Future<OrderModel> deleteOrder({required int orderId}) async {
  return OrderModel.fromJson(await handleResponse(await buildHttpResponse('${APIEndPoint.orders}/$orderId', method: HttpMethod.DELETE, requiredNonce: true, passParameters: true, passToken: false)));
}

Future<CustomerModel> getCustomer() async {
  return CustomerModel.fromJson(await handleResponse(await buildHttpResponse('${APIEndPoint.customers}/${userStore.loginUserId}', passParameters: true, passToken: false)));
}

Future<CustomerModel> updateCustomer({required Map request}) async {
  return CustomerModel.fromJson(await handleResponse(
    await buildHttpResponse('${APIEndPoint.customers}/${userStore.loginUserId}', method: HttpMethod.POST, request: request, requiredNonce: true, passParameters: true, passToken: false),
  ));
}

Future<List<CountryModel>> getCountries({String? status}) async {
  Iterable it = await handleResponse(await buildHttpResponse(APIEndPoint.countries, passParameters: true, passToken: false));

  return it.map((e) => CountryModel.fromJson(e)).toList();
}

/// custom apis

Future<List<WishlistModel>> getWishList({int page = 1}) async {
  Iterable it = await handleResponse(await buildHttpResponse('${APIEndPoint.wishlist}?page=$page&per_page=20'));

  return it.map((e) => WishlistModel.fromJson(e)).toList();
}

Future<CommonMessageResponse> removeFromWishlist({required int productId}) async {
  Map request = {"product_id": productId};

  return CommonMessageResponse.fromJson(
    await handleResponse(await buildHttpResponse('${APIEndPoint.wishlist}', method: HttpMethod.DELETE, request: request)),
  );
}

Future<CommonMessageResponse> addToWishlist({required int productId}) async {
  Map request = {"product_id": productId};

  return CommonMessageResponse.fromJson(
    await handleResponse(await buildHttpResponse('${APIEndPoint.wishlist}', method: HttpMethod.POST, request: request)),
  );
}

Future<List<ProductDetailModel>> getProductDetail({required int productId}) async {
  Iterable it = await handleResponse(await buildHttpResponse('${APIEndPoint.productDetails}/$productId', method: HttpMethod.POST));

  return it.map((e) => ProductDetailModel.fromJson(e)).toList();
}

//endregion

// region forums

Future<List<ForumModel>> getForumList({
  required List<ForumModel> forumsList,
  String keyword = '',
  int page = 1,
  Function(bool)? lastPageCallback,
}) async {
  List<String> params = [];
  if (keyword.isNotEmpty) params.add('keyword=$keyword');
  params.add('posts_per_page=$PER_PAGE');
  params.add('page=$page');

  Iterable it = await handleResponse(await buildHttpResponse(getEndPoint(endPoint: '${APIEndPoint.socialVApiEndPoint}/${APIEndPoint.forumsEndPoint}', params: params), method: HttpMethod.GET));
  if (page == 1) forumsList.clear();
  lastPageCallback?.call(it.validate().length != PER_PAGE);

  forumsList.addAll(it.map((e) => ForumModel.fromJson(e)).toList());

  return forumsList;
}

Future<ForumModel> getForumDetail({required int forumId, int? topicPerPage, int? forumsPerPage, int page = 1}) async {
  List<String> params = [];
  if (topicPerPage != null) params.add("topics_per_page=$topicPerPage");
  if (forumsPerPage != null) params.add("forums_per_page=$forumsPerPage");
  return ForumModel.fromJson(
    await handleResponse(await buildHttpResponse(getEndPoint(endPoint: '${APIEndPoint.socialVApiEndPoint}/${APIEndPoint.forumsEndPoint}/$forumId', params: params), method: HttpMethod.GET)),
  );
}

Future<List<ForumModel>> getSubForumList({
  required int forumId,
  int page = 1,
  required List<ForumModel> forumList,
  Function(bool)? lastPageCallback,
}) async {
  List<String> params = ['page=$page', "per_page=$PER_PAGE"];

  Iterable data = await handleResponse(await buildHttpResponse(getEndPoint(endPoint: '${APIEndPoint.socialVApiEndPoint}/${APIEndPoint.forumsEndPoint}/$forumId/child-forums', params: params), method: HttpMethod.GET));

  if (page == 1) forumList.clear();

  lastPageCallback?.call(data.validate().length != PER_PAGE);

  forumList.addAll(data.map((e) => ForumModel.fromJson(e)).toList());

  return forumList;
}

Future<CommonMessageResponse> subscribeForum({required int forumId}) async {
  return CommonMessageResponse.fromJson(
    await handleResponse(await buildHttpResponse('${APIEndPoint.socialVApiEndPoint}/${APIEndPoint.forumsEndPoint}/${APIEndPoint.subscriptionsEndPoint}/${forumId}', method: HttpMethod.POST)),
  );
}

Future<CommonMessageResponse> createForumsTopic({required Map request}) async {
  return CommonMessageResponse.fromJson(
    await handleResponse(await buildHttpResponse('${APIEndPoint.socialVApiEndPoint}/${APIEndPoint.forumsEndPoint}/${APIEndPoint.topicsEndPoint}', method: HttpMethod.POST, request: request)),
  );
}

Future<TopicModel> getTopicDetail({required int topicId, int page = 1}) async {
  List<String> params = [];
  params.add('page=$page');
  params.add('posts_per_page=$PER_PAGE');
  return TopicModel.fromJson(await handleResponse(await buildHttpResponse(
    getEndPoint(endPoint: '${APIEndPoint.socialVApiEndPoint}/${APIEndPoint.forumsEndPoint}/${APIEndPoint.topicsEndPoint}/${APIEndPoint.detailsEndPoint}/${topicId}', params: params),
    method: HttpMethod.GET,
  )));
}

Future<CommonMessageResponse> favoriteTopic({required int topicId}) async {
  return CommonMessageResponse.fromJson(
    await handleResponse(await buildHttpResponse('${APIEndPoint.favoriteTopic}/$topicId', method: HttpMethod.POST)),
  );
}

Future<CommonMessageResponse> replyTopic({required int topicId, required Map request}) async {
  return CommonMessageResponse.fromJson(
    await handleResponse(await buildHttpResponse('${APIEndPoint.replyTopic}/$topicId', method: HttpMethod.POST, request: request)),
  );
}

Future<CommonMessageResponse> editTopicReply({required Map request, required int topicId}) async {
  return CommonMessageResponse.fromJson(
    await handleResponse(await buildHttpResponse('${APIEndPoint.editTopicReply}/$topicId', method: HttpMethod.POST, request: request)),
  );
}

Future<SubscriptionListModel> subscribedList({int page = 1, int perPage = PER_PAGE}) async {
  List<String> params = [];
  params.add('page=$page');
  params.add('posts_per_page=$PER_PAGE');

  return SubscriptionListModel.fromJson(await handleResponse(await buildHttpResponse(getEndPoint(endPoint: '${APIEndPoint.subscriptionList}', params: params), method: HttpMethod.GET)));
}

Future<List<TopicReplyModel>> forumRepliesList({
  int page = 1,
  int perPage = PER_PAGE,
  required List<TopicReplyModel> topicRepliesList,
  Function(bool)? lastPageCallback,
}) async {
  List<String> params = [];
  params.add('page=$page');
  params.add('posts_per_page=$PER_PAGE');
  params.add('is_user_replies=1');

  Iterable it = await handleResponse(await buildHttpResponse(getEndPoint(endPoint: '${APIEndPoint.forumRepliesList}/10772', params: params), method: HttpMethod.GET));

  lastPageCallback?.call(it.validate().length != PER_PAGE);

  if (page == 1) topicRepliesList.clear();

  topicRepliesList.addAll(it.map((e) => TopicReplyModel.fromJson(e)).toList());
  return topicRepliesList;
}

Future<List<TopicModel>> getTopicList({
  int page = 1,
  int? forumId,
  required String type,
  required List<TopicModel> topicList,
  List<ForumModel>? forumList,
  Function(bool)? lastPageCallback,
}) async {
  List<String> params = [];
  params.add('type=$type');
  params.add('page=$page');
  params.add('post_per_page=2');

  if (type == ForumTypes.forum) params.add('forum_id=$forumId');

  Iterable it = await handleResponse(await buildHttpResponse(getEndPoint(endPoint: '${APIEndPoint.topicList}', params: params), method: HttpMethod.GET));
  if (page == 1) topicList.clear();
  lastPageCallback?.call(it.validate().length != PER_PAGE);

  topicList.addAll(it.map((e) => TopicModel.fromJson(e)).toList());

  return topicList;
}
//endregion

// region verified user badges

Future<CommonMessageResponse> verificationRequest() async {
  return CommonMessageResponse.fromJson(await handleResponse(await buildHttpResponse('${APIEndPoint.membersEndPoint}/${APIEndPoint.accountVerificationEndPoint}', method: HttpMethod.POST)));
}
//endregion

// region gallery
Future<CommonMessageResponse> deleteMedia({required int id, required String type}) async {
  Map request = {"id": id, "type": type};
  return CommonMessageResponse.fromJson(await handleResponse(await buildHttpResponse('${APIEndPoint.mediaPressMediaEndPoint}/${APIEndPoint.getAlbums}/${APIEndPoint.mediaEndPoint}', method: HttpMethod.DELETE, request: request)));
}

Future<CommonMessageResponse> createAlbum({required String component, int? groupID, required String type, required String title, required String description, required String status}) async {
  Map request = {"component": component, "title": title, "description": description, "type": type, "status": status, "group_id": groupID};

  return CommonMessageResponse.fromJson(await handleResponse(await buildHttpResponse('${APIEndPoint.mediaPressMediaEndPoint}/${APIEndPoint.getAlbums}', method: HttpMethod.POST, request: request)));
}

Future<List<Albums>> getAlbums({
  String? type,
  int? userId,
  String? groupId,
  int? page,
  required List<Albums> albumList,
  Function(bool)? lastPageCallback,
}) async {
  List<String> params = [];
  if (userId != userStore.loginUserId.toInt()) params.add('user_id=$userId');
  if (type.validate().isNotEmpty) params.add('type=$type');
  if (groupId.validate().isNotEmpty) params.add('group_id=$groupId');
  params.add('per_page=6&page=$page');

  Iterable it = await handleResponse(await buildHttpResponse(getEndPoint(endPoint: '${APIEndPoint.mediaPressMediaEndPoint}/${APIEndPoint.getAlbums}', params: params), method: HttpMethod.GET));
  if (page == 1) albumList.clear();
  lastPageCallback?.call(it.validate().length != PER_PAGE);
  albumList.addAll(it.map((e) => Albums.fromJson(e)).toList());
  return albumList;
}

Future<List<AlbumMediaListModel>> getAlbumDetails({
  int? galleryID,
  int? page,
  required List<AlbumMediaListModel> albumMediaList,
  Function(bool)? lastPageCallback,
}) async {
  List<String> params = [];
  params.add('per_page=$PER_PAGE&page=$page');
  if (galleryID != null) params.add('gallery_id=$galleryID');
  Iterable it = await handleResponse(await buildHttpResponse(getEndPoint(endPoint: '${APIEndPoint.mediaPressMediaEndPoint}/${APIEndPoint.getAlbums}/${APIEndPoint.mediaEndPoint}', params: params), method: HttpMethod.GET));
  if (page == 1) albumMediaList.clear();
  lastPageCallback?.call(it.validate().length != PER_PAGE);
  albumMediaList.addAll(it.map((e) => AlbumMediaListModel.fromJson(e)).toList());
  return albumMediaList;
}

Future<void> uploadMediaFiles({
  int? galleryId,
  int? count,
  int? groupId,
  List<PostMedia>? media,
}) async {
  MultipartRequest multiPartRequest = await getMultiPartRequest('${APIEndPoint.mediaPressMediaEndPoint}/${APIEndPoint.getAlbums}/${APIEndPoint.mediaEndPoint}');

  multiPartRequest.headers['authorization'] = 'Bearer ${userStore.token}';

  if (galleryId != null) multiPartRequest.fields['gallery_id'] = galleryId.validate().toString();
  if (count != null) multiPartRequest.fields['count'] = count.validate().toString();
  if (groupId != null) multiPartRequest.fields['group_id'] = groupId.validate().toString();
  if (media.validate().isNotEmpty) {
    await Future.forEach(media.validate(), (PostMedia element) async {
      int index = media.validate().indexOf(element);
      multiPartRequest.files.add(await MultipartFile.fromPath("media_$index", element.file!.path));
    });

    await sendMultiPartRequest(
      multiPartRequest,
      onSuccess: (data) async {
        CommonMessageResponse message = CommonMessageResponse.fromJson(jsonDecode(data));
        toast(message.message);
      },
      onError: (error) {
        toast(error.toString(), print: true);
      },
    );
  }
}
//endregion

// region invitation

Future<List<InviteListModel>> getInviteList({String? type}) async {
  Iterable it = await handleResponse(await buildHttpResponse('${APIEndPoint.membersEndPoint}/${APIEndPoint.invitationEndpoint}', method: HttpMethod.GET));
  return it.map((e) => InviteListModel.fromJson(e)).toList();
}

Future<CommonMessageResponse> sendInvite({String? email, String? message, List? inviteId, required bool isResend}) async {
  Map request = isResend ? {"type": "resend", "invite_id": inviteId} : {"email": email, "message": message};
  return CommonMessageResponse.fromJson(await handleResponse(await buildHttpResponse('${APIEndPoint.membersEndPoint}/${APIEndPoint.invitationEndpoint}', method: HttpMethod.POST, request: request)));
}

Future<CommonMessageResponse> deleteInvitedList({List? id}) async {
  Map request = {
    "id": id,
  };
  return CommonMessageResponse.fromJson(await handleResponse(await buildHttpResponse('${APIEndPoint.membersEndPoint}/${APIEndPoint.invitationEndpoint}', method: HttpMethod.DELETE, request: request)));
}
//endregion
