import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/utils/constants.dart';

part 'user_store.g.dart';

class UserStore = UserStoreBase with _$UserStore;

abstract class UserStoreBase with Store {
  @observable
  String token = getStringAsync(SharePreferencesKey.TOKEN);

  @observable
  String loginEmail = getStringAsync(SharePreferencesKey.LOGIN_EMAIL);

  @observable
  String loginFullName = getStringAsync(SharePreferencesKey.LOGIN_FULL_NAME);

  @observable
  String loginName = getStringAsync(SharePreferencesKey.LOGIN_DISPLAY_NAME);

  @observable
  String password = getStringAsync(SharePreferencesKey.LOGIN_PASSWORD);

  @observable
  String loginUserId = getStringAsync(SharePreferencesKey.LOGIN_USER_ID);

  @observable
  String loginAvatarUrl = getStringAsync(SharePreferencesKey.LOGIN_AVATAR_URL);

  @action
  Future<void> setToken(String val, {bool isInitializing = false}) async {
    token = val;
    if (!isInitializing) await setValue(SharePreferencesKey.TOKEN, '$val');
  }

  @action
  Future<void> setLoginEmail(String val, {bool isInitializing = false}) async {
    loginEmail = val;
    if (!isInitializing) await setValue(SharePreferencesKey.LOGIN_EMAIL, val);
  }

  @action
  Future<void> setLoginFullName(String val, {bool isInitializing = false}) async {
    loginFullName = val;
    if (!isInitializing) await setValue(SharePreferencesKey.LOGIN_FULL_NAME, val);
  }

  @action
  Future<void> setLoginName(String val, {bool isInitializing = false}) async {
    loginName = val;
    if (!isInitializing) await setValue(SharePreferencesKey.LOGIN_DISPLAY_NAME, val);
  }

  @action
  Future<void> setPassword(String val, {bool isInitializing = false}) async {
    password = val;
    if (!isInitializing) await setValue(SharePreferencesKey.LOGIN_PASSWORD, val);
  }

  @action
  Future<void> setLoginUserId(String val, {bool isInitializing = false}) async {
    loginUserId = val;
    if (!isInitializing) await setValue(SharePreferencesKey.LOGIN_USER_ID, val);
  }

  @action
  Future<void> setLoginAvatarUrl(String val, {bool isInitializing = false}) async {
    loginAvatarUrl = val;
    if (!isInitializing) await setValue(SharePreferencesKey.LOGIN_AVATAR_URL, val);
  }
}