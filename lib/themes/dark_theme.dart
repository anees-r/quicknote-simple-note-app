import 'package:flutter/material.dart';
import 'package:simple_note_app/app_assets.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    primaryContainer: AppAssets.darkBackgroundColor,
    secondaryContainer: AppAssets.darkTextColor,
    tertiaryContainer: AppAssets.darkCardColor
  )
);