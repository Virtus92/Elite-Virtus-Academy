import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../main.dart';
import '../components/album_upload_component.dart';
import '../components/create_album_component.dart';

class CreateAlbumScreen extends StatefulWidget {
  final int? groupID;
  final VoidCallback refreshAlbum;

  const CreateAlbumScreen({Key? key, this.groupID, required this.refreshAlbum}) : super(key: key);

  @override
  State<CreateAlbumScreen> createState() => _CreateAlbumScreenState();
}

class _CreateAlbumScreenState extends State<CreateAlbumScreen> {
  PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.scaffoldBackgroundColor,
        title: Text(language.createAlbum, style: boldTextStyle(size: 20)),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.iconColor),
          onPressed: () {
            finish(context);
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: context.cardColor,
          borderRadius: radiusOnly(topRight: defaultRadius, topLeft: defaultRadius),
        ),
        child: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: _pageController,
          children: [
            CreateAlbumComponent(
              groupId: widget.groupID,
              refreshAlbum: () {
                widget.refreshAlbum.call();
              },
              selectedMedia: appStore.selectedAlbumMedia,
              onNextPage: (int nextPageIndex) {
                _pageController.animateToPage(nextPageIndex, duration: const Duration(milliseconds: 250), curve: Curves.linear);
                setState(() {});
              },
            ),
            AlbumUploadScreen(
              albumId: appStore.createdAlbumId,
              refreshCallback: () {
                widget.refreshAlbum.call();
              },
            ),
          ],
        ),
      ),
    );
  }
}
