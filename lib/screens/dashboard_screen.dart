import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/screens/fragments/forums_fragment.dart';
import 'package:socialv/screens/fragments/home_fragment.dart';
import 'package:socialv/screens/fragments/notification_fragment.dart';
import 'package:socialv/screens/fragments/profile_fragment.dart';
import 'package:socialv/screens/fragments/search_fragment.dart';
import 'package:socialv/screens/home/components/user_detail_bottomsheet_widget.dart';
import 'package:socialv/screens/membership/screens/membership_plans_screen.dart';
import 'package:socialv/screens/messages/functions.dart';
import 'package:socialv/screens/notification/components/latest_activity_component.dart';
import 'package:socialv/screens/post/screens/add_post_screen.dart';
import 'package:socialv/screens/shop/screens/shop_screen.dart';
import 'package:socialv/utils/app_constants.dart';
import 'package:socialv/utils/cached_network_image.dart';

import 'messages/screens/message_screen.dart';

class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with TickerProviderStateMixin {
  bool hasUpdate = false;
  late AnimationController _animationController;

  ScrollController _controller = ScrollController();

  late TabController tabController;

  bool onAnimationEnd = true;

  List<Widget> appFragments = [];

  @override
  void initState() {
    appStore.setDashboardIndex(0);
    LiveStream().on(RefreshDashboard, (p0) {
      getDashboard();
    });
    appFragments.addAll([
      HomeFragment(controller: _controller),
      SearchFragment(controller: _controller),
      if (appStore.showForums) ForumsFragment(controller: _controller),
      NotificationFragment(controller: _controller),
      ProfileFragment(controller: _controller),
    ]);
    _animationController = BottomSheet.createAnimationController(this);
    _animationController.duration = const Duration(milliseconds: 500);
    _animationController.drive(CurveTween(curve: Curves.easeOutQuad));

    super.initState();
    tabController = TabController(length: appStore.showForums ? 5 : 4, vsync: this);
    setStatusBarColorBasedOnTheme();
    init();
  }

  Future<void> init() async {
    if (mounted && appStore.isLoggedIn) {
      // added appStore.isLoggedIn for not to call api when logged out. sometimes this screen remain in tree when logged out
      activeUser();
      getDashboard();
      callStream(context);
    }
  }

  Future<void> getDashboard() async {
    await getDashboardDetails().then((value) {
      appStore.setNotificationCount(value.notificationCount.validate());
      messageStore.setMessageCount(value.unreadMessagesCount.validate());
      appStore.suggestedUserList = value.suggestedUser.validate();
      appStore.suggestedGroupsList = value.suggestedGroups.validate();
    }).catchError((e) {
      log(e.toString());
      toast(e.toString());
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DoublePressBackWidget(
      onWillPop: () {
        if (appStore.currentDashboardIndex != 0) {
          appStore.currentDashboardIndex = 0;
          appStore.setDashboardIndex(0);
          setState(() {});
        }
      },
      child: RefreshIndicator(
        onRefresh: () {
          if (appStore.currentDashboardIndex == 0) {
            LiveStream().emit(GetUserStories);
            LiveStream().emit(OnAddPost);
            getDashboard();
            checkApiCallIsWithinTimeSpan(
              forceConfigSync: true,
              sharePreferencesKey: SharePreferencesKey.LAST_APP_CONFIGURATION_CALL_TIME,
              callback: () async {
                await generalSettings();
              },
            );
          } else if (appStore.currentDashboardIndex == 2) {
            LiveStream().emit(RefreshForumsFragment);
          } else if (appStore.currentDashboardIndex == 3) {
            LiveStream().emit(RefreshNotifications);
          } else if (appStore.currentDashboardIndex == 4) {
            LiveStream().emit(OnAddPostProfile);
          }

          return Future.value(true);
        },
        child: Observer(
          builder: (context) {
            return Scaffold(
              body: CustomScrollView(
                controller: _controller,
                primary: false,
                slivers: <Widget>[
                  Theme(
                    data: ThemeData(useMaterial3: false),
                    child: SliverAppBar(
                      forceElevated: true,
                      elevation: 0.5,
                      expandedHeight: 110,
                      floating: true,
                      pinned: true,
                      backgroundColor: context.scaffoldBackgroundColor,
                      title: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(APP_ICON, width: 26),
                          4.width,
                          Text(APP_NAME, style: boldTextStyle(color: context.primaryColor, size: 24, fontFamily: fontFamily)),
                        ],
                      ),
                      actions: [
                        IconButton(
                          onPressed: () {
                            AddPostScreen().launch(context).then((value) {
                              if (value ?? false) {}
                            });
                          },
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          icon: Image.asset(ic_plus, height: 22, width: 22, fit: BoxFit.fitWidth, color: context.iconColor),
                        ),
                        if (appStore.showShop)
                          Image.asset(ic_bag, height: 24, width: 24, fit: BoxFit.fitWidth, color: context.iconColor).onTap(() {
                            ShopScreen().launch(context);
                          }, splashColor: Colors.transparent, highlightColor: Colors.transparent).paddingSymmetric(horizontal: 8),
                        IconButton(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onPressed: () {
                            showModalBottomSheet(
                              elevation: 0,
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              transitionAnimationController: _animationController,
                              builder: (context) {
                                return FractionallySizedBox(
                                  heightFactor: 0.93,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 45,
                                        height: 5,
                                        //clipBehavior: Clip.hardEdge,
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: Colors.white),
                                      ),
                                      8.height,
                                      Container(
                                        clipBehavior: Clip.antiAliasWithSaveLayer,
                                        decoration: BoxDecoration(
                                          color: context.cardColor,
                                          borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                                        ),
                                        child: UserDetailBottomSheetWidget(
                                          callback: () {
                                            init();
                                          },
                                        ),
                                      ).expand(),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          icon: cachedImage(userStore.loginAvatarUrl, height: 30, width: 30, fit: BoxFit.cover).cornerRadiusWithClipRRect(15),
                        ),
                      ],
                      bottom: TabBar(
                        indicatorColor: context.primaryColor,
                        controller: tabController,
                        onTap: (val) async {
                          appStore.setDashboardIndex(val);
                        },
                        tabs: [
                          Tooltip(
                            richMessage: TextSpan(text: language.home, style: secondaryTextStyle(color: Colors.white)),
                            child: Image.asset(
                              appFragments[appStore.currentDashboardIndex].runtimeType == HomeFragment(controller: _controller).runtimeType ? ic_home_selected : ic_home,
                              height: 24,
                              width: 24,
                              fit: BoxFit.cover,
                              color: appFragments[appStore.currentDashboardIndex].runtimeType == HomeFragment(controller: _controller).runtimeType ? context.primaryColor : context.iconColor,
                            ).paddingSymmetric(vertical: 11),
                          ),
                          Tooltip(
                            richMessage: TextSpan(text: language.searchHere, style: secondaryTextStyle(color: Colors.white)),
                            child: Image.asset(
                              appFragments[appStore.currentDashboardIndex].runtimeType == SearchFragment(controller: _controller).runtimeType ? ic_search_selected : ic_search,
                              height: appFragments[appStore.currentDashboardIndex].runtimeType == SearchFragment(controller: _controller).runtimeType ? 24 : 20,
                              width: appFragments[appStore.currentDashboardIndex].runtimeType == SearchFragment(controller: _controller).runtimeType ? 24 : 20,
                              fit: BoxFit.cover,
                              color: appFragments[appStore.currentDashboardIndex].runtimeType == SearchFragment(controller: _controller).runtimeType ? context.primaryColor : context.iconColor,
                            ).paddingSymmetric(vertical: 11),
                          ),
                          if (appStore.showForums)
                            Tooltip(
                              richMessage: TextSpan(text: language.forums, style: secondaryTextStyle(color: Colors.white)),
                              child: Image.asset(
                                appFragments[appStore.currentDashboardIndex].runtimeType == ForumsFragment(controller: _controller).runtimeType ? ic_three_user_filled : ic_three_user,
                                height: 28,
                                width: 28,
                                fit: BoxFit.fill,
                                color: appFragments[appStore.currentDashboardIndex].runtimeType == ForumsFragment(controller: _controller).runtimeType ? context.primaryColor : context.iconColor,
                              ).paddingSymmetric(vertical: 9),
                            ),
                          Tooltip(
                            richMessage: TextSpan(text: language.notifications, style: secondaryTextStyle(color: Colors.white)),
                            child: Observer(
                              builder: (_) => Stack(
                                clipBehavior: Clip.none,
                                alignment: Alignment.center,
                                children: [
                                  Image.asset(
                                    appFragments[appStore.currentDashboardIndex].runtimeType == NotificationFragment(controller: _controller).runtimeType ? ic_notification_selected : ic_notification,
                                    height: 24,
                                    width: 24,
                                    fit: BoxFit.cover,
                                    color: appFragments[appStore.currentDashboardIndex].runtimeType == NotificationFragment(controller: _controller).runtimeType ? context.primaryColor : context.iconColor,
                                  ).paddingSymmetric(vertical: 11),
                                  if (appStore.notificationCount != 0)
                                    Positioned(
                                      right: appStore.notificationCount.toString().length > 1 ? -6 : -4,
                                      top: 3,
                                      child: Container(
                                        padding: EdgeInsets.all(appStore.notificationCount.toString().length > 1 ? 4 : 6),
                                        decoration: BoxDecoration(color: appColorPrimary, shape: BoxShape.circle),
                                        child: Text(
                                          appStore.notificationCount.toString(),
                                          style: boldTextStyle(color: Colors.white, size: 10, weight: FontWeight.w700, letterSpacing: 0.7),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          Tooltip(
                            richMessage: TextSpan(
                                text: language.profile,
                                style: secondaryTextStyle(
                                  color: Colors.white,
                                )),
                            child: Image.asset(
                              appFragments[appStore.currentDashboardIndex].runtimeType == ProfileFragment(controller: _controller).runtimeType ? ic_profile_filled : ic_profile,
                              height: 24,
                              width: 24,
                              fit: BoxFit.cover,
                              color: appFragments[appStore.currentDashboardIndex].runtimeType == ProfileFragment(controller: _controller).runtimeType ? context.primaryColor : context.iconColor,
                            ).paddingSymmetric(vertical: 11),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, i) {
                        return appFragments[appStore.currentDashboardIndex];
                      },
                      childCount: 1,
                    ),
                  ),
                ],
              ),
              floatingActionButton: appFragments[appStore.currentDashboardIndex].runtimeType == NotificationFragment(controller: _controller).runtimeType
                  ? FloatingActionButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          elevation: 0,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          transitionAnimationController: _animationController,
                          builder: (context) {
                            return FractionallySizedBox(
                              heightFactor: 0.7,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 45,
                                    height: 5,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: Colors.white),
                                  ),
                                  8.height,
                                  Container(
                                    padding: EdgeInsets.all(16),
                                    width: context.width(),
                                    decoration: BoxDecoration(
                                      color: context.cardColor,
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                                    ),
                                    child: LatestActivityComponent(),
                                  ).expand(),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: cachedImage(ic_history, width: 26, height: 26, fit: BoxFit.cover, color: Colors.white),
                      backgroundColor: context.primaryColor,
                    )
                  : Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        FloatingActionButton(
                          onPressed: () {
                            if (pmpStore.privateMessaging) {
                              MessageScreen().launch(context);
                            } else {
                              MembershipPlansScreen().launch(context);
                            }
                          },
                          child: cachedImage(ic_chat, width: 26, height: 26, fit: BoxFit.cover, color: Colors.white),
                          backgroundColor: context.primaryColor,
                        ),
                        if (messageStore.messageCount != 0)
                          Positioned(
                            left: messageStore.messageCount.toString().length > 1 ? -6 : -4,
                            top: -5,
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(color: blueTickColor, shape: BoxShape.circle),
                              child: Text(
                                messageStore.messageCount.toString(),
                                style: boldTextStyle(color: Colors.white, size: 10, weight: FontWeight.w700, letterSpacing: 0.7),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    ),
            );
          },
        ),
      ),
    );
  }
}
