import 'package:string_contains/string_contains.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';

extension FilteredString on String? {
  String validateAndFilter() {
    if (appStore.filterContent) {
      return this.validate().cleanBadWords(keepFirstLastLetters: false);
    } else {
      return this.validate();
    }
  }
}