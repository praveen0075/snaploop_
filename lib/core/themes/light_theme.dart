import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightTheme = ThemeData(
  textTheme: GoogleFonts.poppinsTextTheme(),
  colorScheme: ColorScheme.light(
    surface: Colors.white,
    primary: Color.fromARGB(238, 104, 58, 183),    
    secondary: Colors.grey,  
    tertiary: Color.fromARGB(33, 179, 166, 216),     
    inversePrimary: Colors.grey.shade800,            
  ),
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white,
    iconTheme: IconThemeData(color: Colors.black),
    titleTextStyle: GoogleFonts.poppins(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
  ),
  cardColor: Colors.white,
);