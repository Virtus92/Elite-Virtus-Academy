import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/components/no_data_lottie_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/members/member_detail_model.dart';
import 'package:socialv/models/posts/post_model.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/screens/blockReport/components/block_member_dialog.dart';
import 'package:socialv/screens/blockReport/components/show_report_dialog.dart';
import 'package:socialv/screens/gamipress/screens/rewards_screen.dart';
import 'package:socialv/screens/groups/screens/group_screen.dart';
import 'package:socialv/screens/membership/screens/membership_plans_screen.dart';
import 'package:socialv/screens/post/components/post_component.dart';
import 'package:socialv/screens/profile/components/profile_header_component.dart';
import 'package:socialv/screens/profile/components/request_follow_widget.dart';
import 'package:socialv/screens/profile/screens/member_friends_screen.dart';
import 'package:socialv/screens/profile/screens/personal_info_screen.dart';
import 'package:socialv/screens/settings/screens/settings_screen.dart';
import 'package:socialv/screens/stories/component/story_highlights_component.dart';

import '../../../utils/app_constants.dart';
import '../../gallery/screens/gallery_screen.dart';

class MemberProfileScreen extends StatefulWidget {
  final int memberId;

  MemberProfileScreen({required this.memberId});

  @override
  State<MemberProfileScreen> createState() => _MemberProfileScreenState();
}

class _MemberProfileScreenState extends State<MemberProfileScreen> {
  ScrollController _scrollController = ScrollController();
  Future<MemberDetailModel>? futureMember;
  Future<List<PostModel>>? futurePostList;
  MemberDetailModel? member;

  List<PostModel> postList = [];

  int mPage = 1;
  bool isCallback = false;
  bool showDetails = false;
  bool mIsLastPage = false;
  bool hasInfo = false;
  bool isFavorites = false;

  @override
  void initState() {
    init(showLoader: true);
    setStatusBarColor(Colors.transparent);
    super.initState();
  }

  void init({bool showLoader = false}) async {
    appStore.setLoading(showLoader);
    futureMember = await getMemberDetail(userId: widget.memberId).then((value) async {
      setState(() {
        member = value;
      });

      hasInfo = member!.profileInfo.validate().any((element) => element.fields.validate().any(
            (el) => el.value.validate().isNotEmpty,
          ));

      showDetails = widget.memberId.toInt() == userStore.loginUserId.toInt();

      if (!showDetails) {
        if (member!.accountType.validate() == AccountType.private) {
          showDetails = !(member!.blockedByMe.validate() || member!.blockedBy.validate());
          if (showDetails) {
            showDetails = (member!.friendshipStatus.validate() == Friendship.isFriend || member!.friendshipStatus.validate() == Friendship.currentUser);
          }
        } else {
          showDetails = !(member!.blockedByMe.validate() || member!.blockedBy.validate());
        }
      }
      appStore.setLoading(false);
      postList.addAll(member!.postList.validate());
      mIsLastPage = member!.postList.validate().length != PER_PAGE;
      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
    ;
  }

  Future<void> getPostList({bool showLoader = true, int page = 1}) async {
    appStore.setLoading(showLoader);
    futurePostList = await getPost(
      type: isFavorites ? PostRequestType.favorites : PostRequestType.timeline,
      page: page,
      postList: postList,
      userId: widget.memberId,
      lastPageCallback: (p0) {
        mIsLastPage = p0;
        setState(() {});
      },
    ).then((value) {
      appStore.setLoading(false);
      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
  }

  Future<void> onRefresh() async {
    setState(() {
      mPage = 1;
    });
    init();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        appStore.setLoading(false);

        finish(context, isCallback);
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(language.profile, style: boldTextStyle(size: 20)),
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: context.iconColor),
            onPressed: () {
              finish(context);
            },
          ),
          actions: [
            if (!appStore.isLoading && showDetails && widget.memberId.toString() != userStore.loginUserId && member != null)
              Theme(
                data: Theme.of(context).copyWith(),
                child: PopupMenuButton(
                  enabled: !appStore.isLoading,
                  position: PopupMenuPosition.under,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(commonRadius)),
                  onSelected: (val) async {
                    if (val == 1) {
                      PersonalInfoScreen(profileInfo: member!.profileInfo.validate(), hasUserInfo: hasInfo).launch(context);
                    } else if (val == 2) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return BlockMemberDialog(
                            mentionName: member!.mentionName.validate(),
                            id: member!.id.validate().toInt(),
                            callback: () {
                              init(showLoader: true);
                            },
                          );
                        },
                      ).then((value) {});
                    } else {
                      await showModalBottomSheet(
                        context: context,
                        elevation: 0,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) {
                          return FractionallySizedBox(
                            heightFactor: 0.80,
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
                                  decoration: BoxDecoration(
                                    color: context.cardColor,
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                                  ),
                                  child: ShowReportDialog(isPostReport: false, userId: widget.memberId),
                                ).expand(),
                              ],
                            ),
                          );
                        },
                      );
                    }
                  },
                  icon: Icon(Icons.more_horiz),
                  itemBuilder: (context) => <PopupMenuEntry>[
                    PopupMenuItem(
                      value: 1,
                      child: Row(
                        children: [
                          Icon(Icons.info_outline_rounded, color: context.iconColor, size: 20),
                          8.width,
                          Text(language.about, style: primaryTextStyle()),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 2,
                      child: Row(
                        children: [
                          Icon(Icons.block, color: context.iconColor, size: 20),
                          8.width,
                          Text(language.block, style: primaryTextStyle()),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 3,
                      child: Row(
                        children: [
                          Icon(Icons.report_gmailerrorred, color: context.iconColor, size: 20),
                          8.width,
                          Text(language.report, style: primaryTextStyle()),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            IconButton(
              onPressed: () {
                SettingsScreen().launch(context).then((value) {
                  if (value ?? false) init(showLoader: true);
                });
              },
              icon: Image.asset(
                ic_setting,
                height: 20,
                width: 20,
                fit: BoxFit.cover,
                color: context.primaryColor,
              ),
            ).visible(widget.memberId.toString() == userStore.loginUserId),
          ],
        ),
        body: Stack(
          children: [
            AnimatedScrollView(
              listAnimationType: ListAnimationType.None,
              padding: EdgeInsets.only(bottom: mIsLastPage ? context.height() / 2 : 50),
              controller: _scrollController,
              physics: AlwaysScrollableScrollPhysics(),
              onSwipeRefresh: onRefresh,
              onNextPage: () {
                if (!mIsLastPage) {
                  setState(() {
                    mPage++;
                  });
                  getPostList(showLoader: true, page: mPage);
                }
              },
              children: [
                FutureBuilder(
                  future: futureMember,
                  builder: (context, snapshot) {
                    if (snapshot.hasError)
                      return SizedBox(
                        height: context.height() * 0.4,
                        child: NoDataWidget(
                          imageWidget: NoDataLottieWidget(),
                          title: jsonEncode(snapshot.error),
                          onRetry: () {
                            LiveStream().emit(OnAddPost);
                          },
                          retryText: '   ${language.clickToRefresh}   ',
                        ).center(),
                      );
                    else if (member != null) {
                      return Column(
                        children: [
                          ProfileHeaderComponent(
                            avatarUrl: member!.blockedBy.validate() ? AppImages.defaultAvatarUrl : member!.memberAvatarImage.validate(),
                            cover: member!.blockedBy.validate() ? null : member!.memberCoverImage.validate(),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    member!.blockedBy.validate() ? language.userNotFound : member!.name.validate(),
                                    style: boldTextStyle(size: 20),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ).flexible(flex: 1),
                                  if (member!.isUserVerified.validate() && !member!.blockedBy.validate()) Image.asset(ic_tick_filled, width: 18, height: 18, color: blueTickColor).paddingSymmetric(horizontal: 4),
                                ],
                              ),
                              4.height,
                              if (!member!.blockedBy.validate()) Text(member!.mentionName.validate(), style: secondaryTextStyle()),
                            ],
                          ).paddingSymmetric(vertical: 8),
                          if (!appStore.isLoading && !member!.blockedBy.validate() && widget.memberId.toString() != userStore.loginUserId)
                            RequestFollowWidget(
                              userMentionName: member!.mentionName.validate(),
                              userName: member!.name.validate(),
                              memberId: member!.id.validate().toInt(),
                              friendshipStatus: member!.friendshipStatus.validate(),
                              callback: () {
                                isCallback = true;
                                init();
                              },
                              isBlockedByMe: member!.blockedByMe.validate(),
                            ).paddingSymmetric(vertical: 6),
                          Row(
                            children: [
                              if (appStore.displayPostCount == 1)
                                Column(
                                  children: [
                                    Text(member!.postCount.validate().toString(), style: boldTextStyle(size: 18)),
                                    4.height,
                                    Text(language.posts, style: secondaryTextStyle(size: 12)),
                                  ],
                                ).onTap(
                                  () {
                                    _scrollController.animateTo(context.height() * 0.35, duration: const Duration(milliseconds: 500), curve: Curves.linear);
                                  },
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                ).expand(),
                              Column(
                                children: [
                                  Text(member!.friendsCount.validate().toString(), style: boldTextStyle(size: 18)),
                                  4.height,
                                  Text(language.friends, style: secondaryTextStyle(size: 12)),
                                ],
                              ).onTap(() {
                                if (showDetails) {
                                  if (pmpStore.memberDirectory) {
                                    log(member!.id.toInt());
                                    MemberFriendsScreen(memberId: member!.id.toInt()).launch(context);
                                  } else {
                                    MembershipPlansScreen().launch(context);
                                  }
                                } else {
                                  toast(language.canNotViewFriends);
                                }
                              }, splashColor: Colors.transparent, highlightColor: Colors.transparent).expand(),
                              Column(
                                children: [
                                  Text(member!.groupsCount.validate().toString(), style: boldTextStyle(size: 18)),
                                  4.height,
                                  Text(language.groups, style: secondaryTextStyle(size: 12)),
                                ],
                              ).onTap(() {
                                if (showDetails) {
                                  if (pmpStore.viewGroups) {
                                    GroupScreen(userId: member!.id.validate().toInt(), type: GroupRequestType.userGroup).launch(context);
                                  } else {
                                    MembershipPlansScreen().launch(context);
                                  }
                                } else {
                                  toast(language.canNotViewGroups);
                                }
                              }, splashColor: Colors.transparent, highlightColor: Colors.transparent).expand(),
                            ],
                          ).paddingSymmetric(vertical: 16),
                          8.height,
                          if (showDetails && appStore.showStoryHighlight)
                            StoryHighlightsComponent(
                              showAddOption: member!.id.validate() == userStore.loginUserId,
                              avatarImage: member!.memberAvatarImage.validate(),
                              highlightsList: member!.highlightStory.validate(),
                              callback: () {
                                onRefresh();
                              },
                            ),
                          if (showDetails)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                TextIcon(
                                  onTap: () {
                                    GalleryScreen(userId: member!.id.toInt(), canEdit: false).launch(context);
                                  },
                                  text: language.viewGallery,
                                  textStyle: primaryTextStyle(color: appColorPrimary),
                                  prefix: Image.asset(ic_image, width: 18, height: 18, color: appColorPrimary),
                                ),
                                if (appStore.showGamiPress)
                                  TextIcon(
                                    onTap: () {
                                      RewardsScreen(userID: member!.id.toInt()).launch(context);
                                    },
                                    text: language.viewRewards,
                                    textStyle: primaryTextStyle(color: appColorPrimary),
                                    prefix: Image.asset(ic_star, width: 18, height: 18, color: appColorPrimary),
                                  ),
                              ],
                            ).paddingTop(16),
                          if (showDetails) ...[
                            postList.isEmpty
                                ? SizedBox(
                                    height: context.height() * 0.4,
                                    child: NoDataWidget(
                                      imageWidget: NoDataLottieWidget(),
                                      title: language.noDataFound,
                                      onRetry: () {
                                        getPostList();
                                      },
                                      retryText: '   ${language.clickToRefresh}   ',
                                    ),
                                  ).center()
                                : Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(language.posts, style: boldTextStyle(color: appColorPrimary)).paddingSymmetric(horizontal: 16),
                                          TextIcon(
                                            onTap: () {
                                              isFavorites = !isFavorites;
                                              mPage = 1;
                                              setState(() {});
                                              getPostList();
                                            },
                                            prefix: Icon(isFavorites ? Icons.check_circle : Icons.circle_outlined, color: appColorPrimary, size: 18),
                                            text: language.favorites,
                                            textStyle: secondaryTextStyle(color: isFavorites ? context.primaryColor : null),
                                          ).paddingSymmetric(horizontal: 8),
                                        ],
                                      ).visible(member!.postCount.validate() != 0).paddingSymmetric(vertical: 8),
                                      AnimatedListView(
                                        itemCount: postList.length,
                                        slideConfiguration: SlideConfiguration(delay: 80.milliseconds, verticalOffset: 300),
                                        itemBuilder: (context, index) {
                                          return PostComponent(
                                            fromProfile: true,
                                            post: postList[index],
                                            callback: () {
                                              onRefresh();
                                            },
                                            commentCallback: () {
                                              mPage = 1;
                                              getPostList();
                                            },
                                            fromFavourites: widget.memberId.toString() == userStore.loginUserId && isFavorites,
                                          ).paddingSymmetric(horizontal: 8);
                                        },
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                      ),
                                    ],
                                  ).paddingSymmetric(vertical: 16)
                          ],
                          16.height,
                          if (member!.accountType == AccountType.private && !showDetails)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(border: Border.all(), shape: BoxShape.circle),
                                  padding: EdgeInsets.all(8),
                                  child: Image.asset(ic_lock, height: 24, width: 24, color: context.iconColor),
                                ),
                                16.height,
                                Text(language.thisAccountIsPrivate, style: boldTextStyle()),
                                Text(
                                  language.followThisAccountText,
                                  style: secondaryTextStyle(),
                                  textAlign: TextAlign.center,
                                ).paddingSymmetric(horizontal: 16),
                              ],
                            ),
                        ],
                      );
                    } else
                      return NoDataWidget(
                        imageWidget: NoDataLottieWidget(),
                        title: language.noDataFound,
                        retryText: '   ${language.clickToRefresh}   ',
                      ).center().visible(!appStore.isLoading);
                  },
                )
              ],
            ),
            Observer(
              builder: (context) => Positioned(
                child: ThreeBounceLoadingWidget().paddingTop(16),
                bottom: 16,
                left: 0,
                right: 0,
              ).visible(appStore.isLoading && mPage > 1),
            ),
            if (appStore.isLoading && mPage == 1) LoadingWidget().center(),
          ],
        ),
      ),
    );
  }
}
