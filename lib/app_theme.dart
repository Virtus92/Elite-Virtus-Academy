import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/utils/colors.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: Color(0xFF061A24),
    // Body background color
    primaryColor: Color(0xFFDC1B1A),
    // Primary color (rot)
    primaryColorDark: Color(0xFFDC1B1A),
    // Darker primary color
    useMaterial3: false,
    hoverColor: Colors.white54,
    dividerColor: Color(0xFF061A24).withOpacity(0.4),
    // Adjusting opacity for body color
    fontFamily: GoogleFonts
        .plusJakartaSans()
        .fontFamily,
    appBarTheme: AppBarTheme(
      surfaceTintColor: Color(0xFF061A24), // AppBar background color
      color: Color(0xFF061A24),
      iconTheme: IconThemeData(color: Color(0xFFFFFFFF)), // White icon color
      systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark),
    ),
    tabBarTheme: TabBarTheme(
        indicator: UnderlineTabIndicator(borderSide: BorderSide(
            color: Color(0xFFFFE400), width: 3)) // Yellow underline for tabs
    ),
    textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.black),
    cardTheme: CardTheme(color: Colors.white),
    cardColor: Color(0xFF1B678C),
    // Light gradient color for cards
    iconTheme: IconThemeData(color: Color(0xFFFFFFFF)),
    // White icon color
    bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.white),
    textTheme: TextTheme(
      labelLarge: TextStyle(color: Color(0xFFDC1B1A)),
      // Primary color (rot) for large text
      titleLarge: TextStyle(color: Color(0xFFFFFFFF)),
      // White for large titles
      titleSmall: TextStyle(
          color: Color(0xFF003854)), // Secondary color (dark blue)
    ),
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.all(
          Color(0xFFDC1B1A)), // Primary color for radio buttons
    ),
    colorScheme: ColorScheme.light(primary: Color(0xFFDC1B1A)).copyWith(
        error: Colors.red), // Red error color
  ).copyWith(
    colorScheme: ColorScheme.fromSwatch().copyWith(
        secondary: Color(0xFF003854)), // Secondary color (dark blue)
  );

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: Color(0xFF0F1D24),
    // Dark gradient background color
    useMaterial3: false,
    highlightColor: Color(0xFF0F1D24),
    appBarTheme: AppBarTheme(
      surfaceTintColor: Color(0xFF0F1D24), // Dark gradient color for AppBar
      color: Color(0xFF0F1D24),
      iconTheme: IconThemeData(color: Colors.white), // White icon color
      systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light),
    ),
    primaryColor: Color(0xFFDC1B1A),
    // Primary color (rot)
    dividerColor: Color(0xFF061A24).withOpacity(0.4),
    // Divider with body color
    primaryColorDark: Color(0xFFDC1B1A),
    textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.white),
    hoverColor: Colors.black12,
    fontFamily: GoogleFonts
        .plusJakartaSans()
        .fontFamily,
    bottomSheetTheme: BottomSheetThemeData(backgroundColor: Color(0xFF0F1D24)),
    // Dark gradient background
    primaryTextTheme: TextTheme(
      titleLarge: TextStyle(color: Colors.white), // White text
      labelSmall: TextStyle(color: Colors.white), // White small text
    ),
    cardTheme: CardTheme(color: Color(0xFF003854)),
    // Secondary color for card background
    cardColor: Color(0xFF003854),
    // Secondary color
    iconTheme: IconThemeData(color: Colors.white),
    // White icons
    textTheme: TextTheme(
      labelLarge: TextStyle(color: Color(0xFFFFE400)),
      // Yellow for large labels
      titleLarge: TextStyle(color: Colors.white),
      // White for large titles
      titleSmall: TextStyle(
          color: Colors.white54), // Light white text for small titles
    ),
    tabBarTheme: TabBarTheme(indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: Colors.white))),
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.all(
          Color(0xFFDC1B1A)), // Primary color for radio buttons
    ),
    colorScheme: ColorScheme.dark(primary: Color(0xFF0F1D24),
        onPrimary: Color(0xFF003854)) // Dark gradient and secondary colors
        .copyWith(secondary: Colors.white) // White for secondary elements
        .copyWith(error: Color(0xFFCF6676)), // Red error color
  ).copyWith(
    colorScheme: ColorScheme.fromSwatch().copyWith(
        secondary: Color(0xFFDC1B1A)), // Primary color for secondary elements
  );
}