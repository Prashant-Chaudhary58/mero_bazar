import 'package:flutter/material.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    fontFamily: 'lato Regular',
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: TextStyle(
          fontSize: 18,
          color:Colors.white,
          fontWeight: FontWeight.w500,
          fontFamily: "lato Regular"
        ),
        backgroundColor: Colors.green.shade700,
        // backgroundColor: Color(0xFFbbdb44), (to add hex color)
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
        )
      )
    ),
  );
}
