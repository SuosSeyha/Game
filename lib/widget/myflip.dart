import 'package:flutter/material.dart';
import 'package:flutter_flip_card/controllers/flip_card_controllers.dart';
import 'package:flutter_flip_card/flipcard/flip_card.dart';
import 'package:flutter_flip_card/modal/flip_side.dart';
// ignore: must_be_immutable
class MyFlip extends StatefulWidget {
    bool isFlip=false;
   final FlipCardController controller;
   MyFlip({
    super.key,
    required this.controller,
    required this.isFlip,
    });

  @override
  State<MyFlip> createState() => _MyFlipState();
}
class _MyFlipState extends State<MyFlip> {
  
  int count=0;
  @override
  Widget build(BuildContext context) {
      return Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 1,
          vertical: 1
        ),
        alignment: Alignment.center,
        height: 100,
        width: 100,
       // color: Colors.red,
        child: FlipCard(
        rotateSide: RotateSide.bottom,
        onTapFlipping: false, //When enabled, the card will flip automatically when touched.
        axis: FlipAxis.vertical,
        controller: widget.controller,
        frontWidget: Center(
        child: Container(
            decoration: const BoxDecoration(
              //color: Colors.red,
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/button_.png'
                ),
                fit: BoxFit.fill
              )
            ),
          )
        ),
        backWidget: Container(
            decoration:  BoxDecoration(
              //color: Colors.red,
              image: DecorationImage(
                image: AssetImage(
                  widget.isFlip?'assets/images/Treasure.png'
                  :'assets/images/boom.png'
                ),
                fit: BoxFit.fill
              )
            ),
          )
        ),
      );
    //);
  }
}