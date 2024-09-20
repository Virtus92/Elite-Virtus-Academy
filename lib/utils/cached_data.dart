import 'dart:convert';

import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/models/messages/emoji.dart';

import '../models/general_settings_model.dart';
import '../models/posts/post_model.dart';
import 'constants.dart';

ObservableList<Reactions> getReactionsList() {
  if (getStringAsync(SharePreferencesKey.reactions).validate().isNotEmpty) {
    Iterable list = jsonDecode(getStringAsync(SharePreferencesKey.reactions));
    return ObservableList.of(list.map((e) => Reactions.fromJson(e)).toList());
  }
  return ObservableList();
}

ObservableList<MediapressAllowedTypes> getAllowedMediaList() {
  if (getStringAsync(SharePreferencesKey.mediapressAllowedTypes).validate().isNotEmpty) {
    Iterable list = jsonDecode(getStringAsync(SharePreferencesKey.mediapressAllowedTypes));
    return ObservableList.of(list.map((e) => MediapressAllowedTypes.fromJson(e)).toList());
  }
  return ObservableList();
}

ObservableList<Visibilities> getVisibilitiesList() {
  if (getStringAsync(SharePreferencesKey.visibilities).validate().isNotEmpty) {
    Iterable list = jsonDecode(getStringAsync(SharePreferencesKey.visibilities));
    return ObservableList.of(list.map((e) => Visibilities.fromJson(e)).toList());
  }
  return ObservableList();
}

ObservableList<StoryActions> getStoryActionsList() {
  if (getStringAsync(SharePreferencesKey.storyActions).validate().isNotEmpty) {
    Iterable list = jsonDecode(getStringAsync(SharePreferencesKey.storyActions));
    return ObservableList.of(list.map((e) => StoryActions.fromJson(e)).toList());
  }
  return ObservableList();
}

ObservableList<Visibilities> getAccountPrivacyVisibilityList() {
  if (getStringAsync(SharePreferencesKey.accountPrivacyVisibility).validate().isNotEmpty) {
    Iterable list = jsonDecode(getStringAsync(SharePreferencesKey.accountPrivacyVisibility));
    return ObservableList.of(list.map((e) => Visibilities.fromJson(e)).toList());
  }
  return ObservableList();
}

ObservableList<ReportTypes> getReportTypesList() {
  if (getStringAsync(SharePreferencesKey.reportTypes).validate().isNotEmpty) {
    Iterable list = jsonDecode(getStringAsync(SharePreferencesKey.reportTypes));
    return ObservableList.of(list.map((e) => ReportTypes.fromJson(e)).toList());
  }
  return ObservableList();
}

ObservableList<SignupFields> getSignUpFieldList() {
  if (getStringAsync(SharePreferencesKey.signupFields).validate().isNotEmpty) {
    Iterable list = jsonDecode(getStringAsync(SharePreferencesKey.signupFields));
    return ObservableList.of(list.map((e) => SignupFields.fromJson(e)).toList());
  }
  return ObservableList();
}

ObservableList<String> getStoryAllowedMediaList() {
  if (getStringAsync(SharePreferencesKey.storyAllowedTypes).validate().isNotEmpty) {
    Iterable list = jsonDecode(getStringAsync(SharePreferencesKey.storyAllowedTypes));
    return ObservableList.of(List<String>.from(list));
  }
  return ObservableList();
}

ObservableList<PostModel> getCachedPostList() {
  if (getStringAsync(SharePreferencesKey.cachedPostList).validate().isNotEmpty) {
    Iterable list = jsonDecode(getStringAsync(SharePreferencesKey.cachedPostList));
    return ObservableList.of(list.map((e) => PostModel.fromJson(e)).toList());
  }
  return ObservableList();
}

ObservableList<Emojis> getCachedEmojiList() {
  if (getStringAsync(SharePreferencesKey.emojiList).validate().isNotEmpty) {
    Iterable list = jsonDecode(getStringAsync(SharePreferencesKey.emojiList));
    return ObservableList.of(list.map((e) => Emojis.fromJson(e)).toList());
  }
  return ObservableList();
}

ObservableList<GamipressAchievementTypes> getCachedGamipressAchievementEndpoints() {
  if (getStringAsync(SharePreferencesKey.achievementType).validate().isNotEmpty) {
    Iterable list = jsonDecode(getStringAsync(SharePreferencesKey.achievementType));
    return ObservableList.of(list.map((e) => GamipressAchievementTypes.fromJson(e)).toList());
  }
  return ObservableList();
}
