import 'package:ecode_verrifier/src/constants/colors.dart';
import 'package:ecode_verrifier/src/constants/size.dart';
import 'package:flutter/material.dart';

class TOutlinedButtonTheme{
  TOutlinedButtonTheme._();

  static final lightOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
                    shape: const RoundedRectangleBorder(),
                    foregroundColor: secondaryColor,
                    side: const BorderSide(color: secondaryColor),
                    padding: const EdgeInsets.symmetric(vertical: buttonHeight),
                  ),
  );

  static final darkOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
                    shape: const RoundedRectangleBorder(),
                    foregroundColor: whiteColor,
                    side: const BorderSide(color: whiteColor),
                    padding: const EdgeInsets.symmetric(vertical: buttonHeight),
                  ),
  );
}