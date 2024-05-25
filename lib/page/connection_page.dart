// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_lucky_clover_game/service/lucky_clover_fly.dart';
import 'package:flutter_lucky_clover_game/service/lucky_clover_viewplay.dart';
import 'lucky_clover_home.dart';
class ConnectionPage extends StatelessWidget {
  bool isState=false;
  String appFlyUID;
  LuckyCloverFlyer luckyCloverFlyer;
  ConnectionPage({
    super.key,
    required this.isState,
    required this.appFlyUID,
    required this.luckyCloverFlyer
  });
  @override
  Widget build(BuildContext context) {
    return isState?
    LuckyColverViewPlay(
      luckyAppUID: appFlyUID,
      luckyCloverFlyer: luckyCloverFlyer,):
    const LuckyCloverHome();
  }
}