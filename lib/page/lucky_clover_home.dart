import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucky_clover_game/function/game_function.dart';
import 'package:flutter_lucky_clover_game/page/lucky_clover_page.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
class LuckyCloverHome extends StatefulWidget {
  const LuckyCloverHome({super.key});
  @override
  State<LuckyCloverHome> createState() => _LuckyCloverHomeState();
}

class _LuckyCloverHomeState extends State<LuckyCloverHome> with WidgetsBindingObserver{
  AudioPlayer musicPlayer = AudioPlayer();
  double musicGame=0;
  Future<void> appInit()async{
    // Get Music Game
    await GameFunction.getLuckyCloverMusic().then((music){
      if(music==null){
        GameFunction.setLuckyCloverMusic(musicGame: 100);
        musicGame=100;
      }else{
        musicGame=music;
      }
    });
    musicPlayer..play(AssetSource('music.mp3'),volume: musicGame/100)
    ..setReleaseMode(ReleaseMode.loop);
  }
  @override
  void initState() {
    appInit();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
    musicPlayer..stop()..setReleaseMode(ReleaseMode.stop);
    WidgetsBinding.instance.removeObserver(this);
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.paused){
      setState(() {
        musicPlayer..pause()..setReleaseMode(ReleaseMode.stop);
      });
    }
    if(state == AppLifecycleState.resumed){
      setState(() {
        musicPlayer..play(AssetSource('music.mp3'),volume: musicGame/100)
        ..setReleaseMode(ReleaseMode.loop);
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            'assets/images/BACKGROUND_.png',
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.fill,
          ),
          ZoomTapAnimation(
            onTap: () {
              Get.off(()=>const LuckyCloverPage());
            },
            child: Container(
              alignment: Alignment.center,
              height: 50,
              width: 230,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: const DecorationImage(
                  image: AssetImage(
                    'assets/images/START GAME.png'
                  ),
                  fit: BoxFit.fill
                ),
                boxShadow: const [
                  BoxShadow(
                    offset: Offset(1, 1),
                    color: Colors.black,
                    blurRadius: 5
                  )
                ]
              ),
              
            ),
          )
        ],
      ),
    );
  }
}