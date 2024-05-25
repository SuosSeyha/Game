import 'package:flutter/material.dart';
Widget myText1({
  required String text,
  required double fontSize,
  required MaterialColor color,
  required FontWeight fontWeight
}){
  return Text(
    text,
    style: TextStyle(
      fontFamily: 'gameFont',
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight
    ),
  ); 
}
Widget myText2({
  required String text,
  required double fontSize,
  required Color color,
  required FontWeight fontWeight
}){
  return Text(
    text,
    style: TextStyle(
      fontFamily: 'gameFont',
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight
    ),
  );
}