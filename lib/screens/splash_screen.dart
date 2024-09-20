import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/screens/auth/screens/sign_in_screen.dart';
import 'package:socialv/screens/dashboard_screen.dart';

import '../utils/app_constants.dart';

class SplashScreen extends StatefulWidget {
  final String? deepLink;

  const SplashScreen({this.deepLink});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    setStatusBarColor(Colors.transparent);
    super.initState();
    init();
  }

  Future<void> init() async {
    generalSettings();
    afterBuildCreated(() async {
      appStore.setLanguage(getStringAsync(SharePreferencesKey.LANGUAGE, defaultValue: Constants.defaultLanguage));

      int themeModeIndex = getIntAsync(SharePreferencesKey.APP_THEME, defaultValue: AppThemeMode.ThemeModeDark);
      if (themeModeIndex == AppThemeMode.ThemeModeSystem) {
        appStore.toggleDarkMode(value: MediaQuery.of(context).platformBrightness != Brightness.light, isFromMain: true);
      }

      if (await isAndroid12Above()) {
        await 500.milliseconds.delay;
      } else {
        await 2.seconds.delay;
      }

      if (widget.deepLink.validate().isNotEmpty) {
        handleDeepLinking(context: context, deepLink: widget.deepLink.validate());
      } else if (appStore.isLoggedIn && !isTokenExpire) {
        if (!getBoolAsync(SharePreferencesKey.isAPPConfigurationCalledAtLeastOnce)) {
          generalSettings();
        }
        DashboardScreen().launch(context, isNewTask: true);
      } else {
        SignInScreen().launch(context, isNewTask: true);
      }
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    setStatusBarColorBasedOnTheme();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(SPLASH_SCREEN_IMAGE, height: context.height(), width: context.width(), fit: BoxFit.cover),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                APP_ICON,
                height: 50,
                width: 52,
                fit: BoxFit.cover,
              ),
              8.width,
              Text(APP_NAME, style: boldTextStyle(color: Colors.white, size: 40)),
            ],
          ),
        ],
      ),
    );
  }
}
