import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/utils/app_constants.dart';

import '../../../components/loading_widget.dart';
import '../../../components/no_data_lottie_widget.dart';
import '../../../main.dart';
import '../../../models/gallery/albums.dart';
import '../../../models/posts/media_model.dart';
import '../../../network/rest_apis.dart';
import '../components/gallery_create_album_button.dart';
import '../components/gallery_screen_album_component.dart';
import 'create_album_screen.dart';
import 'single_album_detail_screen.dart';

class GalleryScreen extends StatefulWidget {
  final int? groupId;
  final int? userId;
  final bool canEdit;

  GalleryScreen({Key? key, this.groupId, this.userId, this.canEdit = false}) : super(key: key);

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  List<Albums> albumList = [];

  List<MediaModel> mediaTypeList = [];
  Future<List<Albums>>? futureAlbum;
  ScrollController scrollCont = ScrollController();
  int mPage = 1;

  int selectedIndex = 0;
  bool mIsLastPage = false;

  @override
  void initState() {
    super.initState();
    mediaTypeList = appStore.allowedMedia.validate().firstWhere((element) => element.component == (widget.groupId != null ? Component.groups : Component.members)).allowedTypes.validate();
    mediaTypeList.insert(0, MediaModel(type: '', title: "All", isActive: true));
    init();
    setStatusBarColorBasedOnTheme();
    afterBuildCreated(
      () {
        scrollCont.addListener(
          () {
            if (scrollCont.position.pixels == scrollCont.position.maxScrollExtent) {
              if (!mIsLastPage) {
                setState(
                  () {
                    mPage++;
                  },
                );
                init(page: mPage);
              }
            }
          },
        );
      },
    );
  }

  void init({int page = 1, bool showLoader = true}) async {
    appStore.setLoading(showLoader);
    futureAlbum = await getAlbums(
      type: mediaTypeList[selectedIndex].type,
      userId: widget.userId,
      page: page,
      groupId: widget.groupId == null ? "" : widget.groupId.toString(),
      albumList: albumList,
    ).then(
      (value) {
        appStore.setLoading(false);
        setState(() {});
      },
    ).catchError(
      (e) {
        toast(e.toString(), print: true);
        appStore.setLoading(false);
        throw e;
      },
    );
  }

  Future<void> deleteAlbum({required int id}) async {
    ifNotTester(
      () async {
        mPage = 1;
        setState(() {});
        appStore.setLoading(true);
        await deleteMedia(id: id, type: MediaTypes.gallery).then(
          (value) {
            toast(value.message);
            init();
          },
        ).catchError(
          (e) {
            toast(e.toString());
            appStore.setLoading(false);
            setState(() {});
          },
        );
      },
    );
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    if (appStore.isLoading) appStore.setLoading(false);
    setStatusBarColorBasedOnTheme();
    scrollCont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.scaffoldBackgroundColor,
        title: Text(language.gallery, style: boldTextStyle(size: 20)),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.iconColor),
          onPressed: () {
            finish(context);
          },
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            child: HorizontalList(
              itemCount: mediaTypeList.length,
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              itemBuilder: (context, index) {
                MediaModel item = mediaTypeList[index];
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: selectedIndex == index ? context.primaryColor : context.cardColor,
                    borderRadius: BorderRadius.all(radiusCircular()),
                  ),
                  child: Text(
                    item.title.validate(),
                    style: boldTextStyle(size: 14, color: selectedIndex == index ? context.cardColor : context.primaryColor),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ).onTap(
                  () {
                    if (selectedIndex != index && !appStore.isLoading) {
                      selectedIndex = index;
                      setState(() {});
                      init();
                    }
                    appStore.setSelectedMedia(selectedIndex == 0 ? mediaTypeList[1] : mediaTypeList[selectedIndex]);
                  },
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                );
              },
            ),
            top: 0,
            left: 0,
            right: 0,
          ),
          FutureBuilder<List<Albums>>(
            future: futureAlbum,
            builder: (context, snap) {
              if (snap.hasError) {
                return SizedBox(
                  height: context.height() * 0.8,
                  child: NoDataWidget(
                    imageWidget: NoDataLottieWidget(),
                    title: snap.error.toString(),
                    onRetry: () {
                      init();
                    },
                    retryText: '   ${language.clickToRefresh}   ',
                  ).center(),
                );
              } else if (mediaTypeList.isEmpty && !appStore.isLoading) {
                return SizedBox(
                  height: context.height() * 0.8,
                  child: NoDataWidget(
                    imageWidget: NoDataLottieWidget(),
                    title: language.noAlbumsFound,
                    onRetry: () {
                      init();
                    },
                    retryText: '   ${language.clickToRefresh}   ',
                  ).center(),
                );
              } else {
                return SingleChildScrollView(
                  controller: scrollCont,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (albumList.isEmpty && !appStore.isLoading)
                        SizedBox(
                          height: context.height() * 0.74,
                          child: !widget.canEdit.validate()
                              ? NoDataWidget(
                                  imageWidget: NoDataLottieWidget(),
                                  title: language.noDataFound,
                                  onRetry: () {
                                    init();
                                  },
                                  retryText: '   ${language.clickToRefresh}   ',
                                ).center()
                              : GalleryCreateAlbumButton(
                                  isEmptyList: true,
                                  mediaTypeList: mediaTypeList,
                                  callback: () {
                                    CreateAlbumScreen(
                                      groupID: widget.groupId,
                                      refreshAlbum: () {
                                        init();
                                      },
                                    ).launch(context);
                                  },
                                ),
                        ),
                      if (albumList.isNotEmpty)
                        Column(
                          children: [
                            if (widget.canEdit.validate())
                              GalleryCreateAlbumButton(
                                mediaTypeList: mediaTypeList,
                                isEmptyList: false,
                                callback: () {
                                  CreateAlbumScreen(
                                    groupID: widget.groupId,
                                    refreshAlbum: () {
                                      init();
                                    },
                                  ).launch(context);
                                },
                              ),
                            8.height,
                            GridView.builder(
                              itemCount: albumList.length,
                              padding: EdgeInsets.only(bottom: mIsLastPage ? 16 : 60, left: 16, right: 16),
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 1,
                                crossAxisSpacing: 8,
                                mainAxisExtent: 160,
                                mainAxisSpacing: 8,
                              ),
                              itemBuilder: (context, index) {
                                Albums album = albumList[index];
                                return GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
                                    SingleAlbumDetailScreen(
                                      album: album,
                                      canEdit: widget.canEdit,
                                    ).launch(context);
                                  },
                                  child: GalleryScreenAlbumComponent(
                                    album: album,
                                    canDelete: album.canDelete.validate(),
                                    callback: (albumId) {
                                      deleteAlbum(id: albumId);
                                    },
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                    ],
                  ),
                );
              }
            },
          ).paddingTop(80),
          Positioned(
            bottom: albumList.isNotEmpty && mPage != 1 ? 8 : null,
            width: albumList.isNotEmpty && mPage != 1 ? MediaQuery.of(context).size.width : null,
            child: Observer(builder: (_) => LoadingWidget(isBlurBackground: mPage == 1 ? true : false).center().visible(appStore.isLoading)),
          ),
        ],
      ),
    );
  }
}
