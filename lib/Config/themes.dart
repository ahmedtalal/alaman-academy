// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:alaman/utils/styles.dart';

class Themes {
  static final light = ThemeData.light().copyWith(
    primaryColor: AppStyles.appThemeColor,
    scaffoldBackgroundColor: Colors.white,
    unselectedWidgetColor: Colors.black,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(AppStyles.appThemeColor),
        backgroundColor: MaterialStateProperty.all<Color>(AppStyles.appThemeColor),
      ),
    ),
    tabBarTheme: TabBarTheme(
      indicator: BoxDecoration(
        color: AppStyles.appThemeColor,
      ),
    ),
    iconTheme: IconThemeData(
      color: Color(0xff6A779A),
    ),
    shadowColor: Colors.grey.withOpacity(0.3),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
    ),
    cardTheme: CardTheme(color: Colors.white),
    textTheme: TextTheme(
      bodyText1: TextStyle(
        fontSize: 18.0,
        fontFamily: 'AvenirNext',
      ),
      headline1: TextStyle(
        fontSize: 72.0,
        fontWeight: FontWeight.bold,
      ),
      headline6: TextStyle(
        fontSize: 36.0,
        fontStyle: FontStyle.italic,
      ),
      bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'AvenirNext'),
      subtitle2: TextStyle(
        fontSize: 14.0,
        fontFamily: 'AvenirNext',
        color: Colors.black,
      ),
      subtitle1: TextStyle(
        fontSize: 16.0,
        fontFamily: 'AvenirNext',
        color: Colors.black,
      ),
      button: TextStyle(
        fontSize: 14.0,
        fontFamily: 'AvenirNext',
        color: Colors.black,
      ),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
  static final dark = ThemeData.dark().copyWith(
    primaryColor: AppStyles.appThemeColorDark,
    unselectedWidgetColor: Colors.black87,
    scaffoldBackgroundColor: Colors.black54,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(AppStyles.appThemeColorDark),
        backgroundColor: MaterialStateProperty.all<Color>(AppStyles.appThemeColorDark),
      ),
    ),
    shadowColor: Colors.transparent,
    cardTheme: CardTheme(color: Colors.black45),
    tabBarTheme: TabBarTheme(
      indicator: BoxDecoration(
        color: AppStyles.appThemeColorDark,
      ),
    ),
    iconTheme: IconThemeData(
      color: Color(0xff8E99B7),
    ),
    textTheme: TextTheme(
      subtitle2: TextStyle(
        fontSize: 14.0,
        fontFamily: 'AvenirNext',
      ),
      subtitle1: TextStyle(
        fontSize: 16.0,
        fontFamily: 'AvenirNext',
        color: Colors.white,
      ),
      button: TextStyle(
        fontSize: 14.0,
        fontFamily: 'AvenirNext',
        color: Colors.white,
      ),
      bodyText1: TextStyle(
        fontSize: 18.0,
        fontFamily: 'AvenirNext',
        color: Colors.white,
      ),
      headline1: TextStyle(
        fontSize: 72.0,
        fontWeight: FontWeight.bold,
      ),
      headline6: TextStyle(
        fontSize: 36.0,
        fontStyle: FontStyle.italic,
      ),
      bodyText2: TextStyle(
        fontSize: 14.0,
        fontFamily: 'AvenirNext',
      ),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}
