import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';

Widget cachedImage(String? url, {double? height, double? width, BoxFit? fit, AlignmentGeometry? alignment, bool usePlaceholderIfUrlEmpty = true, double? radius, Color? color}) {
  final link =url.validate().replaceAll(r'\/', '/');
  if (link.validate().isEmpty) {
    return placeHolderWidget(height: height, width: width, fit: fit, alignment: alignment, radius: radius);
  } else if (link.startsWith('http')) {
    if (link.validate().endsWith('.svg')) {
      return SvgPicture.network(
        link,
        height: height,
        width: width,
        fit: fit ?? BoxFit.cover,
      );
    }
    return CachedNetworkImage(
      imageUrl: link.validate(),
      height: height,
      width: width,
      fit: fit,
      filterQuality: FilterQuality.medium,
      alignment: alignment as Alignment? ?? Alignment.center,
      errorWidget: (_, s, d) {
        return placeHolderWidget(height: height, width: width, fit: fit, alignment: alignment, radius: radius);
      },
      placeholder: (_, s) {
        if (!usePlaceholderIfUrlEmpty) return SizedBox();
        return placeHolderWidget(height: height, width: width, fit: fit, alignment: alignment, radius: radius);
      },
    );
  } else if (link.startsWith('/data')) {
    return Image.file(
      File(link),
      height: height,
      width: width,
      fit: fit,
      alignment: alignment ?? Alignment.center,
    ).cornerRadiusWithClipRRectOnly(
      topRight: defaultAppButtonRadius.toInt(),
      topLeft: defaultAppButtonRadius.toInt(),
    );
  } else if (link.validate().contains("img")) {
    return CachedNetworkImage(
      imageUrl: getSourceLink(link.validate()),
      height: height,
      width: width,
      fit: fit,
      filterQuality: FilterQuality.high,
      alignment: alignment as Alignment? ?? Alignment.center,
      errorWidget: (_, s, d) {
        return placeHolderWidget(height: height, width: width, fit: fit, alignment: alignment, radius: radius);
      },
      placeholder: (_, s) {
        if (!usePlaceholderIfUrlEmpty) return SizedBox();
        return placeHolderWidget(height: height, width: width, fit: fit, alignment: alignment, radius: radius);
      },
    );
  } else {
    return Image.asset(
      link,
      height: height,
      width: width,
      fit: fit,
      alignment: alignment ?? Alignment.center,
      color: color,
    ).cornerRadiusWithClipRRectOnly(
      topRight: defaultAppButtonRadius.toInt(),
      topLeft: defaultAppButtonRadius.toInt(),
    );
  }
}

Widget placeHolderWidget({double? height, double? width, BoxFit? fit, AlignmentGeometry? alignment, double? radius}) {
  return PlaceHolderWidget(height: height, width: width, color: appStore.isDarkMode ? Colors.white10 : null);
}

String getSourceLink(String htmlData) {
  var document = parse(htmlData);
  dom.Element? link = document.querySelector('img');
  String? imageLink = link != null ? link.attributes['src'].validate() : '';
  log(imageLink);
  return imageLink.validate();
}
