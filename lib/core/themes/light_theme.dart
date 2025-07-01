import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightTheme = ThemeData(
  textTheme: GoogleFonts.poppinsTextTheme(),
  colorScheme: ColorScheme.light(
    surface: Colors.grey.shade200,
    primary: Colors.deepPurple,
    secondary: Colors.grey.shade700,
    tertiary: Colors.grey.shade100,
    inversePrimary: Colors.grey.shade900,
  ),
  scaffoldBackgroundColor: Colors.white,
);  
