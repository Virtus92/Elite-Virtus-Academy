import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/utils/app_constants.dart';

part 'pmp_store.g.dart';

class PmpStore = PmpStoreBase with _$PmpStore;

abstract class PmpStoreBase with Store {
  @observable
  String? pmpMembership;

  @observable
  String? pmpCurrency = getStringAsync(SharePreferencesKey.PMP_CURRENCY, defaultValue: "\$");

  @observable
  bool pmpRestrictions = getBoolAsync(SharePreferencesKey.pmpRestrictions, defaultValue: false);

  @observable
  bool pmpEnable = getBoolAsync(SharePreferencesKey.pmpEnable);

  @observable
  bool canCreateGroup = getBoolAsync(SharePreferencesKey.canCreateGroup);

  @observable
  bool viewSingleGroup = getBoolAsync(SharePreferencesKey.viewSingleGroup);

  @observable
  bool viewGroups = getBoolAsync(SharePreferencesKey.viewGroups);

  @observable
  bool canJoinGroup = getBoolAsync(SharePreferencesKey.canJoinGroup);

  @observable
  bool privateMessaging = getBoolAsync(SharePreferencesKey.privateMessaging);

  @observable
  bool publicMessaging = getBoolAsync(SharePreferencesKey.publicMessaging);

  @observable
  bool sendFriendRequest = getBoolAsync(SharePreferencesKey.sendFriendRequest);

  @observable
  bool memberDirectory = getBoolAsync(SharePreferencesKey.memberDirectory);

  @action
  Future<void> setPmpRestriction(bool val) async {
    pmpRestrictions = val;
    await setValue(SharePreferencesKey.pmpRestrictions, pmpRestrictions);
  }

  @action
  Future<void> setCanCreateGroup(bool val) async {
    canCreateGroup = val;
    await setValue(SharePreferencesKey.canCreateGroup, canCreateGroup);
  }

  @action
  Future<void> setMemberDirectory(bool val) async {
    memberDirectory = val;
    await setValue(SharePreferencesKey.memberDirectory, memberDirectory);
  }

  @action
  Future<void> setSendFriendRequest(bool val) async {
    sendFriendRequest = val;
    await setValue(SharePreferencesKey.sendFriendRequest, sendFriendRequest);
  }

  @action
  Future<void> setPublicMessaging(bool val) async {
    publicMessaging = val;
    await setValue(SharePreferencesKey.publicMessaging, publicMessaging);
  }

  @action
  Future<void> setPrivateMessaging(bool val) async {
    privateMessaging = val;
    await setValue(SharePreferencesKey.privateMessaging, privateMessaging);
  }

  @action
  Future<void> setCanJoinGroup(bool val) async {
    canJoinGroup = val;
    await setValue(SharePreferencesKey.canJoinGroup, canJoinGroup);
  }

  @action
  Future<void> setViewGroups(bool val) async {
    viewGroups = val;
    await setValue(SharePreferencesKey.viewGroups, viewGroups);
  }

  @action
  Future<void> setViewSingleGroup(bool val) async {
    viewSingleGroup = val;
    await setValue(SharePreferencesKey.viewSingleGroup, viewSingleGroup);
  }

  @action
  Future<void> setPmpEnable(bool val) async {
    pmpEnable = val;
    await setValue(SharePreferencesKey.PMP_ENABLE, val);
  }

  @action
  Future<void> setPmpCurrency(String? currency) async {
    pmpCurrency = currency;
    await setValue(SharePreferencesKey.PMP_CURRENCY, currency);
  }

  @action
  Future<void> setPmpMembership(String? val, {bool isInitializing = false}) async {
    pmpMembership = val;
    if (!isInitializing) await setValue(SharePreferencesKey.PMP_MEMBERSHIP, val);
  }
}
