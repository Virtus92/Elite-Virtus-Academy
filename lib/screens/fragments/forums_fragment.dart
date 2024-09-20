import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/components/no_data_lottie_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/forums/forum_model.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/screens/forums/components/forums_card_component.dart';
import 'package:socialv/screens/forums/screens/forum_detail_screen.dart';

import '../../../utils/app_constants.dart';

class ForumsFragment extends StatefulWidget {
  final ScrollController controller;

  const ForumsFragment({super.key, required this.controller});

  @override
  State<ForumsFragment> createState() => _ForumsFragment();
}

class _ForumsFragment extends State<ForumsFragment> {
  List<ForumModel> forumsList = [];
  Future<List<ForumModel>>? future;

  TextEditingController searchController = TextEditingController();

  int mPage = 1;
  bool mIsLastPage = false;
  bool hasShowClearTextIcon = false;

  @override
  void initState() {
    super.initState();
    init();

    widget.controller.addListener(() {
      /// pagination
      if (appStore.currentDashboardIndex == 2) {
        if (widget.controller.position.pixels == widget.controller.position.maxScrollExtent) {
          if (!mIsLastPage) {
            onNextPage();
          }
        }
      }
    });

    searchController.addListener(() {
      if (searchController.text.isNotEmpty) {
        showClearTextIcon();
      } else {
        hasShowClearTextIcon = false;
        setState(() {});
      }
    });

    LiveStream().on(RefreshForumsFragment, (p0) {
      setState(() {
        mPage = 1;
        mIsLastPage = false;
      });
      init();
    });
  }

  void showClearTextIcon() {
    if (!hasShowClearTextIcon) {
      hasShowClearTextIcon = true;
      setState(() {});
    } else {
      return;
    }
  }

  Future<void> init({bool showLoader = true, int page = 1}) async {
    appStore.setLoading(showLoader);
    future = await getForumList(
      page: page,
      keyword: searchController.text,
      forumsList: forumsList,
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

  Future<void> onNextPage() async {
    mPage++;
    setState(() {});
    init(page: mPage);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    searchController.dispose();
    LiveStream().dispose(RefreshForumsFragment);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      key: UniqueKey(),
      children: [
        FutureBuilder(
          future: future,
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
            else if (forumsList.isEmpty && !appStore.isLoading)
              return SizedBox(
                height: context.height() * 0.7,
                child: NoDataWidget(
                  imageWidget: NoDataLottieWidget(),
                  title: searchController.text.isEmpty ? 'No Forums available' : "Can't find ${searchController.text} in Forums",
                  onRetry: () {
                    LiveStream().emit(RefreshForumsFragment);
                  },
                  retryText: '   ${language.clickToRefresh}   ',
                ).center(),
              );

            return Column(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 16, top: 16),
                  decoration: BoxDecoration(color: context.cardColor, borderRadius: radius(commonRadius)),
                  child: AppTextField(
                    controller: searchController,
                    textFieldType: TextFieldType.USERNAME,
                    onFieldSubmitted: (text) {
                      init(page: 1);
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: language.searchHere,
                      hintStyle: secondaryTextStyle(),
                      prefixIcon: Image.asset(
                        ic_search,
                        height: 16,
                        width: 16,
                        fit: BoxFit.cover,
                        color: appStore.isDarkMode ? bodyDark : bodyWhite,
                      ).paddingAll(16),
                      suffixIcon: hasShowClearTextIcon
                          ? IconButton(
                              icon: Icon(Icons.cancel, color: appStore.isDarkMode ? bodyDark : bodyWhite, size: 18),
                              onPressed: () {
                                hideKeyboard(context);
                                hasShowClearTextIcon = false;
                                searchController.clear();
                                setState(() {});
                                init();
                              },
                            )
                          : null,
                    ),
                  ),
                ),
                ...forumsList.map((data) {
                  return InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      ForumDetailScreen(
                        type: data.type.validate(),
                        forumId: data.id.validate(),
                        forumTitle: data.title.validate(),
                      ).launch(context).then((value) {
                        if (value ?? false) {
                          init();
                        }
                      });
                    },
                    child: ForumsCardComponent(
                      title: data.title,
                      description: data.description,
                      postCount: data.postCount,
                      topicCount: data.topicCount,
                      freshness: data.freshness,
                    ),
                  );
                }).toList(),
              ],
            ).paddingBottom(120);
          },
        ),
        Observer(
          builder: (_) {
            if (appStore.isLoading) {
              if (mPage > 1) {
                return Positioned(
                  bottom: 32,
                  child: LoadingWidget(isBlurBackground: false).center(),
                  left: 16,
                  right: 16,
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
