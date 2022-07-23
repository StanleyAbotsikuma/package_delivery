import 'package:flutter/material.dart';

AppBarTheme appBarTheme(){
  return AppBarTheme(
    color: Colors.transparent,
    elevation: 0.0,
    actionsIconTheme: IconThemeData(color: Colors.black),
    iconTheme: IconThemeData(color: Colors.black)
  );
}

TextStyle headerstyle(){
  return TextStyle(
    color: Colors.black,
    fontSize: 25.0,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.3
  );
}

