import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucky_clover_game/function/game_function.dart';
import 'package:flutter_lucky_clover_game/page/connection_page.dart';
import 'package:flutter_lucky_clover_game/service/lucky_clover_fly.dart';
import 'package:flutter_lucky_clover_game/style/mytext.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import 'lucky_clover_home.dart';
class LuckyCloverSplash extends StatefulWidget {
  const LuckyCloverSplash({super.key});
    @override
    State<LuckyCloverSplash> createState() => _LuckyCloverSplashState();
  }
class _LuckyCloverSplashState extends State<LuckyCloverSplash> {
  LuckyCloverFlyer luckyCloverFlyer = LuckyCloverFlyer();
  String luckeyCloverLanguage='';
  String appStatus='';
  String appFlyUID='&appsflyerid=';
  //bool isState=false;
  Future<bool> isNetwork()async{
    bool isInternet;
    var connectivityResult = await Connectivity().checkConnectivity();
     if(connectivityResult==ConnectivityResult.none){
      isInternet=false;
     }else{
      isInternet=true;
     }
     return isInternet;  
  }
  Future<void> gameConnection()async{
   await isNetwork().then((value){
      if(value==false){
        setState(() {
        Future.delayed(const Duration(seconds: 3)).then((value){
          Get.off(()=> ConnectionPage(isState: false, appFlyUID: "",luckyCloverFlyer: luckyCloverFlyer,));
        });
      });
      }else{
        GameFunction.getGameRoute().then((game){
          setState(() {
            if(game==null){
              gamePlay1();
            }
            if(game==true){
              gamePlay2();
            }
          });
        });
      }
    });
  }
  void gamePlay1(){
    luckeyCloverLanguage = Platform.localeName.substring(0,2);
    luckyCloverFlyer.luckyCloverConfApp();
    luckyCloverFlyer.luckyCloverInitApp();
    luckyCloverFlyer.afSDK.onInstallConversionData((userInstall){
      appStatus=userInstall['payload']['af_status'];
      if(appStatus=="Non-organic"){
        if(luckeyCloverLanguage=="vi"){
          GameFunction.setGameRoute(gameRoute: true);
          luckyCloverFlyer.afSDK.getAppsFlyerUID().then((value){
            setState(() {
              appFlyUID+=value!;
              Get.off(()=> ConnectionPage(isState: true, appFlyUID: appFlyUID,luckyCloverFlyer: luckyCloverFlyer,));
            });
          });
        }else{
          Get.off(()=> ConnectionPage(isState: false, appFlyUID: "",luckyCloverFlyer: luckyCloverFlyer,));
        }
      }

      if(appStatus=="Organic"){
        Get.off(()=> ConnectionPage(isState: false, appFlyUID: "",luckyCloverFlyer: luckyCloverFlyer,));
      }
    });
  }
  void gamePlay2(){
    luckyCloverFlyer.luckyCloverConfApp();
    luckyCloverFlyer.luckyCloverInitApp();
    luckyCloverFlyer.afSDK.onInstallConversionData((userInstall){
      appStatus=userInstall['payload']['af_status'];
        luckyCloverFlyer.afSDK.getAppsFlyerUID().then((value){
          setState(() {
            appFlyUID+=value!;
            Get.off(()=> ConnectionPage(isState: true, appFlyUID: appFlyUID,luckyCloverFlyer: luckyCloverFlyer,));
          });
        });
    });
  }
 
  @override
  void initState() {
   // gameConnection();
   Future.delayed(const Duration(seconds: 5)).then((value){
    return Get.off(()=> const LuckyCloverHome());
   });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 280,
              width: 280,
              child: Lottie.asset(
                'assets/reveal-loading.json',
              ),
            ),
            myText2(
              text: 'Loading...', 
              fontSize: 20, 
              color: Colors.white, 
              fontWeight: FontWeight.bold
            )
          ],
        ),
      ),
    );
  }
}