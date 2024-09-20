import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/network/rest_apis.dart';

import '../../../components/loading_widget.dart';
import '../../../main.dart';
import '../../../models/general_settings_model.dart';
import '../../../models/posts/media_model.dart';
import '../../../utils/colors.dart';
import '../../../utils/common.dart';
import '../../../utils/constants.dart';

class CreateAlbumComponent extends StatefulWidget {
  final Function(int)? onNextPage;

  final VoidCallback refreshAlbum;
  final int? groupId;

  MediaModel? selectedMedia;

  CreateAlbumComponent({Key? key, this.onNextPage, this.groupId, this.selectedMedia, required this.refreshAlbum}) : super(key: key);

  @override
  State<CreateAlbumComponent> createState() => _CreateAlbumComponentState();
}

class _CreateAlbumComponentState extends State<CreateAlbumComponent> {
  final albumKey = GlobalKey<FormState>();
  MediaModel? dropdownTypeValue;

  List<MediaModel> mediaList = [];

  PrivacyStatus? dropdownStatusValue;
  TextEditingController titleCont = TextEditingController();
  TextEditingController discCont = TextEditingController();
  FocusNode titleNode = FocusNode();
  FocusNode discNode = FocusNode();

  @override
  void initState() {
    mediaList = appStore.allowedMedia.firstWhere((element) => element.component == (widget.groupId != null ? Component.groups : Component.members)).allowedTypes;
    if (appStore.selectedAlbumMedia != null) dropdownTypeValue = mediaList.firstWhere((element) => element.type == widget.selectedMedia!.type);
    init();
    super.initState();
  }

  Future<void> init() async {
    appStore.setMediaStatusList(appStore.allowedMedia.firstWhere((element) => element.component == (widget.groupId != null ? Component.groups : Component.members)).privacyStatus);
  }

  void createNewAlbum() {
    ifNotTester(
      () {
        appStore.setLoading(true);
        setState(() {});
        createAlbum(
          groupID: widget.groupId,
          component: widget.groupId == null ? Component.members : Component.groups,
          title: titleCont.text,
          type: appStore.selectedAlbumMedia!.type.validate(),
          description: discCont.text,
          status: dropdownStatusValue!.slug.validate(),
        ).then((value) {
          toast(value.message.toString(), print: true);
          appStore.setSelectedAlbumId(value.albumId.validate());
          appStore.setLoading(false);
          widget.onNextPage?.call(1);
          widget.refreshAlbum.call();
        }).catchError(
          (e) {
            toast(e.toString(), print: true);
            appStore.setLoading(false);
            setState(() {});
          },
        );
      },
    );
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    titleNode.dispose();
    discNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: context.height(),
            width: context.width(),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            padding: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(defaultRadius)),
              color: context.cardColor,
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  24.height,
                  Text(
                    "1. ${language.addAlbumDetails}",
                    style: primaryTextStyle(color: appStore.isDarkMode ? bodyDark : bodyWhite, size: 18),
                  ),
                  16.height,
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(language.type, style: boldTextStyle()),
                          if (mediaList.validate().isNotEmpty)
                            Container(
                              height: 40,
                              width: 200,
                              decoration: BoxDecoration(color: context.scaffoldBackgroundColor, borderRadius: radius(commonRadius)),
                              child: DropdownButtonHideUnderline(
                                child: ButtonTheme(
                                  alignedDropdown: true,
                                  child: DropdownButton<MediaModel>(
                                    isExpanded: true,
                                    borderRadius: BorderRadius.circular(commonRadius),
                                    value: dropdownTypeValue,
                                    icon: Icon(Icons.arrow_drop_down, color: appStore.isDarkMode ? bodyDark : bodyWhite),
                                    elevation: 8,
                                    style: primaryTextStyle(),
                                    underline: Container(height: 2, color: appColorPrimary),
                                    alignment: Alignment.bottomCenter,
                                    onChanged: (MediaModel? newValue) {
                                      dropdownTypeValue = newValue!;
                                      appStore.setSelectedMedia(newValue);
                                      setState(() {});
                                    },
                                    items: mediaList.map((value) {
                                      return DropdownMenuItem<MediaModel>(
                                        value: value,
                                        child: Text(
                                          '${value.title.validate()}',
                                          overflow: TextOverflow.ellipsis,
                                          style: primaryTextStyle(),
                                          maxLines: 1,
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      16.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(language.status, style: boldTextStyle()),
                          Container(
                            height: 40,
                            width: 200,
                            decoration: BoxDecoration(color: context.scaffoldBackgroundColor, borderRadius: radius(commonRadius)),
                            child: DropdownButtonHideUnderline(
                              child: ButtonTheme(
                                alignedDropdown: true,
                                child: DropdownButton<PrivacyStatus>(
                                  borderRadius: BorderRadius.circular(commonRadius),
                                  value: dropdownStatusValue,
                                  isExpanded: true,
                                  icon: Icon(Icons.arrow_drop_down, color: appStore.isDarkMode ? bodyDark : bodyWhite),
                                  elevation: 8,
                                  style: primaryTextStyle(),
                                  underline: Container(height: 2, color: appColorPrimary),
                                  alignment: Alignment.bottomCenter,
                                  onChanged: (PrivacyStatus? newValue) {
                                    setState(() {
                                      dropdownStatusValue = newValue!;
                                    });
                                  },
                                  items: appStore.mediaStatusList.validate().map<DropdownMenuItem<PrivacyStatus>>((e) {
                                    return DropdownMenuItem<PrivacyStatus>(
                                      value: e,
                                      child: e.label != language.all
                                          ? Text(
                                              '${e.label.validate()}',
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: primaryTextStyle(),
                                            )
                                          : Offstage(),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      8.height,
                      Form(
                        key: albumKey,
                        child: Column(
                          children: [
                            TextFormField(
                              focusNode: titleNode,
                              controller: titleCont,
                              autofocus: false,
                              maxLines: 1,
                              textInputAction: TextInputAction.next,
                              decoration: inputDecorationFilled(
                                context,
                                fillColor: context.scaffoldBackgroundColor,
                                label: language.title,
                              ),
                              onFieldSubmitted: (value) {
                                titleNode.unfocus();
                                FocusScope.of(context).requestFocus(discNode);
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return language.pleaseEnterTitle;
                                } else {
                                  return null;
                                }
                              },
                            ),
                            16.height,
                            TextFormField(
                              focusNode: discNode,
                              controller: discCont,
                              autofocus: false,
                              maxLines: 5,
                              decoration: inputDecorationFilled(
                                context,
                                fillColor: context.scaffoldBackgroundColor,
                                label: language.description,
                              ),
                            ),
                          ],
                        ).paddingSymmetric(vertical: 8),
                      ),
                      8.height,
                      Align(
                        alignment: Alignment.center,
                        child: appButton(
                          text: language.create,
                          onTap: () {
                            hideKeyboard(context);
                            if (albumKey.currentState!.validate() && !appStore.isLoading) {
                              createNewAlbum();
                            }
                          },
                          context: context,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Positioned(
            child: Observer(builder: (_) => LoadingWidget().center().visible(appStore.isLoading)),
          ),
        ],
      ),
    );
  }
}
