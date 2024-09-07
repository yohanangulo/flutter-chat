import 'package:flutter/material.dart';

class AppTheme {
  ThemeData get theme => ThemeData().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 63, 17, 177),
        ),
      );
}
