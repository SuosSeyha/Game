import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flip_card/controllers/flip_card_controllers.dart';
import 'package:flutter_lucky_clover_game/function/game_function.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import '../style/mytext.dart';
import '../widget/message_game.dart';
import '../widget/myflip.dart';
class LuckyCloverPage extends StatefulWidget {
  const LuckyCloverPage({super.key});
  @override
  State<LuckyCloverPage> createState() => _LuckyCloverPageState();
}
class _LuckyCloverPageState extends State<LuckyCloverPage>with WidgetsBindingObserver {
  AudioPlayer musicPlayer = AudioPlayer();
  AudioPlayer flipPlayer = AudioPlayer();
  AudioPlayer takeCoinePlayer= AudioPlayer();

  final controller0 = FlipCardController();
  final controller1 = FlipCardController();
  final controller2 = FlipCardController();
  final controller3 = FlipCardController();
  final controller4 = FlipCardController();
  final controller5 = FlipCardController();
  final controller6 = FlipCardController();
  final controller7 = FlipCardController();
  final controller8 = FlipCardController();
  List<FlipCardController> myFlipController=[];
  List<int> listFlip=[1,1,1,0,0,0,0,1,0];
  List<int> listTempFlip=[];
  List<int> listOpen=[0,0,0,0,0,0,0,0,0];
  List<int> listTakeCoin=[0,0,0,0,0,0,0,0,0];
  List<String> listSetting=['Sound','Rule'];
  int? settingGame=0;
  bool isTapPlay=false;
  bool isFindCoine=false;
  bool isTurnOffFlip=false;
  bool isQuestion=false;
  bool isVolume=false;
  double musicGame=0;
  double soundGame=0;
  int step=0;
  int betCount=0;
  bool isButtonLoding=false;
  double totalCoine=500;
  double winCoine=0;
  double betCoine=0;
  double coine=0;
  double gameMusic=0;
  double gameSound=0;
  void resetGame(){
    setState(() {
      GameFunction.setTotalCoinGame(totalCoine: 500);
      isTapPlay=false;
      isVolume=false;
      settingGame=0;
      betCoine=0;
      totalCoine=500;
      betCount=0;
    });
  }
  double subTotalCoin(){
    if(totalCoine>=1){
      coine=1;
      totalCoine--;
    }else{
      coine=0;
    }
  return coine;
  }
  void addCoineButton(){
    setState(() {
        isFindCoine=false;
        if(!isTapPlay){
          if(totalCoine>0){
          if(betCoine!=50){
            betCoine+=subTotalCoin();
            if(totalCoine<0){
              totalCoine+=betCoine;
            }
          }
        }else{
          betCoine=betCoine;
        }
        }
    });
  }
  double subBetCoine(){
    if(betCoine!=0){
      betCoine--;
      coine=1;
    }else{
      coine=0;
    }
    return coine;
  }
  void addTotalCoinButton(){ // 
    setState(() {
      isFindCoine=false;
      if(!isTapPlay){
        totalCoine+=subBetCoine();
      }
    });
  }
  void maxBetButton(){
    setState(() {
      isFindCoine=false;
      if(!isTapPlay){
        if(totalCoine>=50){
          totalCoine+=betCoine;
          totalCoine-=50;
          betCoine=50;
        }
      }
    });
  }
  void minBetButton(){
    setState(() { 
      isTapPlay=false;
      if(!isTapPlay){
        if(totalCoine>=1){
          totalCoine+=betCoine;
          betCoine=1;
          totalCoine--;
        }
      }
    });
  }
  Future<void> tapPlayAction()async{
    
    if(isTurnOffFlip){
      for(int i=0;i<myFlipController.length;i++){
        myFlipController[i].flipcard();
      }
    }
    for(int i=0;i<myFlipController.length;i++){
      if(listOpen[i]==0){
        
      }else{
        myFlipController[i].flipcard();
      }
    }
    for(int i=0;i<myFlipController.length;i++){
      listOpen[i]=0;
    }
  }
  void tapPlayButton(){ 
    setState(() {
        if(betCoine>=1){ 
          isButtonLoding=true;
          tapPlayAction();
          // Clear
          Future.delayed(const Duration(milliseconds: 500)).then((value){
          setState(() {
            listFlip.shuffle();
            debugPrint(' ListFlip : $listFlip');
            isTapPlay=true;
            isTurnOffFlip=false;
            isButtonLoding=false;
          });
      });
      }else{
        if(totalCoine<1 && betCoine==0){
            //show message not enought to play
          debugPrint(' You have not money to play game...!');
          messageGame(
            titleGame: 'Erorr',
            messageGame: 'You have not money to play game...!'
          );
        }
        if(betCoine==0 && totalCoine>=1){
          messageGame(
            titleGame: 'Erorr',
            messageGame: 'Please put money to play...!'
          );
        }
      }
    });
  }
  void takeCoine(){
    if(step==0){
      winCoine=0;
    }
    if(step==1){
      winCoine=betCoine*2;
    }
    if(step==2){
      winCoine=betCoine*5;
    }
    if(step==3){
      winCoine=betCoine*15;
    }
    if(step==4){
      winCoine=betCoine*118;
    }
    debugPrint(' WinCoine : $winCoine');
  }
  void takeTotalCoine(){
    setState(() {
      totalCoine+=winCoine;
      // Set Total Preference
      GameFunction.setTotalCoinGame(totalCoine: totalCoine);
      takeCoinePlayer.play(AssetSource('coine.mp3'),volume: soundGame/100);
      winCoine=0;
      isTurnOffFlip=true;
      for(int i=0;i<myFlipController.length;i++){
        if(listOpen[i]==1){
          
        }else{
          myFlipController[i].flipcard();
        }
      }
     for(int i=0;i<myFlipController.length;i++){
      listOpen[i]=0;
     }
     isTapPlay=false;
     betCoine=0;
     step=0;
     isFindCoine=false;
    });
  }
  Future<void> gameInit()async{
    await GameFunction.getTotalCoineGame().then((total){
      setState(() {
        if(total==null){
          GameFunction.setTotalCoinGame(totalCoine: 500);
          totalCoine=500;
        }else{
          totalCoine=total;
        }
      });
    });
    await GameFunction.getLuckyCloverSound().then((sound){
      setState(() {
        if(sound==null){
          GameFunction.setLuckyCloverSound(soundGame: 100);
          soundGame=100;
        }else{
          soundGame=sound;
        }
      });
    });
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
    gameInit();
    WidgetsBinding.instance.addObserver(this);
    myFlipController=[
      controller0,
      controller1,
      controller2,
      controller3,
      controller4,
      controller5,
      controller6,
      controller7,
      controller8,
    ];
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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp
    ]);
    final mediaQuery = MediaQuery.of(context).size;
    return  Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Image.asset(
            'assets/images/BACKGROUND_.png',
            height: mediaQuery.height,
            width: mediaQuery.width,
            fit: BoxFit.cover,
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 600,
                width: mediaQuery.width,
                //color: Colors.red.withOpacity(0.3),
              ),
              Positioned(
                top: 80,
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  width: 340,
                  decoration:  BoxDecoration(
                    //color: Colors.amber,
                    borderRadius: BorderRadius.circular(10),
                    image: const DecorationImage(
                      image: AssetImage(
                        'assets/images/Lucky Clover Game.png'
                      ),
                      fit: BoxFit.cover
                    )
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 50
                ),
                child: Stack(
                  children: [
                    const SizedBox(
                      height: 630,
                      width: 350,
                      //color: Colors.amber,
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        const SizedBox(
                          height: 650,
                          width: 350,
                          //color: Colors.amber,
                        ),
                        Positioned(
                          top: 88,
                          child: Container(
                            alignment: Alignment.center,
                            height: 540,
                            width: 410,
                            decoration: const BoxDecoration(
                            //color: Colors.red.withOpacity(0.5),
                            image:  DecorationImage(
                                image: AssetImage(
                                  'assets/images/bar for iteam.png'
                                ),
                                fit: BoxFit.fill
                              )),
                          ),
                        ),
                        Positioned(
                          top: 155,
                          left: 16,
                          child: Container(
                            alignment: Alignment.topCenter,
                            height: 320,
                            width: 320,
                            decoration: const BoxDecoration(
                             // color: Colors.amber
                            ),
                            child: Wrap(
                              children: [
                                ...List.generate(
                                  9, (index){
                                    return ZoomTapAnimation(
                                  onTap: () {
                                    setState(() {
                                      flipPlayer.play(AssetSource('flipcard.mp3'),volume: soundGame/100);
                                      if(betCoine>=1 && isTapPlay){
                                        isFindCoine=true;
                                      if(listOpen[index]==0){
                                        step++;
                                        listOpen[index]=1;
                                        myFlipController[index].flipcard();
                                      }else{
                                        
                                      }
                                      if(listFlip[index]==0){
                                        for(int i=0;i<myFlipController.length;i++){
                                          if(listOpen[i]==1){
                                            
                                          }else{
                                            isTapPlay=false;
                                            myFlipController[i].flipcard();
                                            listOpen[i]=1;
                                            betCoine=0;
                                            step=0;
                                            isFindCoine=false;
                                            GameFunction.setTotalCoinGame(totalCoine: totalCoine);
                                          }
                                        }
                                      }else{
                                        
                                      }
                                      takeCoine();
                                      debugPrint(' Step: $step');
                                      }else{
                                        debugPrint(' Please bet the coine to play....!');
                                      }
                                    });
                                  },
                                  child: betCoine>=1 && isTapPlay?MyFlip(
                                    controller: myFlipController[index],
                                    isFlip: listFlip[index]==1?true:false,
                                  ):MyFlip(
                                    controller: myFlipController[index],
                                    isFlip: listFlip[index]==1?true:false,
                                  )
                                ); 
                                  }
                                )
                              ],
                            ),
                          ),
                        ),
                        // Button Play
                        Positioned(
                          top: 485,
                          child: ZoomTapAnimation(
                            onTap: () { //isTapPlay && !isFindCoine
                              Future.delayed(const Duration(milliseconds: 500)).then((_){
                                isTapPlay && isFindCoine?takeTotalCoine():tapPlayButton();
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 43,
                              width: 320,
                              decoration:  BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                 image: const DecorationImage(
                                  image: AssetImage(
                                    'assets/images/button for min max.png'
                                  ),
                                  fit: BoxFit.fill
                                )
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  isButtonLoding && betCoine>=1?const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 20),
                                    child: CircularProgressIndicator(
                                      backgroundColor: Colors.amber,
                                      valueColor: AlwaysStoppedAnimation(Colors.white),
                                    ),
                                  ):const Text(''),
                                  myText2(
                                    text: isTapPlay && isFindCoine?'Take Coine: $winCoine\$':
                                    isTapPlay && !isFindCoine?'let\'s flip...':
                                    'P L A Y ', 
                                    fontSize: 25, 
                                    color: Colors.white, 
                                    fontWeight: FontWeight.bold
                                  ),
                                ],
                              ),
                              
                            )
                          ),
                        ),
                        // Button Bet
                        Positioned(
                          top: 540,
                          child: Container(
                            alignment: Alignment.center,
                            height: 43,
                            width: 320,
                            decoration:  BoxDecoration(
                              //color: Colors.amber.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(10),
                              image: const DecorationImage(
                                image: AssetImage(
                                  'assets/images/button for min max.png'
                                ),
                                fit: BoxFit.cover
                              )
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 3
                              ),
                              child: Row(
                                children: [
                                  ZoomTapAnimation(
                                    onTap: () {
                                      minBetButton();
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 43,
                                      width: 35,
                                      decoration:  BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: const DecorationImage(
                                          image: AssetImage(
                                            'assets/images/min.png'
                                          ),
                                          fit: BoxFit.fill
                                        )
                                      ),
                                      
                                    ),
                                  ),
                                  ZoomTapAnimation(
                                    onTap: () {
                                      addTotalCoinButton();
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                        left: 5
                                      ),
                                      alignment: Alignment.center,
                                      height: 43,
                                      width: 35,
                                      decoration:  BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: const DecorationImage(
                                          image: AssetImage(
                                            'assets/images/button -.png'
                                          ),
                                          fit: BoxFit.fill
                                        )
                                      ),
                                      child: const Icon(
                                        Icons.remove,
                                        size: 30,
                                        color: Colors.white,
                                      )
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: myText2(
                                        text: '$betCoine \$', 
                                        fontSize: 25, 
                                        color: Colors.white, 
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),
                                  ZoomTapAnimation(
                                    onTap: () {
                                      addCoineButton();
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 43,
                                      width: 35,
                                      decoration:  BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: const DecorationImage(
                                          image: AssetImage(
                                            'assets/images/button +.png'
                                          ),
                                          fit: BoxFit.fill
                                        )
                                      ),
                                    ),
                                  ),
                                  ZoomTapAnimation(
                                    onTap: () {
                                      maxBetButton();
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                        left: 5
                                      ),
                                      alignment: Alignment.center,
                                      height: 43,
                                      width: 35,
                                      decoration:  BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: const DecorationImage(
                                          image: AssetImage(
                                            'assets/images/max.png'
                                          ),
                                          fit: BoxFit.fill
                                        )
                                      ),
                                    ),
                                  ),
                                  
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                        top: 90,
                        left: 0,
                        child: ZoomTapAnimation(
                          onTap: () {
                            setState(() {
                              resetGame();
                            });
                          },
                          child: Image.asset(
                            'assets/images/back.png',
                            height: 43,
                            width: 43,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Positioned(
                          top: 90,
                          right: 70,
                          child: ZoomTapAnimation(
                            onTap: () {
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 43,
                              width: 210,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                    'assets/images/Button.png'
                                  ),
                                  fit: BoxFit.cover
                                )
                              ),
                              child: FittedBox(
                                child: myText2(
                                  text: '${totalCoine.toStringAsFixed(2)} \$', 
                                  fontSize: 25, 
                                  color: Colors.white, 
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            )
                          ),
                        ),
                          Positioned(
                          top: 90,
                          right: 0,
                          child: ZoomTapAnimation(
                            onTap: () {
                              setState(() {
                                isVolume=true;
                              });
                            },
                            child: Image.asset(
                              'assets/images/setting.png',
                              height: 43,
                              width: 43,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                  ],
                ),
              )
            ],
          ),
          // Question
          isVolume?Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: mediaQuery.height,
                width: mediaQuery.width,
                color: Colors.black.withOpacity(0.4),
              ),
              Container(
                alignment: Alignment.topRight,
                height: 300,
                width: 300,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/images/Artboard 1.png'
                    ),
                    fit: BoxFit.fill
                  )
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const SizedBox(
                      height: 300,
                      width: 300,
                      //color: Colors.amber,
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: ZoomTapAnimation(
                        onTap: () {
                          setState(() {
                            isVolume=false;
                          });
                        },
                        child: Image.asset(
                          'assets/images/button X.png',
                          height: 32,
                          width: 32,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 25,
                      child: myText2(
                        text: 'GAME SETTINGS', 
                        fontSize: 33, 
                        color: Colors.amber, 
                        fontWeight: FontWeight.bold
                        ),
                    ),
                    // Setting Max
                    Positioned(
                      top: 80,
                      child: SizedBox(
                        height: 30,
                        width: 150,
                        //color: Colors.amber,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ...List.generate(2, (index){
                              return ZoomTapAnimation(
                                onTap: () {
                                  setState(() {
                                    settingGame=index;
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(3),
                                  alignment: Alignment.center,
                                 // height: 40,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: settingGame==index?Colors.amber:
                                    settingGame!=index?Colors.black.withOpacity(0.5):
                                    Colors.black.withOpacity(0.5),
                                  ),
                                  child: myText2(
                                    text: listSetting[index], 
                                    fontSize: 15, 
                                    color: Colors.white, 
                                    fontWeight: settingGame==index?FontWeight.bold:
                                    settingGame!=index?FontWeight.normal:
                                    FontWeight.normal,
                                  ),
                                ),
                              );
                            })
                          ],
                        ),
                      ),
                    ),
                    //=============
                    settingGame==0?Positioned(
                      top: 120,
                      child: Container(
                        alignment: Alignment.topCenter,
                        height: 150,
                        width: 300,
                        //color: Colors.red,
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: [
                              Positioned(
                                top: 20,
                                child: SizedBox(
                                  height: 50,
                                  width: 250,
                                  //color: Colors.amber,
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          myText1(
                                            text: 'MUSIC', 
                                            fontSize: 20, 
                                            color: Colors.amber, 
                                            fontWeight: FontWeight.bold
                                          ),
                                          myText1(
                                            text: '${musicGame.toInt()}%', 
                                            fontSize: 20, 
                                            color: Colors.amber, 
                                            fontWeight: FontWeight.bold
                                            )
                                        ],
                                      ),
                                      SizedBox(
                                        width: 300,
                                        height: 20,
                                        child: Slider(
                                          value: musicGame, 
                                          min: 0,
                                          max: 100,
                                          activeColor: Colors.amber,
                                          onChanged: (value) {
                                            setState(() {
                                              musicGame=value;
                                              GameFunction.setLuckyCloverMusic(musicGame: musicGame);
                                              GameFunction.getLuckyCloverMusic().then((music){
                                                setState(() {
                                                  musicGame=music!;
                                                  musicPlayer.setVolume(musicGame/100);
                                                });
                                              });
                                            });
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ),
                              Positioned(
                                top: 80,
                                child: SizedBox(
                                  height: 50,
                                  width: 250,
                                  //color: Colors.amber,
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          myText1(
                                            text: 'SOUND', 
                                            fontSize: 20, 
                                            color: Colors.amber, 
                                            fontWeight: FontWeight.bold
                                          ),
                                          myText1(
                                            text: '${soundGame.toInt()}%', 
                                            fontSize: 20, 
                                            color: Colors.amber, 
                                            fontWeight: FontWeight.bold
                                            )
                                        ],
                                      ),
                                      SizedBox(
                                        width: 300,
                                        height: 20,
                                        child: Slider(
                                          value: soundGame, 
                                          min: 0,
                                          max: 100,
                                          activeColor: Colors.amber,
                                          onChanged: (value) {
                                            setState(() {
                                              soundGame=value;
                                              GameFunction.setLuckyCloverSound(soundGame: soundGame);
                                              GameFunction.getLuckyCloverSound().then((sound){
                                                setState(() {
                                                  soundGame=sound!;
                                                  takeCoinePlayer.setVolume(soundGame);
                                                  flipPlayer.setVolume(soundGame);
                                                });
                                              });
                                            });
                                          },
                                        ),
                                      )
                                      //===================
                                    ],
                                  ),
                                )
                              ),
                    
                          ],
                        ),
                      ),
                    ):Positioned(
                      top: 120,
                      child: Container(
                        alignment: Alignment.topCenter,
                        height: 150,
                        width: 300,
                        //color: Colors.red,
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            const SizedBox(
                              height: 300,
                              width: 300,
                              //color: Colors.black,
                            ),
                            Positioned(
                              top: 5,
                              child: SizedBox(
                                height: 50,
                                width: 250,
                                //color: Colors.amber,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    ...List.generate(1, (index){
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 3
                                        ),
                                        child: Image.asset(
                                          'assets/images/gold-1.png',
                                          height: 30,
                                          width: 30,
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    }),
                                    myText1(
                                      text: 'X 2', 
                                      fontSize: 25, 
                                      color: Colors.amber, 
                                      fontWeight: FontWeight.bold
                                      )
                                  ],
                                ),
                              )
                            ),
                            Positioned(
                              top: 40,
                              child: SizedBox(
                                height: 50,
                                width: 250,
                                //color: Colors.amber,
                                child: Row(
                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    ...List.generate(2, (index){
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 3
                                        ),
                                        child: Image.asset(
                                          'assets/images/gold-1.png',
                                          height: 30,
                                          width: 30,
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    }),
                                    const Spacer(),
                                    myText1(
                                      text: 'X 5', 
                                      fontSize: 25, 
                                      color: Colors.amber, 
                                      fontWeight: FontWeight.bold
                                      )
                                  ],
                                ),
                              )
                            ),
                            Positioned(
                              top: 75,
                              child: SizedBox(
                                height: 50,
                                width: 250,
                                //color: Colors.amber,
                                child: Row(
                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    ...List.generate(3, (index){
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 3
                                        ),
                                        child: Image.asset(
                                          'assets/images/gold-1.png',
                                          height: 30,
                                          width: 30,
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    }),
                                    const Spacer(),
                                    myText1(
                                      text: 'X 15', 
                                      fontSize: 25, 
                                      color: Colors.amber, 
                                      fontWeight: FontWeight.bold
                                      )
                                  ],
                                ),
                              )
                            ),
                            Positioned(
                              top: 110,
                              child: SizedBox(
                                height: 50,
                                width: 250,
                                //color: Colors.amber,
                                child: Row(
                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    ...List.generate(4, (index){
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 3
                                        ),
                                        child: Image.asset(
                                          'assets/images/gold-1.png',
                                          height: 30,
                                          width: 30,
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    }),
                                    const Spacer(),
                                    myText1(
                                      text: 'X 118', 
                                      fontSize: 25, 
                                      color: Colors.amber, 
                                      fontWeight: FontWeight.bold
                                      )
                                  ],
                                ),
                              )
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ):const Text(''),
        ],
      ),
    );
  }
}