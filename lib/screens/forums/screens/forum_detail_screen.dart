import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/components/no_data_lottie_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/forums/forum_detail_model.dart';
import 'package:socialv/models/forums/forum_model.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/screens/forums/components/forum_detail_component.dart';
import 'package:socialv/screens/forums/screens/create_topic_screen.dart';
import 'package:socialv/screens/groups/screens/group_detail_screen.dart';
import 'package:socialv/screens/membership/screens/membership_plans_screen.dart';
import 'package:socialv/utils/app_constants.dart';
import 'package:socialv/utils/extentions/str_extentions.dart';

import '../../profile/components/profile_header_component.dart';

class ForumDetailScreen extends StatefulWidget {
  final int forumId;
  final String type;
  final String forumTitle;
  final bool isFromSubscription;

  const ForumDetailScreen({required this.forumId, required this.type, this.isFromSubscription = false, this.forumTitle = ''});

  @override
  State<ForumDetailScreen> createState() => _ForumDetailScreenState();
}

class _ForumDetailScreenState extends State<ForumDetailScreen> {
  ScrollController scrollController = ScrollController();
  Future<ForumDetailModel>? future;
  ForumModel? forumData;
  bool isSubscribed = false;

  @override
  void initState() {
    getForumDetails();
    super.initState();
  }

  Future<void> init() async {
    getForumDetails();
  }

  Future<void> getForumDetails({bool showLoader = true}) async {
    appStore.setLoading(showLoader);
    future = await getForumDetail(
      forumId: widget.forumId.validate(),
      page: 1,
      topicPerPage: PER_PAGE,
      forumsPerPage: PER_PAGE,
    ).then((value) async {
      appStore.setLoading(false);
      forumData = value;
      log('${forumData!.topicCount.toInt()}----${forumData!.topicCount.toInt() > 0 && forumData!.topicList.validate().isEmpty && forumData!.forumList.validate().isEmpty}-----------------');
      isSubscribed = value.isSubscribed.validate();
      setState(() {});
    }).catchError((e) {
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        appStore.setLoading(false);
        finish(context);
        return Future.value(true);
      },
      child: RefreshIndicator(
        onRefresh: () {
          return init();
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(forumData != null ? forumData!.title.validate() : widget.forumTitle, style: boldTextStyle(size: 20)),
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: context.iconColor),
              onPressed: () {
                finish(context);
              },
            ),
            actions: [
              Theme(
                data: Theme.of(context).copyWith(),
                child: PopupMenuButton(
                  position: PopupMenuPosition.under,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(commonRadius)),
                  onSelected: (val) async {
                    if (val == 1) {
                      ifNotTester(() {
                        isSubscribed = !isSubscribed;
                        setState(() {});
                        if (isSubscribed) {
                          toast(language.subscribedSuccessfully);
                        } else {
                          toast(language.unsubscribedSuccessfully);
                        }

                        subscribeForum(forumId: forumData != null ? forumData!.id.validate() : widget.forumId).then((value) {
                          // if (widget.isFromSubscription) isUpdate = true;
                        }).catchError((e) {
                          log(e.toString());
                        });
                      });
                    } else {
                      CreateTopicScreen(forumName: forumData != null ? forumData!.title.validate() : widget.forumTitle, forumId: forumData != null ? forumData!.id.validate() : widget.forumId).launch(context).then((value) {
                        if (value ?? false) {
                          init();
                        }
                      });
                    }
                  },
                  icon: Icon(Icons.more_horiz),
                  itemBuilder: (context) => <PopupMenuEntry>[
                    PopupMenuItem(
                      value: 1,
                      child: Text(isSubscribed ? language.unsubscribe : language.subscribe),
                      textStyle: primaryTextStyle(),
                    ),
                    if (forumData != null && (forumData!.groupDetails == null || forumData!.groupDetails!.isGroupMember.validate()))
                      PopupMenuItem(
                        value: 2,
                        child: Text(language.createTopic),
                        textStyle: primaryTextStyle(),
                      ),
                  ],
                ),
              ),
            ],
          ),
          body: Stack(
            children: [
              FutureBuilder(
                  future: future,
                  builder: (context, snapshot) {
                    if (appStore.isLoading)
                      return LoadingWidget(isBlurBackground: true).center().visible(appStore.isLoading);
                    else if (snapshot.hasError)
                      return NoDataWidget(
                        imageWidget: NoDataLottieWidget(),
                        title: snapshot.error.toString(),
                        retryText: '   ${language.clickToRefresh}   ',
                        onRetry: () {
                          init();
                        },
                      ).center();
                    return AnimatedScrollView(
                      controller: scrollController,
                      onNextPage: () {},
                      onSwipeRefresh: () {
                        return init();
                      },
                      children: [
                        ProfileHeaderComponent(
                          avatarUrl: forumData!.image.validate(),
                          cover: forumData!.groupDetails != null && forumData!.groupDetails!.coverImage.validate().isNotEmpty ? forumData!.groupDetails!.coverImage.validate() : null,
                        ),
                        16.height,
                        Text(forumData!.title.validate(), style: boldTextStyle(size: 20)).paddingSymmetric(horizontal: 16).onTap(() {
                          if (forumData!.groupDetails != null && forumData!.groupDetails!.groupId != 0) {
                            if (pmpStore.viewSingleGroup) {
                              GroupDetailScreen(groupId: forumData!.groupDetails!.groupId.validate()).launch(context).then((value) {
                                if (value ?? false) {
                                  init();
                                }
                              });
                            } else {
                              MembershipPlansScreen().launch(context);
                            }
                          }
                        }, splashColor: Colors.transparent, highlightColor: Colors.transparent).center(),
                        8.height,
                        ReadMoreText(
                          forumData!.description.validateAndFilter(),
                          trimLength: 100,
                          style: secondaryTextStyle(),
                          textAlign: TextAlign.center,
                        ).paddingSymmetric(horizontal: 16).center(),
                        16.height,
                        AppButton(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          elevation: 0,
                          color: isSubscribed ? appOrangeColor : appGreenColor,
                          child: Text(isSubscribed ? language.unsubscribe : language.subscribe, style: boldTextStyle(color: Colors.white)),
                          onTap: () {
                            ifNotTester(() {
                              isSubscribed = !isSubscribed;
                              setState(() {});

                              if (isSubscribed) {
                                toast(language.subscribedSuccessfully);
                              } else {
                                toast(language.unsubscribedSuccessfully);
                              }
                              subscribeForum(forumId: widget.forumId.validate()).then((value) {
                                //  if (widget.isFromSubscription) isUpdate = true;
                              }).catchError((e) {
                                log(e.toString());
                              });
                            });
                          },
                        ).paddingSymmetric(horizontal: 16),
                        Container(
                          margin: EdgeInsets.all(16),
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: context.primaryColor.withAlpha(30),
                            border: Border(left: BorderSide(color: context.primaryColor, width: 2)),
                          ),
                          child: Text(forumData!.lastUpdate.validate(), style: secondaryTextStyle()),
                        ),
                        if ((forumData!.groupDetails != null && forumData!.groupDetails!.isGroupMember.validate()) || forumData!.isPrivate == 0)
                          ForumDetailComponent(
                            scrollCont: scrollController,
                            type: widget.type,
                            callback: () {
                              init();
                            },
                            forumId: forumData!.id.validate(),
                            showOptions: forumData!.forumList.validate().isNotEmpty && forumData!.topicList.validate().isNotEmpty,
                            selectedIndex: forumData!.forumList.validate().isNotEmpty ? 1 : 0,
                            forumList: forumData!.forumList.validate(),
                            topicList: forumData!.topicList.validate(),
                          )
                        else if (forumData!.groupDetails != null && !forumData!.groupDetails!.isGroupMember.validate())
                          appButton(
                            context: context,
                            shapeBorder: RoundedRectangleBorder(borderRadius: radius(4)),
                            text: language.viewGroup,
                            textStyle: boldTextStyle(color: Colors.white),
                            onTap: () {
                              if (forumData!.groupDetails != null && forumData!.groupDetails!.groupId != 0) {
                                if (pmpStore.viewSingleGroup) {
                                  GroupDetailScreen(groupId: forumData!.groupDetails!.groupId.validate()).launch(context).then((value) {
                                    if (value ?? false) {
                                      init();
                                    }
                                  });
                                } else {
                                  MembershipPlansScreen().launch(context);
                                }
                              } else {
                                toast(language.canNotViewThisGroup);
                              }
                            },
                            width: context.width() - 64,
                          ).paddingSymmetric(vertical: 20).center()
                        else
                          ForumDetailComponent(
                            scrollCont: scrollController,
                            type: widget.type,
                            callback: () {
                              init();
                            },
                            forumId: widget.forumId,
                            showOptions: forumData!.forumList.validate().isNotEmpty && forumData!.topicList.validate().isNotEmpty,
                            selectedIndex: forumData!.forumList.validate().isNotEmpty ? 1 : 0,
                            forumList: forumData!.forumList.validate(),
                            topicList: forumData!.topicList.validate(),
                          ),
                      ],
                    );
                  }),
              Observer(
                builder: (context) => Positioned(
                  child: ThreeBounceLoadingWidget().visible(appStore.isLoadingDots),
                  bottom: 24,
                  left: 0,
                  right: 0,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
