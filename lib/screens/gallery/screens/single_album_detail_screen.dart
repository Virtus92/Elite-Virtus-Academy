import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/components/no_data_lottie_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/gallery/album_media_list_model.dart';
import 'package:socialv/models/gallery/albums.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/screens/gallery/components/album_media_component.dart';
import 'package:socialv/utils/app_constants.dart';

import 'add_media_screen.dart';

class SingleAlbumDetailScreen extends StatefulWidget {
  final Albums album;
  final bool canEdit;

  const SingleAlbumDetailScreen({Key? key, required this.album, this.canEdit = false}) : super(key: key);

  @override
  State<SingleAlbumDetailScreen> createState() => _SingleAlbumDetailScreenState();
}

class _SingleAlbumDetailScreenState extends State<SingleAlbumDetailScreen> {
  List<AlbumMediaListModel> albumMediaList = [];
  ScrollController scrollCont = ScrollController();
  Future<List<AlbumMediaListModel>>? future;
  int mPage = 1;
  bool mIsLastPage = false;

  @override
  void initState() {
    init();
    super.initState();
    scrollCont.addListener(() {
      if (scrollCont.position.pixels == scrollCont.position.maxScrollExtent) {
        if (!mIsLastPage) {
          init(page: mPage);
        }
      }
    });
  }

  Future<void> init({bool showLoader = true, int page = 1}) async {
    appStore.setSelectedAlbumId(widget.album.id.validate().toInt());
    appStore.setLoading(showLoader);
    future = await getAlbumDetails(
      galleryID: widget.album.id.validate().toInt(),
      page: page,
      albumMediaList: albumMediaList,
      lastPageCallback: (p0) {
        mIsLastPage = p0;
        setState(() {});
      },
    ).then((value) {
      appStore.setLoading(false);
      setState(() {});
    }).catchError(
      (e) {
        toast(e.toString(), print: true);
        appStore.setLoading(false);
      },
    );
  }

  Future<void> deleteAlbumMedia({required int id}) async {
    ifNotTester(
      () async {
        appStore.setLoading(true);
        await deleteMedia(id: id, type: MediaTypes.media).then(
          (value) async {
            init();
          },
        ).catchError(
          (e) {
            toast(e.toString());
            appStore.setLoading(false);
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.scaffoldBackgroundColor,
        title: Text(language.album, style: boldTextStyle(size: 20)),
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
        fit: StackFit.expand,
        children: [
          FutureBuilder(
            future: future,
            builder: (context, snapshot) {
              if (!appStore.isLoading && snapshot.hasError)
                return SizedBox(
                  height: context.height() * 0.8,
                  child: NoDataWidget(
                    imageWidget: NoDataLottieWidget(),
                    title: snapshot.error.toString(),
                    onRetry: () {
                      init();
                    },
                    retryText: '   ${language.clickToRefresh}   ',
                  ).center(),
                );
              return AnimatedScrollView(
                padding: EdgeInsets.all(16),
                onNextPage: () {
                  setState(() {
                    mPage++;
                  });
                  init(page: mPage);
                },
                onSwipeRefresh: () async {
                  return await init();
                },
                children: [
                  RichText(
                    text: TextSpan(
                      text: "${language.title}: ",
                      style: boldTextStyle(),
                      children: [
                        TextSpan(text: widget.album.name, style: primaryTextStyle()),
                      ],
                    ),
                  ),
                  16.height,
                  RichText(
                    text: TextSpan(
                      text: "${language.description}: ",
                      style: boldTextStyle(),
                      children: [
                        TextSpan(text: widget.album.description, style: primaryTextStyle()),
                      ],
                    ),
                  ),
                  if (albumMediaList.isEmpty && !appStore.isLoading)
                    (widget.canEdit.validate() && !appStore.isLoading)
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              50.height,
                              Text(language.albumWithNoMedia, style: boldTextStyle()),
                              8.height,
                              TextButton(
                                onPressed: () {
                                  AddMediaScreen(
                                    fileType: widget.album.type,
                                    alubmId: widget.album.id.validate().toInt(),
                                    refreshCallback: () {
                                      init();
                                    },
                                  ).launch(context);
                                },
                                child: Text("${language.add} ${widget.album.type.capitalizeFirstLetter()}", style: primaryTextStyle(color: context.primaryColor)),
                              ),
                            ],
                          ).center()
                        : SizedBox(
                            height: context.height() * 0.74,
                            child: NoDataWidget(
                              imageWidget: NoDataLottieWidget(),
                              title: language.noMediaFound,
                              onRetry: () {
                                init();
                              },
                              retryText: '   ${language.clickToRefresh}   ',
                            ).center(),
                          )
                  else
                    GridView.builder(
                      itemCount: albumMediaList.length,
                      padding: EdgeInsets.only(bottom: mIsLastPage ? 16 : 60, top: 16),
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
                        AlbumMediaListModel media = albumMediaList[index];
                        return AlbumMediaComponent(
                          mediaType: widget.album.type,
                          canDelete: media.canDelete.validate(),
                          thumbnail: widget.album.thumbnail.validate(),
                          mediaUrl: media.url.validate(),
                          onDelete: () {
                            deleteAlbumMedia(id: media.id.validate().toInt());
                          },
                        );
                      },
                    )
                ],
              );
            },
          ),
          Positioned(
            bottom: mPage != 1 ? 8 : null,
            width: mPage != 1 ? MediaQuery.of(context).size.width : null,
            child: Observer(
              builder: (_) => LoadingWidget(isBlurBackground: mPage == 1 ? true : false).center().visible(appStore.isLoading),
            ),
          ),
        ],
      ),
      floatingActionButton: widget.canEdit.validate()
          ? FloatingActionButton(
              onPressed: () {
                AddMediaScreen(
                  fileType: widget.album.type,
                  alubmId: widget.album.id!.toInt(),
                  refreshCallback: () {
                    init();
                  },
                ).launch(context);
              },
              child: Icon(Icons.add, color: Colors.white),
              backgroundColor: context.primaryColor,
            ).visible(albumMediaList.isNotEmpty)
          : null,
    );
  }
}
