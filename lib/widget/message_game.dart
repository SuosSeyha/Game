import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../style/mytext.dart';
messageGame({required String titleGame,required String messageGame}){
  Get.snackbar(
    '', '',
    titleText: myText2(
      text: titleGame, 
      fontSize: 30, 
      color: Colors.red, 
      fontWeight: FontWeight.bold
    ),
    messageText: myText2(
      text: messageGame, 
      fontSize: 18, 
      color: Colors.white, 
      fontWeight: FontWeight.w100
    ),
    backgroundColor: Colors.red,
    backgroundGradient: LinearGradient(
      colors: [
        Colors.red.withOpacity(0.5),
        Colors.amber.withOpacity(0.5)
      ]
    ),
    borderColor: Colors.white,
    borderWidth: 1,
    overlayBlur: 1
  );
}