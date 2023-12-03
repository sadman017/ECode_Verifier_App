import 'package:ecode_verrifier/src/constants/colors.dart';
import 'package:ecode_verrifier/src/constants/size.dart';
import 'package:flutter/material.dart';

class TElevatedButtonTheme{
  TElevatedButtonTheme._();

  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      shape:const RoundedRectangleBorder(),
      foregroundColor: whiteColor,
      backgroundColor: secondaryColor,
      side: const BorderSide( color: secondaryColor),
      padding: const EdgeInsets.symmetric(vertical: buttonHeight),
    )
  );

  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      shape:const RoundedRectangleBorder(),
      foregroundColor: secondaryColor,
      backgroundColor: whiteColor,
      side: const BorderSide( color: whiteColor),
      padding: const EdgeInsets.symmetric(vertical: buttonHeight),
    )
  );
}