import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/components/no_data_lottie_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/members/member_detail_model.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/screens/gamipress/screens/rewards_screen.dart';
import 'package:socialv/screens/groups/screens/group_screen.dart';
import 'package:socialv/screens/membership/screens/membership_plans_screen.dart';
import 'package:socialv/screens/post/components/post_component.dart';
import 'package:socialv/screens/profile/components/profile_header_component.dart';
import 'package:socialv/screens/profile/screens/profile_friends_screen.dart';

import '../../models/posts/post_model.dart';
import '../../utils/app_constants.dart';
import '../gallery/screens/gallery_screen.dart';
import '../profile/screens/personal_info_screen.dart';
import '../stories/component/story_highlights_component.dart';

class ProfileFragment extends StatefulWidget {
  final ScrollController? controller;

  const ProfileFragment({this.controller});

  @override
  State<ProfileFragment> createState() => _ProfileFragmentState();
}

class _ProfileFragmentState extends State<ProfileFragment> {
  MemberDetailModel? _memberDetails;
  Future<MemberDetailModel>? futureMember;
  List<PostModel> _userPostList = [];

  int mPage = 1;

  bool mIsLastPage = false;
  bool isLoading = false;
  bool isFavorites = false;
  bool hasInfo = false;

  @override
  void initState() {
    init(showLoader: true);

    setStatusBarColor(Colors.transparent);

    widget.controller?.addListener(() {
      if (appStore.currentDashboardIndex == 4) {
        if (widget.controller?.position.pixels == widget.controller?.position.maxScrollExtent) {
          if (!mIsLastPage) {
            onNextPage();
          }
        }
      }
    });

    super.initState();
    LiveStream().on(OnAddPostProfile, (p0) {
      setState(() {
        mPage = 1;
        mIsLastPage = false;
      });
      init();
    });
  }

  Future<void> init({bool showLoader = false}) async {
    appStore.setLoading(showLoader);
    futureMember = await getMemberDetail(userId: userStore.loginUserId.toInt()).then((value) async {
      _memberDetails = value;
      _userPostList.clear();
      hasInfo = _memberDetails!.profileInfo.validate().any(
            (element) => element.fields.validate().any(
                  (el) => el.value.validate().isNotEmpty,
                ),
          );

      _userPostList.addAll(value.postList.validate());
      appStore.setLoading(false);
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
    getPostList(page: mPage, showLoader: true);
  }

  Future<void> getPostList({bool showLoader = false, int page = 1}) async {
    appStore.setLoadingDots(showLoader);
    if (page == 1) appStore.setLoading(showLoader);
    await getPost(
      type: isFavorites ? PostRequestType.favorites : PostRequestType.timeline,
      page: page,
      userId: userStore.loginUserId.toInt(),
      postList: _userPostList,
      lastPageCallback: (p0) {
        setState(() {
          mIsLastPage = p0;
        });
      },
    ).then((value) {
      appStore.setLoadingDots(false);
      appStore.setLoading(false);
      setState(() {});
    }).catchError((e) {
      appStore.setLoadingDots(false);
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    LiveStream().dispose(OnAddPostProfile);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        return init(showLoader: true);
      },
      child: Stack(
        children: [
          FutureBuilder(
            future: futureMember,
            builder: (context, snapshot) {
              if (snapshot.hasError)
                return SizedBox(
                  height: context.height() * 0.5,
                  width: context.width() - 32,
                  child: NoDataWidget(
                    imageWidget: NoDataLottieWidget(),
                    title: jsonEncode(snapshot.error),
                    onRetry: () {
                      LiveStream().emit(OnAddPost);
                    },
                    retryText: '   ${language.clickToRefresh}   ',
                  ),
                ).center();
              else if (_memberDetails == null && !appStore.isLoading)
                return SizedBox(
                  height: context.height() * 0.8,
                  child: NoDataWidget(
                    imageWidget: NoDataLottieWidget(),
                    title: language.noDataFound,
                    onRetry: () {
                      LiveStream().emit(RefreshNotifications);
                    },
                    retryText: '   ${language.clickToRefresh}   ',
                  ).center(),
                );
              return AnimatedScrollView(
                listAnimationType: ListAnimationType.None,
                padding: EdgeInsets.only(bottom: 30),
                onNextPage: () {
                  if (!mIsLastPage) {
                    mPage++;
                    getPostList(page: mPage);
                  }
                },
                children: [
                  Observer(
                    builder: (context) {
                      return Column(
                        children: [
                          ProfileHeaderComponent(avatarUrl: userStore.loginAvatarUrl, cover: _memberDetails!.memberCoverImage.validate()),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Observer(builder: (context) {
                                return RichText(
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(
                                    text: userStore.loginFullName,
                                    style: boldTextStyle(size: 20),
                                    children: [
                                      if (_memberDetails!.isUserVerified.validate())
                                        WidgetSpan(
                                          child: Image.asset(ic_tick_filled, width: 20, height: 20, color: blueTickColor).paddingSymmetric(horizontal: 4),
                                        ),
                                    ],
                                  ),
                                );
                              }),
                              4.height,
                              TextIcon(
                                edgeInsets: EdgeInsets.zero,
                                spacing: 0,
                                onTap: () {
                                  PersonalInfoScreen(profileInfo: _memberDetails!.profileInfo.validate(), hasUserInfo: hasInfo).launch(context);
                                },
                                text: userStore.loginName,
                                textStyle: secondaryTextStyle(),
                                suffix: SizedBox(
                                  height: 26,
                                  width: 26,
                                  child: IconButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      PersonalInfoScreen(profileInfo: _memberDetails!.profileInfo.validate(), hasUserInfo: hasInfo).launch(context);
                                    },
                                    icon: Icon(Icons.info_outline_rounded),
                                    iconSize: 18,
                                    splashRadius: 1,
                                  ),
                                ),
                              ),
                            ],
                          ).paddingAll(16),
                          Row(
                            children: [
                              if (appStore.displayPostCount)
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(_memberDetails!.postCount.toString(), style: boldTextStyle(size: 18)),
                                    4.height,
                                    Text(language.posts, style: secondaryTextStyle(size: 12)),
                                  ],
                                ).paddingSymmetric(vertical: 8).onTap(() {
                                  widget.controller?.animateTo(context.height() * 0.35, duration: const Duration(milliseconds: 500), curve: Curves.linear);
                                }, splashColor: Colors.transparent, highlightColor: Colors.transparent).expand(),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(_memberDetails!.friendsCount.validate().toString(), style: boldTextStyle(size: 18)),
                                  4.height,
                                  Text(language.friends, style: secondaryTextStyle(size: 12)),
                                ],
                              ).paddingSymmetric(vertical: 8).onTap(() {
                                ProfileFriendsScreen().launch(context).then((value) {
                                  if (value ?? false) init();
                                });
                              }, splashColor: Colors.transparent, highlightColor: Colors.transparent).expand(),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(_memberDetails!.groupsCount.validate().toString(), style: boldTextStyle(size: 18)),
                                  4.height,
                                  Text(language.groups, style: secondaryTextStyle(size: 12)),
                                ],
                              ).paddingSymmetric(vertical: 8).onTap(() {
                                if (pmpStore.viewGroups) {
                                  GroupScreen(type: GroupRequestType.userGroup).launch(context).then((value) {
                                    if (value ?? false) init();
                                  });
                                } else {
                                  MembershipPlansScreen().launch(context);
                                }
                              }, splashColor: Colors.transparent, highlightColor: Colors.transparent).expand(),
                            ],
                          ),
                          if (appStore.showStoryHighlight) 16.height,
                          if (appStore.showStoryHighlight)
                            StoryHighlightsComponent(
                              avatarImage: _memberDetails!.memberAvatarImage.validate(),
                              highlightsList: _memberDetails!.highlightStory.validate(),
                            ),
                          if (appStore.showStoryHighlight) 16.height,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              TextIcon(
                                onTap: () {
                                  GalleryScreen(userId: userStore.loginUserId.toInt(), canEdit: true).launch(context);
                                },
                                text: language.viewGallery,
                                textStyle: primaryTextStyle(color: appColorPrimary),
                                prefix: Image.asset(ic_image, width: 18, height: 18, color: appColorPrimary),
                              ),
                              if (appStore.showGamiPress)
                                TextIcon(
                                  onTap: () {
                                    RewardsScreen(userID: userStore.loginUserId.toInt()).launch(context);
                                  },
                                  text: language.viewRewards,
                                  textStyle: primaryTextStyle(color: appColorPrimary),
                                  prefix: Image.asset(ic_star, width: 18, height: 18, color: appColorPrimary),
                                ),
                            ],
                          ).paddingSymmetric(vertical: 12),
                        ],
                      );
                    },
                  ),
                  if (_memberDetails != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(language.posts, style: boldTextStyle(color: context.primaryColor, size: 20)),
                        TextIcon(
                          onTap: () {
                            isFavorites = !isFavorites;
                            mPage = 1;
                            setState(() {});
                            getPostList(showLoader: true);
                          },
                          prefix: Icon(isFavorites ? Icons.check_circle : Icons.circle_outlined, color: appColorPrimary, size: 18),
                          text: language.favorites,
                          textStyle: secondaryTextStyle(color: isFavorites ? context.primaryColor : null),
                        ),
                      ],
                    ).paddingSymmetric(horizontal: 8, vertical: 8),
                  if (_memberDetails != null) ...[
                    _userPostList.isEmpty
                        ? NoDataWidget(
                            imageWidget: NoDataLottieWidget(),
                            title: language.noDataFound,
                            retryText: '   ${language.clickToRefresh}   ',
                          ).center().paddingBottom(20)
                        : Stack(
                            children: [
                              AnimatedWrap(
                                spacing: 16,
                                listAnimationType: ListAnimationType.None,
                                itemCount: _userPostList.length,
                                slideConfiguration: SlideConfiguration(delay: 80.milliseconds, verticalOffset: 300),
                                itemBuilder: (context, index) {
                                  return PostComponent(
                                    fromProfile: true,
                                    post: _userPostList[index],
                                    callback: () {
                                      isLoading = true;
                                      init();
                                    },
                                    commentCallback: () {
                                      getPostList(showLoader: false);
                                    },
                                    fromFavourites: isFavorites,
                                  );
                                },
                              ),
                              if (appStore.isLoadingDots)
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  left: 0,
                                  child: ThreeBounceLoadingWidget(),
                                )
                            ],
                          )
                  ]
                ],
              ).visible(_memberDetails != null);
            },
          ),
          Observer(
            builder: (_) => LoadingWidget(isBlurBackground: false).center().paddingTop(context.height() * 0.4).visible(mPage == 1 && appStore.isLoading),
          ),
        ],
      ),
    );
  }
}
