import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/common_models.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/screens/profile/screens/edit_profile_screen.dart';
import 'package:socialv/screens/profile/screens/member_profile_screen.dart';
import 'package:socialv/utils/app_constants.dart';
import 'package:socialv/utils/cached_network_image.dart';

class UserDetailBottomSheetWidget extends StatefulWidget {
  final VoidCallback? callback;

  UserDetailBottomSheetWidget({this.callback});

  @override
  State<UserDetailBottomSheetWidget> createState() => _UserDetailBottomSheetWidgetState();
}

class _UserDetailBottomSheetWidgetState extends State<UserDetailBottomSheetWidget> {
  List<DrawerModel> options = getDrawerOptions();

  int selectedIndex = -1;
  bool isLoading = false;
  bool backToHome = true;

  @override
  void initState() {
    super.initState();
    if (appStore.isLoading) {
      isLoading = true;
      appStore.setLoading(false);
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    if (isLoading && backToHome) widget.callback?.call();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(bottom: context.height() / 2),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        cachedImage(userStore.loginAvatarUrl, height: 62, width: 62, fit: BoxFit.cover).cornerRadiusWithClipRRect(100),
                        16.width,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(userStore.loginFullName, style: boldTextStyle(size: 18)),
                            8.height,
                            Text(userStore.loginEmail, style: secondaryTextStyle(), overflow: TextOverflow.ellipsis, maxLines: 1),
                          ],
                        ),
                      ],
                    ).onTap(() {
                      finish(context);
                      MemberProfileScreen(memberId: userStore.loginUserId.validate().toInt()).launch(context);
                    }, highlightColor: Colors.transparent, splashColor: Colors.transparent),
                    IconButton(
                      icon: Image.asset(ic_edit, height: 16, width: 16, fit: BoxFit.cover, color: context.iconColor),
                      onPressed: () {
                        finish(context);
                        EditProfileScreen().launch(context);
                      },
                    ),
                  ],
                ).paddingOnly(left: 16, right: 8, bottom: 16, top: 16),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(options.length, (index) {
                    DrawerModel e = options.validate()[index];
                    return SettingItemWidget(
                      decoration: BoxDecoration(color: selectedIndex == index ? context.primaryColor.withAlpha(30) : context.cardColor),
                      title: e.title.validate(),
                      titleTextStyle: boldTextStyle(size: 14),
                      leading: Image.asset(e.image.validate(), height: 22, width: 22, fit: BoxFit.fill, color: appColorPrimary),
                      trailing: e.isNew
                          ? Container(
                              decoration: BoxDecoration(color: appGreenColor.withAlpha(30), borderRadius: radius()),
                              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                              child: Text(language.lblNew, style: boldTextStyle(color: appGreenColor, size: 12)),
                            )
                          : Offstage(),
                      onTap: () async {
                        selectedIndex = index;
                        setState(() {});

                        if (e.attachedScreen != null) {
                          backToHome = false;
                          finish(context);
                          e.attachedScreen.launch(context);
                        } else {
                          finish(context);
                        }
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              width: context.width(),
              color: context.scaffoldBackgroundColor,
              padding: EdgeInsets.only(top: 16, bottom: 24),
              child: Column(
                children: [
                  VersionInfoWidget(prefixText: 'v'),
                  8.height,
                  Text(language.logout, style: boldTextStyle(color: context.primaryColor)),
                ],
              ),
            ).onTap(
              () {
                showConfirmDialogCustom(
                  context,
                  primaryColor: appColorPrimary,
                  title: language.logoutConfirmation,
                  onAccept: (s) {
                    logout(context);
                  },
                );
              },
              borderRadius: radius(),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
          ),
          LoadingWidget().center().visible(appStore.isLoading)
        ],
      ),
    );
  }
}
