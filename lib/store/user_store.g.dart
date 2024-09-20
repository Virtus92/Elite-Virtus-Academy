// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$UserStore on UserStoreBase, Store {
  late final _$tokenAtom = Atom(name: 'UserStoreBase.token', context: context);

  @override
  String get token {
    _$tokenAtom.reportRead();
    return super.token;
  }

  @override
  set token(String value) {
    _$tokenAtom.reportWrite(value, super.token, () {
      super.token = value;
    });
  }

  late final _$loginEmailAtom =
      Atom(name: 'UserStoreBase.loginEmail', context: context);

  @override
  String get loginEmail {
    _$loginEmailAtom.reportRead();
    return super.loginEmail;
  }

  @override
  set loginEmail(String value) {
    _$loginEmailAtom.reportWrite(value, super.loginEmail, () {
      super.loginEmail = value;
    });
  }

  late final _$loginFullNameAtom =
      Atom(name: 'UserStoreBase.loginFullName', context: context);

  @override
  String get loginFullName {
    _$loginFullNameAtom.reportRead();
    return super.loginFullName;
  }

  @override
  set loginFullName(String value) {
    _$loginFullNameAtom.reportWrite(value, super.loginFullName, () {
      super.loginFullName = value;
    });
  }

  late final _$loginNameAtom =
      Atom(name: 'UserStoreBase.loginName', context: context);

  @override
  String get loginName {
    _$loginNameAtom.reportRead();
    return super.loginName;
  }

  @override
  set loginName(String value) {
    _$loginNameAtom.reportWrite(value, super.loginName, () {
      super.loginName = value;
    });
  }

  late final _$passwordAtom =
      Atom(name: 'UserStoreBase.password', context: context);

  @override
  String get password {
    _$passwordAtom.reportRead();
    return super.password;
  }

  @override
  set password(String value) {
    _$passwordAtom.reportWrite(value, super.password, () {
      super.password = value;
    });
  }

  late final _$loginUserIdAtom =
      Atom(name: 'UserStoreBase.loginUserId', context: context);

  @override
  String get loginUserId {
    _$loginUserIdAtom.reportRead();
    return super.loginUserId;
  }

  @override
  set loginUserId(String value) {
    _$loginUserIdAtom.reportWrite(value, super.loginUserId, () {
      super.loginUserId = value;
    });
  }

  late final _$loginAvatarUrlAtom =
      Atom(name: 'UserStoreBase.loginAvatarUrl', context: context);

  @override
  String get loginAvatarUrl {
    _$loginAvatarUrlAtom.reportRead();
    return super.loginAvatarUrl;
  }

  @override
  set loginAvatarUrl(String value) {
    _$loginAvatarUrlAtom.reportWrite(value, super.loginAvatarUrl, () {
      super.loginAvatarUrl = value;
    });
  }

  late final _$setTokenAsyncAction =
      AsyncAction('UserStoreBase.setToken', context: context);

  @override
  Future<void> setToken(String val, {bool isInitializing = false}) {
    return _$setTokenAsyncAction
        .run(() => super.setToken(val, isInitializing: isInitializing));
  }

  late final _$setLoginEmailAsyncAction =
      AsyncAction('UserStoreBase.setLoginEmail', context: context);

  @override
  Future<void> setLoginEmail(String val, {bool isInitializing = false}) {
    return _$setLoginEmailAsyncAction
        .run(() => super.setLoginEmail(val, isInitializing: isInitializing));
  }

  late final _$setLoginFullNameAsyncAction =
      AsyncAction('UserStoreBase.setLoginFullName', context: context);

  @override
  Future<void> setLoginFullName(String val, {bool isInitializing = false}) {
    return _$setLoginFullNameAsyncAction
        .run(() => super.setLoginFullName(val, isInitializing: isInitializing));
  }

  late final _$setLoginNameAsyncAction =
      AsyncAction('UserStoreBase.setLoginName', context: context);

  @override
  Future<void> setLoginName(String val, {bool isInitializing = false}) {
    return _$setLoginNameAsyncAction
        .run(() => super.setLoginName(val, isInitializing: isInitializing));
  }

  late final _$setPasswordAsyncAction =
      AsyncAction('UserStoreBase.setPassword', context: context);

  @override
  Future<void> setPassword(String val, {bool isInitializing = false}) {
    return _$setPasswordAsyncAction
        .run(() => super.setPassword(val, isInitializing: isInitializing));
  }

  late final _$setLoginUserIdAsyncAction =
      AsyncAction('UserStoreBase.setLoginUserId', context: context);

  @override
  Future<void> setLoginUserId(String val, {bool isInitializing = false}) {
    return _$setLoginUserIdAsyncAction
        .run(() => super.setLoginUserId(val, isInitializing: isInitializing));
  }

  late final _$setLoginAvatarUrlAsyncAction =
      AsyncAction('UserStoreBase.setLoginAvatarUrl', context: context);

  @override
  Future<void> setLoginAvatarUrl(String val, {bool isInitializing = false}) {
    return _$setLoginAvatarUrlAsyncAction.run(
        () => super.setLoginAvatarUrl(val, isInitializing: isInitializing));
  }

  @override
  String toString() {
    return '''
token: ${token},
loginEmail: ${loginEmail},
loginFullName: ${loginFullName},
loginName: ${loginName},
password: ${password},
loginUserId: ${loginUserId},
loginAvatarUrl: ${loginAvatarUrl}
    ''';
  }
}
