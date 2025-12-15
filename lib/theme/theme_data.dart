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
    inputDecorationTheme: InputDecorationThemeData(
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          width: 2,
          color:Colors.green
        ),

      ),
    
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          width: 2,
          color: const Color.fromARGB(255, 66, 58, 219)
        )
    ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          width: 2,
          color: Colors.blueGrey,
        ),
        )),
  );
}
