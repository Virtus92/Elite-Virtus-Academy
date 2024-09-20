import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/file_picker_dialog_component.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/story/story_response_model.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/screens/stories/screen/create_story_screen.dart';
import 'package:socialv/screens/stories/screen/story_page.dart';
import 'package:socialv/utils/cached_network_image.dart';

import '../../../../utils/app_constants.dart';

class HomeStoryComponent extends StatefulWidget {
  final VoidCallback? callback;

  HomeStoryComponent({this.callback});

  @override
  State<HomeStoryComponent> createState() => _HomeStoryComponentState();
}

class _HomeStoryComponentState extends State<HomeStoryComponent> with TickerProviderStateMixin {
  List<StoryResponseModel> list = [];
  bool containsUserId = true;

  @override
  void initState() {
    super.initState();
    getStories();

    LiveStream().on(GetUserStories, (p0) {
      list.clear();

      getStories();
    });
  }

  Future<void> getStories() async {
    if (!appStore.isLoggedIn) return;
    appStore.setStoryLoader(true);

    try {
      var value = await getUserStories();

      for (var element in value) {
        element.animationController = AnimationController(
          vsync: this,
          duration: Duration(milliseconds: 2500),
          lowerBound: 0.0,
          upperBound: 1.0,
        );
      }

      list.addAll(value);

      /* list.sort((a, b) {
        if (a.userId.validate().toInt() == userStore.loginUserId.toInt() && b.userId.validate().toInt() != userStore.loginUserId.toInt()) {
          return -1; // 'a' should come before 'b'
        } else if (a.userId.validate().toInt() != userStore.loginUserId.toInt() && b.userId.validate().toInt() == userStore.loginUserId.toInt()) {
          return 1; // 'b' should come before 'a'
        } else {
          return 0; // Maintain original order
        }
      });*/

      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      if (mounted) {
        appStore.setStoryLoader(false);
        toast(e.toString(), print: true);
      }
    } finally {
      // containsUserId = list.any((element) => element.userId == userStore.loginUserId.toInt());
      appStore.setStoryLoader(false);
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    LiveStream().dispose(GetUserStories);
    list.forEach((e) => e.animationController!.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              decoration: BoxDecoration(color: appColorPrimary, shape: BoxShape.circle),
                              child: cachedImage(userStore.loginAvatarUrl, height: 60, width: 60, fit: BoxFit.cover).cornerRadiusWithClipRRect(100),
                            ),
                            Positioned(
                              bottom: -6,
                              right: 0,
                              child: Container(
                                padding: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: appColorPrimary,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: context.scaffoldBackgroundColor, width: 2),
                                ),
                                child: Icon(Icons.add, color: Colors.white, size: 16),
                              ),
                            ),
                          ],
                        ),
                        onTap: () async {
                          FileTypes? file = await showInDialog(
                            context,
                            contentPadding: EdgeInsets.symmetric(vertical: 16),
                            title: Text(language.chooseAnAction, style: boldTextStyle()),
                            builder: (p0) {
                              return FilePickerDialog(isSelected: true, showCameraVideo: true);
                            },
                          );

                          if (file != null) {
                            if (file == FileTypes.CAMERA) {
                              await getImageSource(isCamera: true).then((value) {
                                appStore.setLoading(false);
                                CreateStoryScreen(cameraImage: value).launch(context).then((value) {
                                  if (value ?? false) {
                                    list.clear();
                                    getStories();
                                  } else {
                                    //
                                  }
                                });
                              }).catchError((e) {
                                appStore.setLoading(false);
                                toast(e.toString(), print: true);
                              });
                            } else if (file == FileTypes.CAMERA_VIDEO) {
                              await getImageSource(isCamera: true, isVideo: true).then((value) {
                                appStore.setLoading(false);
                                CreateStoryScreen(cameraImage: value, isCameraVideo: true).launch(context).then((value) {
                                  if (value ?? false) {
                                    list.clear();
                                    getStories();
                                  } else {
                                    //
                                  }
                                });
                              }).catchError((e) {
                                appStore.setLoading(false);
                                toast(e.toString(), print: true);
                              });
                            } else {
                              log(appStore.storyAllowedMediaType);
                              await getMultipleImages(allowedTypeList: appStore.storyAllowedMediaType).then((value) {
                                appStore.setLoading(false);

                                if (value.isNotEmpty)
                                  CreateStoryScreen(mediaList: value).launch(context).then((value) {
                                    if (value ?? false) {
                                      list.clear();
                                      getStories();
                                    }
                                  });
                              }).catchError((e) {
                                appStore.setLoading(false);
                                toast(e.toString(), print: true);
                              });
                            }
                          }
                        },
                      ),
                      10.height,
                      Text(language.yourStory, style: secondaryTextStyle(size: 12, color: appColorPrimary, weight: FontWeight.w500)),
                    ],
                  ).paddingRight(8),
                  if (list.isNotEmpty && !appStore.showStoryLoader)
                    HorizontalList(
                      padding: EdgeInsets.only(left: 0, bottom: 8, right: 8, top: 8),
                      spacing: 8,
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        return SizedBox(
                          width: 60,
                          child: Column(
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  Hero(
                                    tag: "${list[index].name}",
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: context.scaffoldBackgroundColor,
                                        shape: BoxShape.circle,
                                        border: !list[index].showBorder.validate()
                                            ? Border.all(color: context.scaffoldBackgroundColor)
                                            : Border.all(
                                                color: list[index].seen.validate() ? Colors.grey.withOpacity(0.7) : appColorPrimary,
                                                width: 2,
                                              ),
                                      ),
                                      padding: EdgeInsets.all(2),
                                      child: cachedImage(
                                        list[index].avatarUrl,
                                        height: 54,
                                        width: 54,
                                        fit: BoxFit.cover,
                                      ).cornerRadiusWithClipRRect(100),
                                    ),
                                  ).onTap(
                                    () {
                                      if (!list[index].seen.validate()) {
                                        list[index].animationController!.forward();
                                        list[index].showBorder = false;
                                        setState(() {});
                                        list[index].animationController!.addListener(() {
                                          if (list[index].animationController!.isCompleted) {
                                            StoryPage(
                                              initialIndex: index,
                                              stories: list,
                                              initialStoryIndex: list[index].items!.indexWhere((element) => !element.seen.validate()),
                                            ).launch(context).then((value) async {
                                              list[index].showBorder = true;

                                              await 500.milliseconds.delay;
                                              list.clear();
                                              getStories();
                                            });
                                          }
                                        });
                                      } else {
                                        StoryPage(
                                          initialIndex: index,
                                          stories: list,
                                        ).launch(context);
                                      }
                                    },
                                  ),
                                  if (list.isNotEmpty && !list[index].showBorder.validate() && !list[index].seen.validate())
                                    Lottie.asset(
                                      story_loader,
                                      height: 60,
                                      width: 60,
                                      fit: BoxFit.cover,
                                      controller: list[index].animationController!,
                                    ),
                                  /*if (list[index].userId.validate().toInt() == userStore.loginUserId.toInt())
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Container(
                                        padding: EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          color: appColorPrimary,
                                          shape: BoxShape.circle,
                                          border: Border.all(color: context.scaffoldBackgroundColor, width: 2),
                                        ),
                                        child: Icon(Icons.add, color: Colors.white, size: 16),
                                      ).onTap(
                                        () async {
                                          FileTypes? file = await showInDialog(
                                            context,
                                            contentPadding: EdgeInsets.symmetric(vertical: 16),
                                            title: Text(language.chooseAnAction, style: boldTextStyle()),
                                            builder: (p0) {
                                              return FilePickerDialog(isSelected: true, showCameraVideo: true);
                                            },
                                          );

                                          if (file != null) {
                                            if (file == FileTypes.CAMERA) {
                                              await getImageSource(isCamera: true).then((value) {
                                                appStore.setLoading(false);
                                                CreateStoryScreen(cameraImage: value).launch(context).then((value) {
                                                  if (value ?? false) {
                                                    list.clear();
                                                    getStories();
                                                  } else {
                                                    //
                                                  }
                                                });
                                              }).catchError((e) {
                                                appStore.setLoading(false);
                                                toast(e.toString(), print: true);
                                              });
                                            } else if (file == FileTypes.CAMERA_VIDEO) {
                                              await getImageSource(isCamera: true, isVideo: true).then((value) {
                                                appStore.setLoading(false);
                                                CreateStoryScreen(cameraImage: value, isCameraVideo: true).launch(context).then((value) {
                                                  if (value ?? false) {
                                                    list.clear();
                                                    getStories();
                                                  } else {
                                                    //
                                                  }
                                                });
                                              }).catchError((e) {
                                                appStore.setLoading(false);
                                                toast(e.toString(), print: true);
                                              });
                                            } else {
                                              await getMultipleImages(allowedTypeList: appStore.storyAllowedMediaType).then((value) {
                                                appStore.setLoading(false);

                                                if (value.isNotEmpty)
                                                  CreateStoryScreen(mediaList: value).launch(context).then((value) {
                                                    if (value ?? false) {
                                                      list.clear();
                                                      getStories();
                                                    }
                                                  });
                                              }).catchError((e) {
                                                appStore.setLoading(false);
                                                toast(e.toString(), print: true);
                                              });
                                            }
                                          }
                                        },
                                      ),
                                    ),*/
                                ],
                              ),
                              8.height,
                              Text(
                                list[index].name.validate().split(" ").first,
                                style: secondaryTextStyle(size: 12, color: context.iconColor, weight: FontWeight.w500),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
          ThreeBounceLoadingWidget().visible(appStore.showStoryLoader)
        ],
      ),
    );
  }
}
