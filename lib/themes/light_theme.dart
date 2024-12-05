import 'package:flutter/material.dart';
import 'package:simple_note_app/app_assets.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    primaryContainer: AppAssets.lightBackgroundColor,
    secondaryContainer: AppAssets.lightTextColor,
    tertiaryContainer: AppAssets.lightCardColor
  )

);