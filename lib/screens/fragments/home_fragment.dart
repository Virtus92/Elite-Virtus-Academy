import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/components/no_data_lottie_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/posts/post_model.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/screens/home/components/ad_component.dart';
import 'package:socialv/screens/home/components/initial_home_component.dart';
import 'package:socialv/screens/home/components/suggested_user_component.dart';
import 'package:socialv/screens/post/components/post_component.dart';
import 'package:socialv/screens/stories/component/home_story_component.dart';

import '../../utils/app_constants.dart';

class HomeFragment extends StatefulWidget {
  final ScrollController controller;

  const HomeFragment({super.key, required this.controller});

  @override
  State<HomeFragment> createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  List<PostModel> postList = [];
  Future<List<PostModel>>? future;
  int mPage = 1;
  bool mIsLastPage = false;
  bool showAllCaughtUp = false;

  @override
  void initState() {
    init();

    _animationController = BottomSheet.createAnimationController(this);
    _animationController.duration = const Duration(milliseconds: 500);
    _animationController.drive(CurveTween(curve: Curves.easeOutQuad));

    super.initState();

    setStatusBarColorBasedOnTheme();

    widget.controller.addListener(() {
      /// pagination
      if (appStore.currentDashboardIndex == 0) {
        if (widget.controller.position.pixels == widget.controller.position.maxScrollExtent) {
          if (!mIsLastPage) {
            onNextPage();
          }
        }
      }
    });

    LiveStream().on(OnAddPost, (p0) {
      setState(() {
        mPage = 1;
        mIsLastPage = false;
      });
      init();
    });
  }

  Future<void> init({bool showLoader = true, int page = 1}) async {
    if (!appStore.isLoggedIn) return;
    appStore.setLoading(showLoader);
    future = getPost(
      page: page,
      type: PostRequestType.newsFeed,
      postList: postList,
      userId: userStore.loginUserId.toInt(),
      lastPageCallback: (p0) async {
        mIsLastPage = p0;
        if (p0) {
          setState(() {
            showAllCaughtUp = true;
          });
          await 10.seconds.delay;
          setState(() {
            showAllCaughtUp = false;
          });
        }
      },
    ).then((value) {
      appStore.setLoading(false);
      setState(() {});

      return value;
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
      throw e;
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
    LiveStream().dispose(OnAddPost);
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            HomeStoryComponent(
              callback: () {
                LiveStream().emit(GetUserStories);
              },
            ),
            SnapHelperWidget(
              future: future,
              errorBuilder: (error) {
                return SizedBox(
                  height: context.height() * 0.5,
                  width: context.width() - 32,
                  child: NoDataWidget(
                    imageWidget: NoDataLottieWidget(),
                    title: error,
                    onRetry: () {
                      LiveStream().emit(OnAddPost);
                    },
                    retryText: '   ${language.clickToRefresh}   ',
                  ),
                ).center();
              },
              loadingWidget: Offstage(),
              onSuccess: (data) {
                if (postList.isEmpty && !appStore.isLoading)
                  return SizedBox(
                    height: context.height() * 0.5,
                    child: InitialHomeComponent().center(),
                  );
                return Column(
                  children: [
                    ...List.generate(data.length, (index) {
                      return Column(
                        children: [
                          PostComponent(
                            key: ValueKey(index),
                            post: data[index],
                            count: 0,
                            callback: () {
                              init(showLoader: false);
                              setState(() {});
                            },
                            commentCallback: () {
                              init(showLoader: false);
                            },
                            showHidePostOption: true,
                          ).paddingSymmetric(horizontal: 8),
                          if ((index + 1) % 5 == 0) AdComponent().visible(appStore.showAds),
                          if ((index + 1) == 3)
                            if (pmpStore.pmpEnable)
                              if (pmpStore.memberDirectory) SuggestedUserComponent() else Offstage()
                            else
                              SuggestedUserComponent(),
                        ],
                      );
                    }),
                    if (mIsLastPage) SizedBox(height: 120),
                  ],
                );
              },
            ),
          ],
        ),
        Observer(
          builder: (_) {
            if (appStore.isLoading) {
              if (mPage > 1) {
                return Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: ThreeBounceLoadingWidget(),
                );
              } else {
                return LoadingWidget(isBlurBackground: false).paddingTop(context.height() * 0.4);
              }
            } else {
              return Offstage();
            }
          },
        ),
      ],
    );
  }
}
