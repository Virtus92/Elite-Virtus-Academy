import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:video_player/video_player.dart';

import '../../../components/file_picker_dialog_component.dart';
import '../../../components/loading_widget.dart';
import '../../../main.dart';
import '../../../models/common_models.dart';
import '../../../network/rest_apis.dart';
import '../../../utils/colors.dart';
import '../../../utils/common.dart';
import '../../../utils/constants.dart';
import '../../post/components/show_selected_media_component.dart';

// ignore: must_be_immutable
class AlbumUploadScreen extends StatefulWidget {
  final String? fileType;
  final int? groupId;

  final int? albumId;
  final VoidCallback refreshCallback;

  AlbumUploadScreen({this.fileType, this.groupId, this.albumId, required this.refreshCallback});

  @override
  State<AlbumUploadScreen> createState() => _AlbumUploadScreenState();
}

class _AlbumUploadScreenState extends State<AlbumUploadScreen> {
  List<PostMedia> mediaList = [];

  @override
  void initState() {
    super.initState();
    mediaList.clear();
    if (widget.fileType != null) {
      appStore.setSelectedMedia(
          appStore.allowedMedia.validate().firstWhere((element) => element.component == (widget.groupId != null ? Component.groups : Component.members)).allowedTypes.validate().firstWhere((element) => element.type == widget.fileType));
    }
  }

  Future<void> onSelectMedia() async {
    FileTypes? file = await showInDialog(
      context,
      contentPadding: EdgeInsets.symmetric(vertical: 16),
      title: Text(language.chooseAnAction, style: boldTextStyle()),
      builder: (p0) {
        return FilePickerDialog(isSelected: true);
      },
    );

    if (file != null) {
      if (file == FileTypes.CAMERA) {
        appStore.setLoading(true);
        await getImageSource(isCamera: true, isVideo: appStore.selectedAlbumMedia!.type == MediaTypes.video).then((value) {
          appStore.setLoading(false);
          mediaList.add(PostMedia(file: value));
          setState(() {});
        }).catchError((e) {
          log('Error: ${e.toString()}');
          appStore.setLoading(false);
        });
      } else {
        appStore.setLoading(true);
        getMultipleFiles(mediaType: appStore.selectedAlbumMedia!, postingInComponent: widget.groupId != null ? Component.groups : Component.members).then((value) {
          appStore.setLoading(false);
          value.forEach((element) {
            mediaList.add(PostMedia(file: element));
          });
          setState(() {});
        }).catchError((e) {
          appStore.setLoading(false);
          log('Error: ${e.toString()}');
        });
        log('MediaList: ${mediaList.length}');
      }
    }
  }

  void onUpload() async {
    ifNotTester(() async {
      if (mediaList.isEmpty) {
        toast(language.addPostContent);
      } else {
        log(widget.albumId);
        appStore.setLoading(true);
        await uploadMediaFiles(groupId: widget.groupId, count: mediaList.length, galleryId: widget.albumId, media: mediaList).then(
          (value) async {
            widget.refreshCallback.call();
            appStore.setLoading(false);
            finish(context, true);
          },
        ).catchError(
          (e) {
            toast(language.somethingWentWrong, print: true);
            appStore.setLoading(false);
            finish(context, true);
          },
        );
      }
    });
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 16),
          child: Container(
            decoration: BoxDecoration(color: context.cardColor, borderRadius: BorderRadius.vertical(top: Radius.circular(defaultRadius))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                24.height,
                if (widget.fileType == null) Text("2. ${language.addMediaFile}", style: primaryTextStyle(color: appStore.isDarkMode ? bodyDark : bodyWhite, size: 18)).paddingSymmetric(horizontal: 16),
                Stack(
                  children: [
                    DottedBorderWidget(
                      padding: EdgeInsets.symmetric(vertical: 32),
                      radius: defaultAppButtonRadius,
                      dotsWidth: 8,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          16.height,
                          AppButton(
                            elevation: 0,
                            color: appColorPrimary,
                            text: language.selectFiles,
                            textStyle: boldTextStyle(color: Colors.white),
                            onTap: () async {
                              if (appStore.selectedAlbumMedia!.type == MediaTypes.photo || appStore.selectedAlbumMedia!.type == MediaTypes.video) {
                                onSelectMedia();
                              } else {
                                appStore.setLoading(true);
                                log(appStore.selectedAlbumMedia != null);
                                getMultipleFiles(mediaType: appStore.selectedAlbumMedia!, postingInComponent: widget.groupId != null ? Component.groups : Component.members).then((value) {
                                  appStore.setLoading(false);
                                  value.forEach((element) {
                                    mediaList.add(PostMedia(file: element));
                                  });
                                }).catchError((e) {
                                  appStore.setLoading(false);
                                  log('Error: ${e.toString()}');
                                });
                                log('MediaList: ${mediaList.length}');
                              }
                            },
                          ),
                          16.height,
                          Text(
                            '${language.add} ${widget.fileType == null ? appStore.selectedAlbumMedia?.title.capitalizeFirstLetter() : widget.fileType} files',
                            style: secondaryTextStyle(size: 16),
                          ).center(),
                          8.height,
                          Text(
                            '${language.pleaseSelectOnly} ${widget.fileType == null ? appStore.selectedAlbumMedia?.type : widget.fileType} ${language.files} ',
                            style: secondaryTextStyle(),
                          ).center(),
                          16.height,
                        ],
                      ),
                    ),
                    Positioned(
                      child: Icon(Icons.cancel_outlined, color: appColorPrimary, size: 18).paddingAll(4).onTap(() {
                        finish(context);
                        finish(context);
                      }, splashColor: Colors.transparent, highlightColor: Colors.transparent),
                      right: 6,
                      top: 6,
                    ),
                  ],
                ).paddingAll(16),
                if (mediaList.isNotEmpty)
                  ShowSelectedMediaComponent(
                    mediaList: mediaList,
                    mediaType: appStore.selectedAlbumMedia!,
                    videoController: List.generate(mediaList.length, (index) {
                      return VideoPlayerController.file(mediaList[index].file!);
                    }),
                  ),
                8.height,
                Align(
                  alignment: Alignment.center,
                  child: appButton(
                    text: language.upload,
                    onTap: () {
                      if (!appStore.isLoading) onUpload();
                    },
                    context: context,
                  ),
                ),
              ],
            ),
          ),
        ),
        Observer(builder: (_) => LoadingWidget().visible(appStore.isLoading))
      ],
    );
  }
}
