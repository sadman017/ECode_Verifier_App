import 'package:ecode_verrifier/src/utils/theme/widget_themes/elevated_button_theme.dart';
import 'package:ecode_verrifier/src/utils/theme/widget_themes/outlined_button_theme.dart';
import 'package:ecode_verrifier/src/utils/theme/widget_themes/text_field_theme.dart';
import 'package:ecode_verrifier/src/utils/theme/widget_themes/text_theme.dart';
import 'package:flutter/material.dart';
class AppTheme{
  AppTheme._();
  static  ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    textTheme: TTextTheme.lightTextTheme,
    elevatedButtonTheme: TElevatedButtonTheme.lightElevatedButtonTheme,
    floatingActionButtonTheme: const FloatingActionButtonThemeData(),
    outlinedButtonTheme: TOutlinedButtonTheme.lightOutlinedButtonTheme,
    inputDecorationTheme: TTextFormFieldTheme.lightInputDecorationTheme,
    );
  static ThemeData darkTheme = ThemeData(brightness: Brightness.dark,
   textTheme: TTextTheme.darkTextTheme,
   elevatedButtonTheme: TElevatedButtonTheme.darkElevatedButtonTheme,
   floatingActionButtonTheme: const FloatingActionButtonThemeData(),
   outlinedButtonTheme: TOutlinedButtonTheme.darkOutlinedButtonTheme,
   inputDecorationTheme: TTextFormFieldTheme.darkInputDecorationTheme,
  );
}