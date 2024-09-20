import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/models/pmp_models/bp_level_options.dart';

class MembershipModel {
  MembershipModel(
      {this.id,
      this.subscriptionId,
      this.name,
      this.description,
      this.confirmation,
      this.expirationNumber,
      this.expirationPeriod,
      this.allowSignups,
      this.initialPayment,
      this.billingAmount,
      this.cycleNumber,
      this.cyclePeriod,
      this.billingLimit,
      this.trialAmount,
      this.trialLimit,
      this.codeId,
      this.startdate,
      this.startDate,
      this.expirationDate,
      this.enddate,
      this.categories,
      this.bpLevelOptions,
      this.isInitial,
      this.isExpired,
      this.isFree,
      this.isInAppPurchase,
      this.planName,
      this.planId,
      this.storeIdentifier,
      this.inAppActiveSubscriptionIdentifier,
      this.inAppPurchaseAppleIdentifier,
      this.inAppPurchaseGoogleIdentifier});

  MembershipModel.fromJson(dynamic json) {
    id = json['id'].toString();
    planId = json['plan_id'].toString();
    planName = json['plan_name'].toString();
    isInAppPurchase = json['is_in_app_purchase'] != null ? json['is_in_app_purchase'] : 0;
    storeIdentifier = json['store_identifier'] != null ? json['store_identifier'] : "";
    inAppActiveSubscriptionIdentifier = json['in_app_active_subscription_identifier'] != null ? json['in_app_active_subscription_identifier'] : "";
    inAppPurchaseGoogleIdentifier = json['google_in_app_purchase_identifier'] != null ? json['google_in_app_purchase_identifier'] : "";
    inAppPurchaseAppleIdentifier = json['apple_in_app_purchase_identifier'] != null ? json['apple_in_app_purchase_identifier'] : "";
    subscriptionId = json['subscription_id'];
    name = json['name'];
    isFree = json['is_free'];
    description = json['description'];
    confirmation = json['confirmation'];
    expirationNumber = json['expiration_number'].toString();
    expirationPeriod = json['expiration_period'];
    allowSignups = json['allow_signups'];
    initialPayment = json['initial_payment'];
    billingAmount = json['billing_amount'];
    cycleNumber = json['cycle_number'].toString();
    cyclePeriod = json['cycle_period'];
    billingLimit = json['billing_limit'].toString();
    trialAmount = json['trial_amount'];
    trialLimit = json['trial_limit'].toString();
    codeId = json['code_id'];
    startdate = json['startdate'];
    startDate = json['start_date'];
    isInitial = json['is_initial'];
    isExpired = json['is_expired'];
    enddate = json['enddate'].toString().toInt();
    expirationDate = json['expiration_date'].toString();
    bpLevelOptions = json['bp_level_options'] != null ? BpLevelOptions.fromJson(json['bp_level_options']) : null;
    if (json['categories'] != null) {
      categories = [];
      json['categories'].forEach((v) {
        categories!.add(v);
      });
    }
  }

  String? id;
  String? planId;
  String? startDate;
  String? expirationDate;

  int? isInAppPurchase;
  String? storeIdentifier;
  String? inAppActiveSubscriptionIdentifier;

  //InAppData? inAppData;

  String? subscriptionId;
  String? name;
  String? description;
  String? confirmation;
  String? expirationNumber;
  String? expirationPeriod;
  String? allowSignups;
  int? initialPayment;
  int? billingAmount;
  String? cycleNumber;
  String? cyclePeriod;
  String? billingLimit;
  int? trialAmount;
  String? trialLimit;
  String? codeId;
  bool? isFree;
  String? startdate;
  String? planName;
  int? enddate;
  List<dynamic>? categories;
  BpLevelOptions? bpLevelOptions;
  bool? isInitial;
  bool? isExpired;
  String? inAppPurchaseGoogleIdentifier;
  String? inAppPurchaseAppleIdentifier;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['plan_id'] = planId;
    map['plan_name'] = planName;
    map['is_in_app_purchase'] = isInAppPurchase;
    map['in_app_active_subscription_identifier'] = inAppActiveSubscriptionIdentifier;
    map['google_in_app_purchase_identifier'] = inAppPurchaseGoogleIdentifier;
    map['apple_in_app_purchase_identifier'] = inAppPurchaseAppleIdentifier;
    map['store_identifier'] = storeIdentifier;
    map['subscription_id'] = subscriptionId;
    map['name'] = name;
    map['description'] = description;
    map['confirmation'] = confirmation;
    map['expiration_number'] = expirationNumber;
    map['expiration_period'] = expirationPeriod;
    map['allow_signups'] = allowSignups;
    map['initial_payment'] = initialPayment;
    map['billing_amount'] = billingAmount;
    map['cycle_number'] = cycleNumber;
    map['cycle_period'] = cyclePeriod;
    map['billing_limit'] = billingLimit;
    map['trial_amount'] = trialAmount;
    map['trial_limit'] = trialLimit;
    map['code_id'] = codeId;
    map['startdate'] = startdate;
    map['enddate'] = enddate;
    map['start_date'] = startDate;
    map['expiration_date'] = expirationDate;
    map['is_free'] = isFree;
    map['is_initial'] = isInitial;
    map['is_expired'] = isExpired;
    if (categories != null) {
      map['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    if (bpLevelOptions != null) {
      map['bp_level_options'] = bpLevelOptions!.toJson();
    }

    return map;
  }
}
