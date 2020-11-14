part of 'theme_cubit.dart';

@immutable
abstract class ThemeState {
  /// Custom page transitions
  static final _pageTransitionsTheme = PageTransitionsTheme(
    builders: const {
      TargetPlatform.android: ZoomPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    },
  );

  ThemeData get themeData;
}

class LightTheme extends ThemeState {
  @override
  ThemeData get themeData => ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.deepOrange,
        // primaryColor: lightPrimaryColor,
        // accentColor: lightAccentColor,
        pageTransitionsTheme: ThemeState._pageTransitionsTheme,
        textTheme: GoogleFonts.rubikTextTheme(ThemeData.light().textTheme),
        popupMenuTheme: PopupMenuThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      );
}

class DarkTheme extends ThemeState {
  @override
  ThemeData get themeData => ThemeData(
        brightness: Brightness.dark,
        primaryColor: darkPrimaryColor,
        accentColor: darkAccentColor,
        canvasColor: darkCanvasColor,
        scaffoldBackgroundColor: darkBackgroundColor,
        cardColor: darkCardColor,
        dividerColor: darkDividerColor,
        dialogBackgroundColor: darkCardColor,
        pageTransitionsTheme: ThemeState._pageTransitionsTheme,
        textTheme: GoogleFonts.rubikTextTheme(ThemeData.dark().textTheme),
        popupMenuTheme: PopupMenuThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      );
}

class BlackTheme extends ThemeState {
  @override
  ThemeData get themeData => ThemeData(
        brightness: Brightness.dark,
        primaryColor: blackPrimaryColor,
        accentColor: blackAccentColor,
        canvasColor: blackPrimaryColor,
        scaffoldBackgroundColor: blackPrimaryColor,
        cardColor: blackPrimaryColor,
        dividerColor: darkDividerColor,
        dialogBackgroundColor: darkCardColor,
        pageTransitionsTheme: ThemeState._pageTransitionsTheme,
        textTheme: GoogleFonts.rubikTextTheme(ThemeData.dark().textTheme),
        popupMenuTheme: PopupMenuThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
            side: BorderSide(color: darkDividerColor),
          ),
        ),
      );
}

class SystemTheme extends LightTheme {}
