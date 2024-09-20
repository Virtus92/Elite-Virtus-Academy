import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';

import '../components/album_upload_component.dart';

// ignore: must_be_immutable
class AddMediaScreen extends StatefulWidget {
  String? fileType;
  int? alubmId;
  int? groupId;
  final VoidCallback refreshCallback;

  AddMediaScreen({required this.fileType, required this.refreshCallback, this.alubmId, this.groupId});

  @override
  State<AddMediaScreen> createState() => _AddMediaScreenState();
}

class _AddMediaScreenState extends State<AddMediaScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.scaffoldBackgroundColor,
        title: Text(language.addMedia, style: boldTextStyle(size: 20)),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.iconColor),
          onPressed: () {
            finish(context);
          },
        ),
      ),
      body: AlbumUploadScreen(
        fileType: widget.fileType,
        albumId: widget.alubmId,
        groupId: widget.groupId,
        refreshCallback: () {
          widget.refreshCallback.call();
        },
      ),
    );
  }
}
