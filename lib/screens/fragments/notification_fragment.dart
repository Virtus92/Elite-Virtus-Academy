import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/components/no_data_lottie_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/notifications/notification_model.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/screens/notification/components/notification_widget.dart';
import 'package:socialv/utils/cached_network_image.dart';

import '../../utils/app_constants.dart';

class NotificationFragment extends StatefulWidget {
  final ScrollController controller;

  const NotificationFragment({required this.controller});

  @override
  State<NotificationFragment> createState() => _NotificationFragmentState();
}

class _NotificationFragmentState extends State<NotificationFragment> {
  List<NotificationModel> notificationList = [];
  Future<List<NotificationModel>>? future;

  int mPage = 1;
  bool mIsLastPage = false;

  @override
  void initState() {
    init();
    super.initState();

    widget.controller.addListener(() {
      /// pagination
      if (appStore.currentDashboardIndex == 3) {
        if (widget.controller.position.pixels == widget.controller.position.maxScrollExtent) {
          if (!mIsLastPage) {
            onNextPage();
          }
        }
      }
    });

    LiveStream().on(RefreshNotifications, (p0) {
      setState(() {
        mPage = 1;
        mIsLastPage = false;
      });
      init();
    });
  }

  Future<void> init({bool showLoader = true, int page = 1}) async {
    appStore.setLoading(showLoader);
    future = await notificationsList(
      page: page,
      notificationList: notificationList,
      lastPageCallback: (p0) {
        setState(() {
          mIsLastPage = p0;
        });
      },
    ).then((value) {
      appStore.setLoading(false);
      appStore.setNotificationCount(notificationList.length);
      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
  }

  Future<void> onNextPage() async {
    setState(() {
      mPage++;
    });
    init(page: mPage);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    LiveStream().dispose(RefreshNotifications);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Stack(
        alignment: Alignment.topCenter,
        children: [
          FutureBuilder<List<NotificationModel>>(
            future: future,
            builder: (ctx, snap) {
              if (snap.hasError) {
                return SizedBox(
                  height: context.height() * 0.5,
                  width: context.width() - 32,
                  child: NoDataWidget(
                    imageWidget: NoDataLottieWidget(),
                    title: jsonEncode(snap.error),
                    onRetry: () {
                      LiveStream().emit(OnAddPost);
                    },
                    retryText: '   ${language.clickToRefresh}   ',
                  ),
                ).center();
              } else if (notificationList.isEmpty && !appStore.isLoading)
                return SizedBox(
                  height: context.height() * 0.8,
                  child: NoDataWidget(
                    imageWidget: NoDataLottieWidget(),
                    title: language.noNotificationsFound,
                    onRetry: () {
                      LiveStream().emit(RefreshNotifications);
                    },
                    retryText: '   ${language.clickToRefresh}   ',
                  ).center(),
                );
              return AnimatedWrap(
                itemCount: notificationList.validate().length,
                itemBuilder: (BuildContext, index) {
                  return Container(
                    color: notificationList[index].isNew == 1 ? context.cardColor : context.scaffoldBackgroundColor,
                    child: NotificationWidget(
                      notificationModel: notificationList[index],
                      callback: () {
                        init(showLoader: true);
                      },
                    ),
                  );
                },
              ).paddingOnly(top: 48);
            },
          ),
          if (notificationList.isNotEmpty)
            Positioned(
              top: 16,
              right: 16,
              child: TextIcon(
                prefix: cachedImage(ic_delete, color: Colors.red, width: 20, height: 20, fit: BoxFit.cover),
                text: language.clearAll,
                textStyle: primaryTextStyle(color: Colors.red),
                onTap: () async {
                  appStore.setLoading(true);
                  await clearNotification().then((value) {
                    appStore.setNotificationCount(0);
                    init(showLoader: true);
                  }).catchError((error) {
                    toast(error.toString());
                    appStore.setLoading(false);
                  });
                },
              ),
            ),
          if (appStore.isLoading)
            Positioned(
              bottom: mPage != 1 ? 10 : null,
              child: LoadingWidget(isBlurBackground: false).paddingTop(mPage == 1 ? context.height() * 0.4 : 0),
            )
        ],
      ),
    );
  }
}
