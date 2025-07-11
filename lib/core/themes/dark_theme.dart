import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData darkTheme = ThemeData(
  textTheme: GoogleFonts.poppinsTextTheme().apply(bodyColor: Colors.white),
  colorScheme: const ColorScheme.dark(
    surface: Color.fromARGB(255, 20, 20, 20),
    primary: Color.fromARGB(255, 144, 107, 255),   
    secondary: Colors.white70,                     
    tertiary: Color.fromARGB(255, 34, 34, 34),   
    inversePrimary: Color.fromARGB(255, 255, 255, 255),            
  ),
  scaffoldBackgroundColor: Color.fromARGB(255, 12, 12, 12),
  appBarTheme: AppBarTheme(
    backgroundColor: Color.fromARGB(255, 18, 18, 18), 
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: GoogleFonts.poppins(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ), 
  ),
  cardColor: Color.fromARGB(255, 30, 30, 30),
);