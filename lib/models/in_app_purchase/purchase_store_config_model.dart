import 'package:purchases_flutter/purchases_flutter.dart';

class PurchaseStoreConfigModel {
  final Store store;
  final String apiKey;
  static PurchaseStoreConfigModel? _instance;

  factory PurchaseStoreConfigModel({required Store store, required String apiKey}) {
    _instance ??= PurchaseStoreConfigModel._internal(store, apiKey);
    return _instance!;
  }

  PurchaseStoreConfigModel._internal(this.store, this.apiKey);

  static PurchaseStoreConfigModel get instance {
    return _instance!;
  }

  static bool isForAppleStore() => instance.store == Store.appStore;

  static bool isForGooglePlay() => instance.store == Store.playStore;

}
