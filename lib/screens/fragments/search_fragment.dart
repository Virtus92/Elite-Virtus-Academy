import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/activity_response.dart';
import 'package:socialv/models/groups/group_response.dart';
import 'package:socialv/models/members/member_response.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/screens/membership/screens/membership_plans_screen.dart';
import 'package:socialv/screens/search/components/search_group_component.dart';
import 'package:socialv/screens/search/components/search_member_component.dart';
import 'package:socialv/screens/search/components/search_post_component.dart';

import '../../components/no_data_lottie_widget.dart';
import '../../utils/app_constants.dart';

class SearchFragment extends StatefulWidget {
  final ScrollController controller;

  const SearchFragment({required this.controller});

  @override
  State<SearchFragment> createState() => _SearchFragmentState();
}

class _SearchFragmentState extends State<SearchFragment> with SingleTickerProviderStateMixin {
  List<MemberResponse> memberList = [];
  List<GroupResponse> groupList = [];
  List<ActivityResponse> postList = [];

  List<String> searchOptions = [language.members, language.groups, language.posts];

  TextEditingController searchController = TextEditingController();

  String dropdownValue = '';

  int mPage = 1;
  bool mIsLastPage = false;

  bool hasShowClearTextIcon = false;

  @override
  void initState() {
    super.initState();

    if (pmpStore.memberDirectory) {
      dropdownValue = searchOptions.first;
    } else if (pmpStore.viewGroups) {
      dropdownValue = searchOptions[1];
    } else {
      dropdownValue = searchOptions[2];
    }

    widget.controller.addListener(() {
      if (widget.controller.position.pixels == widget.controller.position.maxScrollExtent) {
        if (!mIsLastPage) {
          setState(() {
            mPage++;
          });
          configureSearch(showLoader: true, page: mPage);
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
  }

  Future<void> configureSearch({bool showLoader = true, int page = 1, String type = ''}) async {
    if (searchController.text.isNotEmpty) {
      if (dropdownValue == searchOptions.first) {
        getMembersList(page: page, showLoader: showLoader, type: type);
      } else if (dropdownValue == searchOptions[1]) {
        getGroups(page: page, showLoader: showLoader);
      } else {
        getPosts(page: page, showLoader: showLoader);
      }
    }
  }

  Future<void> getMembersList({bool showLoader = true, int page = 1, String type = ''}) async {
    appStore.setLoading(true);
    await getAllMembers(
      searchText: searchController.text,
      page: page,
      memberList: memberList,
      type: type,
      lastPageCallback: (p0) {
        setState(() {
          mIsLastPage = p0;
        });
      },
    ).then((value) {
      appStore.setLoading(false);

      setState(() {});
    }).catchError((e) {
      toast(e.toString());
      appStore.setLoading(false);
    });
  }

  Future<void> getGroups({bool showLoader = true, int page = 1}) async {
    appStore.setLoading(true);
    await getBuddyPressGroupList(
      searchText: searchController.text,
      groupList: groupList,
      page: page,
      lastPageCallback: (p0) {
        setState(() {
          mIsLastPage = p0;
        });
      },
    ).then((value) {
      appStore.setLoading(false);

      setState(() {});
    }).catchError((e) {
      toast(e.toString());
      appStore.setLoading(false);
    });
  }

  Future<void> getPosts({bool showLoader = true, int page = 1}) async {
    appStore.setLoading(true);
    await searchPost(searchText: searchController.text, page: page).then((value) {
      if (mPage == 1) postList.clear();
      mIsLastPage = value.length != PER_PAGE;
      postList.addAll(value);

      appStore.setLoading(false);

      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
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

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Widget buildEmptyWidget() {
    if (searchController.text.isEmpty) return Offstage();
    return SizedBox(
      height: context.height() * 0.3,
      child: NoDataWidget(
        imageWidget: NoDataLottieWidget(),
        title: dropdownValue == searchOptions.first
            ? "Can't find @${searchController.text}"
            : dropdownValue == searchOptions[1]
                ? "Can't find Group you're trying to search for..."
                : "Can't find Post you're trying to search for...",
      ),
    ).visible(((dropdownValue == searchOptions.first && memberList.isEmpty) || (dropdownValue == searchOptions[1] && groupList.isEmpty) || (dropdownValue == searchOptions.last && postList.isEmpty)) && !appStore.isLoading);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        AnimatedScrollView(
          listAnimationType: ListAnimationType.None,
          onNextPage: () {
            if (!mIsLastPage) {
              setState(() {
                mPage++;
              });
              configureSearch(showLoader: true, page: mPage);
            }
          },
          children: [
            Row(
              children: [
                Container(
                  width: context.width() * 0.54,
                  margin: EdgeInsets.only(left: 16, right: 8),
                  decoration: BoxDecoration(color: context.cardColor, borderRadius: radius(commonRadius)),
                  child: AppTextField(
                    controller: searchController,
                    onChanged: (val) {
                      configureSearch();
                    },
                    textFieldType: TextFieldType.USERNAME,
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
                                mPage = 1;
                                searchController.clear();
                                hasShowClearTextIcon = false;
                                memberList.clear();
                                groupList.clear();
                                postList.clear();
                                setState(() {});
                                configureSearch();
                              },
                            )
                          : null,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    width: context.width() * 0.32,
                    margin: EdgeInsets.only(right: 16, left: 8),
                    decoration: BoxDecoration(color: context.cardColor, borderRadius: radius(commonRadius)),
                    child: DropdownButtonHideUnderline(
                      child: ButtonTheme(
                        alignedDropdown: true,
                        child: DropdownButton<String>(
                          borderRadius: BorderRadius.circular(commonRadius),
                          icon: Icon(Icons.arrow_drop_down, color: appStore.isDarkMode ? bodyDark : bodyWhite),
                          elevation: 8,
                          isExpanded: true,
                          style: primaryTextStyle(),
                          onChanged: (String? newValue) {
                            mPage = 1;

                            if ((newValue == searchOptions.first && pmpStore.memberDirectory) || (newValue == searchOptions[1] && pmpStore.viewGroups) || newValue == searchOptions.last) {
                              dropdownValue = newValue.validate();
                              setState(() {});
                              configureSearch();
                            } else {
                              MembershipPlansScreen().launch(context);
                            }
                          },
                          items: searchOptions.validate().map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value, style: primaryTextStyle(), overflow: TextOverflow.ellipsis),
                            );
                          }).toList(),
                          value: dropdownValue,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ).paddingSymmetric(vertical: 16),
            if (dropdownValue == searchOptions.first)
              SearchMemberComponent(
                memberList: memberList,
                showRecent: appStore.recentMemberSearchList.isNotEmpty,
                callback: () {
                  setState(() {});
                },
              )
            else if (dropdownValue == searchOptions[1])
              SearchGroupComponent(
                showRecent: appStore.recentGroupsSearchList.isNotEmpty,
                groupList: groupList,
                callback: () {
                  setState(() {});
                },
              )
            else
              SearchPostComponent(
                postList: postList,
              ),
            buildEmptyWidget()
          ],
        ),
        Observer(
          builder: (_) {
            if (appStore.isLoading) {
              if (mPage > 1) {
                return Positioned(
                  bottom: 10,
                  child: ThreeBounceLoadingWidget(),
                );
              } else {
                return LoadingWidget(isBlurBackground: false).paddingTop(context.height() * 0.3);
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
