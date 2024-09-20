import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:socialv/components/base_scaffold_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/pmp_models/membership_model.dart';
import 'package:socialv/network/pmp_repositry.dart';
import 'package:socialv/screens/membership/components/plan_subtitle_component.dart';
import 'package:socialv/screens/membership/screens/membership_plans_screen.dart';
import 'package:socialv/screens/membership/screens/cancel_membership_screen.dart';
import 'package:socialv/screens/membership/components/past_invoices_component.dart';
import 'package:socialv/screens/membership/screens/pmp_checkout_screen.dart';
import 'package:socialv/services/in_app_purchase_service.dart';
import 'package:socialv/utils/cached_network_image.dart';

import '../../../utils/app_constants.dart';

class MyMembershipScreen extends StatefulWidget {
  const MyMembershipScreen({Key? key}) : super(key: key);

  @override
  State<MyMembershipScreen> createState() => _MyMembershipScreenState();
}

class _MyMembershipScreenState extends State<MyMembershipScreen> {
  MembershipModel? membership;
  Offering? offering;
  StoreProduct? activeSubscription;

  bool hasMembership = false;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    getMembership();
  }

  Future<void> getMembership() async {
    appStore.setLoading(true);
    await getMembershipLevelForUser(userId: userStore.loginUserId.validate().toInt()).then((value) async {
      if (value != null) {
        hasMembership = true;
        membership = MembershipModel.fromJson(value);
        pmpStore.setPmpMembership(membership!.id.validate());

        if (appStore.hasInAppSubscription) {
          await getOffers().then((value) async {
            offering!.availablePackages.forEach((element) {
              if (element.storeProduct.identifier == appStore.inAppActiveSubscription) {
                activeSubscription = element.storeProduct;
              }
            });
          });
        }
        setState(() {});
        appStore.setLoading(false);
      } else {
        hasMembership = false;
        appStore.setLoading(false);
      }
      setState(() {});
    }).catchError((e) {
      hasError = true;
      setState(() {});
      appStore.setLoading(false);
      log('Error: ${e.toString()}');
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (appStore.isLoading) appStore.setLoading(false);
  }

  Future<void> getOffers() async {
    await InAppPurchase.getOfferings().then((value) async {
      if (value != null) {
        offering = value.current;
      }
      setState(() {});
      appStore.setLoading(false);
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: language.membership,
      child: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: context.width(),
              color: context.cardColor,
              padding: EdgeInsets.all(16),
              child: Text(language.myAccount, style: boldTextStyle(color: context.primaryColor)),
            ),
            16.height,
            Text(
              userStore.loginFullName,
              style: primaryTextStyle(),
            ).paddingSymmetric(horizontal: 16),
            16.height,
            Row(
              children: [
                cachedImage(userStore.loginAvatarUrl, height: 44, width: 44, fit: BoxFit.cover).cornerRadiusWithClipRRect(22),
                16.width,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(userStore.loginName, style: secondaryTextStyle()),
                    4.height,
                    Text(userStore.loginEmail, style: secondaryTextStyle(), overflow: TextOverflow.ellipsis, maxLines: 1),
                  ],
                ),
              ],
            ).paddingSymmetric(horizontal: 16),
            Container(
              width: context.width(),
              color: context.cardColor,
              margin: EdgeInsets.symmetric(vertical: 16),
              padding: EdgeInsets.all(16),
              child: Text(language.myMemberships, style: boldTextStyle(color: context.primaryColor)),
            ),
            if (!hasError && !appStore.isLoading)
              if (hasMembership)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      membership!.name.validate(),
                      style: boldTextStyle(),
                    ),
                    6.height,
                    if (!appStore.hasInAppSubscription) PlanSubtitleComponent(plan: membership!),
                    6.height,
                    if (membership!.enddate != 0 && !appStore.hasInAppSubscription)
                      Text(
                        '${language.validTill} ${timeStampToDateFormat(membership!.enddate.validate().toInt())}',
                        style: secondaryTextStyle(size: 12),
                      ),
                    if (appStore.hasInAppSubscription && appStore.isFreeSubscription)
                      Text(
                        '${language.validTill} ${timeStampToDateFormat(membership!.enddate.validate().toInt())}',
                        style: secondaryTextStyle(size: 12),
                      ),
                    if (appStore.hasInAppSubscription && !appStore.isFreeSubscription)
                      Text(
                        '${language.validTill} ${DateFormat(DISPLAY_DATE_FORMAT).format(DateTime.parse(InAppPurchase.subscriptionExpirationDate))} ',
                        style: secondaryTextStyle(size: 12),
                      ),
                    16.height,
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (membership!.isExpired.validate())
                          appButton(
                            height: 30,
                            context: context,
                            onTap: () {
                              PmpCheckoutScreen(selectedPlan: membership!).launch(context);
                            },
                            color: appOrangeColor,
                            text: language.renew,
                          ).paddingRight(16).expand(),
                        if (appStore.hasInAppSubscription)
                          appButton(
                            height: 30,
                            context: context,
                            onTap: () {
                              MembershipPlansScreen(selectedPlanId: membership!.id.validate()).launch(context);
                            },
                            text: language.change,
                          ).expand(),
                        16.width,

                        appButton(
                          height: 30,
                          context: context,
                          onTap: () {
                            CancelMembershipScreen(currentLevelId: membership!.id.validate()).launch(context).then((value) {
                              if (value ?? false) {
                                getMembership();
                              }
                            });
                          },
                          text: language.cancel,
                          color: Colors.red,
                        ).expand(),
                      ],
                    ),
                    if (appStore.hasInAppSubscription && !appStore.isLoading)
                      appButton(
                        height: 30,
                        context: context,
                        color: greenColor.withOpacity(0.7),
                        onTap: () {
                          appStore.setLoading(true);
                          InAppPurchase.restoreSubscription().then((value) async {
                            await 1.seconds.delay;
                            toast(language.subscriptionDetailsRestored);
                            setState(() {});
                            appStore.setLoading(false);
                          }).catchError((e) {
                            toast(e.toString(), print: true);
                            appStore.setLoading(false);
                          });
                        },
                        text: language.restore,
                      ).paddingTop(16),
                  ],
                ).paddingSymmetric(horizontal: 14)
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      ic_crown,
                      height: 60,
                      width: 60,
                      fit: BoxFit.cover,
                      color: context.iconColor,
                    ).center(),
                    8.height,
                    Text(
                      language.noMembershipText,
                      style: secondaryTextStyle(),
                      textAlign: TextAlign.center,
                    ).paddingSymmetric(horizontal: 8),
                    16.height,
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(color: context.primaryColor, borderRadius: radius(4)),
                      child: Text(language.viewAllMembershipOptions, style: primaryTextStyle(color: Colors.white)).center(),
                    ).onTap(() {
                      MembershipPlansScreen().launch(context);
                    }, splashColor: Colors.transparent, highlightColor: Colors.transparent),
                    16.height,
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(color: greenColor.withOpacity(0.7), borderRadius: radius(4)),
                      child: Text(language.restorePurchases, style: primaryTextStyle(color: Colors.white)).center(),
                    ).onTap(() {
                      appStore.setLoading(true);
                      InAppPurchase.restoreSubscription().then((value) async {
                        await 1.seconds.delay;
                        toast(language.subscriptionDetailsRestored);
                        setState(() {});
                        appStore.setLoading(false);
                      }).catchError((e) {
                        toast(e.toString(), print: true);
                        appStore.setLoading(false);
                      });
                    }, splashColor: Colors.transparent, highlightColor: Colors.transparent),
                  ],
                ).paddingSymmetric(horizontal: 16),
            PastInvoicesComponent(),
          ],
        ),
      ),
    );
  }
}
