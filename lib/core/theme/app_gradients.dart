import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppGradients {
  static final mainGradient = LinearGradient(
    colors: [AppColorsDark.primary, AppColorsDark.accent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
