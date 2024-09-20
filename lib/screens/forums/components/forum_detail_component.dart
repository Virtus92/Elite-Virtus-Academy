import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/no_data_lottie_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/forums/forum_model.dart';
import 'package:socialv/models/forums/topic_model.dart';
import 'package:socialv/screens/forums/components/forums_card_component.dart';
import 'package:socialv/screens/forums/components/topic_card_component.dart';
import 'package:socialv/screens/forums/screens/forum_detail_screen.dart';
import 'package:socialv/screens/forums/screens/topic_detail_screen.dart';
import 'package:socialv/utils/constants.dart';

import '../../../network/rest_apis.dart';

// ignore: must_be_immutable
class ForumDetailComponent extends StatefulWidget {
  ScrollController scrollCont;
  final String type;
  final int forumId;
  final VoidCallback? callback;

  final bool showOptions;

  final int selectedIndex;

  List<TopicModel> topicList;
  List<ForumModel> forumList;

  ForumDetailComponent({
    required this.type,
    required this.scrollCont,
    this.callback,
    required this.forumId,
    this.showOptions = false,
    this.selectedIndex = 0,
    required this.topicList,
    required this.forumList,
  });

  @override
  State<ForumDetailComponent> createState() => _ForumDetailComponentState();
}

class _ForumDetailComponentState extends State<ForumDetailComponent> with SingleTickerProviderStateMixin {
  late TabController tabController;
  List<TopicModel> topicList = [];
  List<ForumModel> forumList = [];
  int mForumPage = 1;

  int mTopicPage = 1;
  int selectedIndex = 0;
  bool showOptions = true;

  bool mIsTopicLastPage = false;

  bool mIsSubForumLastPage = false;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    widget.scrollCont.addListener(() {
      if (widget.scrollCont.position.pixels == widget.scrollCont.position.maxScrollExtent) {
        onNextPage();
      }
    });
    init();
  }

  Future<void> init() async {
    showOptions = widget.showOptions;
    selectedIndex = widget.selectedIndex;
    topicList = widget.topicList;
    forumList = widget.forumList;
  }

  Future<void> onNextPage() async {
    if (selectedIndex == 0) {
      if (!mIsTopicLastPage) {
        setState(() {
          mTopicPage++;
        });
        await getForumTopicList(type: widget.type, page: mTopicPage);
      }
    }
    if (selectedIndex == 1) {
      if (!mIsSubForumLastPage) {
        setState(() {
          mForumPage++;
        });
        await getForumList(page: mForumPage);
      }
    }
  }

  Future<void> getForumTopicList({int page = 1, bool showLoader = true, String type = ''}) async {
    appStore.setLoadingDots(showLoader);
    await getTopicList(
      topicList: topicList,
      page: page,
      type: widget.type,
      forumId: widget.forumId.validate(),
      lastPageCallback: (p0) {
        mIsTopicLastPage = p0;
        setState(() {});
      },
    ).then((value) {
      appStore.setLoadingDots(false);

      setState(() {});
      return value;
    }).catchError((e) {
      appStore.setLoadingDots(false);
      toast(e.toString(), print: true);
      throw e;
    });
  }

  Future<void> getForumList({bool showLoader = true, int page = 1}) async {
    appStore.setLoadingDots(showLoader);
    await getSubForumList(
      forumId: widget.forumId.validate(),
      page: page,
      forumList: forumList,
      lastPageCallback: (p0) {
        mIsSubForumLastPage = p0;
        setState(() {});
      },
    ).then((value) async {
      appStore.setLoadingDots(false);
      forumList = forumList;
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
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: showOptions ? MainAxisAlignment.spaceEvenly : MainAxisAlignment.start,
          children: [
            Text(
              language.topics,
              style: selectedIndex == 0 ? boldTextStyle(color: context.primaryColor, size: 18) : primaryTextStyle(color: context.iconColor),
            ).paddingSymmetric(horizontal: 16).onTap(() {
              selectedIndex = 0;
              setState(() {});
            }, splashColor: Colors.transparent, highlightColor: Colors.transparent),
            Text(
              language.forums,
              style: selectedIndex == 1 ? boldTextStyle(color: context.primaryColor, size: 18) : primaryTextStyle(color: context.iconColor),
            ).paddingSymmetric(horizontal: 16).visible(showOptions).onTap(() {
              selectedIndex = 1;
              setState(() {});
            }, splashColor: Colors.transparent, highlightColor: Colors.transparent),
          ],
        ),
        Divider().visible(showOptions),
        if (selectedIndex == 0)
          if (topicList.isEmpty && !appStore.isLoading)
            NoDataWidget(
              imageWidget: NoDataLottieWidget(),
              title: language.noTopicsFound,
            )
          else
            ListView.builder(
              padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: mIsTopicLastPage ? 80 : 16),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: topicList.validate().length,
              itemBuilder: (ctx, index) {
                return InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    TopicDetailScreen(topicId: topicList.validate()[index].id.validate()).launch(context).then((value) {
                      if (value ?? false) {
                        widget.callback?.call();
                      }
                    });
                  },
                  child: TopicCardComponent(
                    topic: topicList.validate()[index],
                    isFavTab: false,
                    showForums: false,
                    callback: () {
                      init();
                    },
                  ),
                );
              },
            ),
        if (selectedIndex == 1)
          if (forumList.isEmpty)
            NoDataWidget(
              imageWidget: NoDataLottieWidget(),
              title: language.noForumsFound,
            )
          else
            ListView.builder(
              padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: mIsSubForumLastPage ? 80 : 16),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: forumList.validate().length,
              itemBuilder: (ctx, index) {
                return InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    ForumDetailScreen(
                      type: TopicType.forums,
                      forumId: forumList[index].id.validate(),
                      forumTitle: forumList[index].title.validate(),
                    ).launch(context).then((value) {
                      widget.callback?.call();
                    });
                  },
                  child: ForumsCardComponent(
                    title: forumList.validate()[index].title,
                    topicCount: forumList.validate()[index].topicCount,
                    postCount: forumList.validate()[index].postCount,
                    freshness: forumList.validate()[index].freshness,
                    description: forumList.validate()[index].description,
                  ),
                );
              },
            ),
      ],
    );
  }
}
