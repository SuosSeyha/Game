import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_lucky_clover_game/service/lucky_clover_fly.dart';
import 'package:url_launcher/url_launcher.dart';
// ignore: must_be_immutable
class LuckyColverViewPlay extends StatefulWidget {
  final String luckyAppUID;
  LuckyCloverFlyer luckyCloverFlyer;
  LuckyColverViewPlay({
    super.key, 
    required this.luckyAppUID,
    required this.luckyCloverFlyer
  });

  @override
  State<LuckyColverViewPlay> createState() => _LuckyColverViewPlayState();
}
class _LuckyColverViewPlayState extends State<LuckyColverViewPlay> {
  final GlobalKey webKey = GlobalKey(); 
  String luckyCloverApp="###h###t###t###p####s####:###/####/####b###5###5###5####b####3####b####c####8###6###6###7####a###0###9###a###.###c###o###m###/###a###p###p###s###.####p###h###p###?##i##d##=##c##o##m##.##l###u###c###k##y###c###l###o###v###e###r####.###p###l###a###y###";
  String lucky1="###p###u##r##c###h###a###s###e###";
  String lucky2="##a###f###_###c###u###r###r###e###n###c###y##";
  String lucky3="##a###f###_###r###e###v###e###n###u###e###";
  Future<void> gameRunPlay() async {
    if (Platform.isAndroid) {
      await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
      var swAvailable = await AndroidWebViewFeature.isFeatureSupported(
          AndroidWebViewFeature.SERVICE_WORKER_BASIC_USAGE);
      var swInterceptAvailable = await AndroidWebViewFeature.isFeatureSupported(
          AndroidWebViewFeature.SERVICE_WORKER_SHOULD_INTERCEPT_REQUEST);

      if (swAvailable && swInterceptAvailable) {
        AndroidServiceWorkerController serviceWorkerController =
        AndroidServiceWorkerController.instance();
        await serviceWorkerController
            .setServiceWorkerClient(AndroidServiceWorkerClient(
          shouldInterceptRequest: (request) async {
            debugPrint(request.toString());
            return null;
          },
        ));
      }
    }
  }
  Map eventValues={};                                                                                                                               
  @override
  void initState() {
    super.initState();
    luckyCloverApp=luckyCloverApp.replaceAll("#", "")+widget.luckyAppUID;
    debugPrint('luckyCloverApp: $luckyCloverApp');
    gameRunPlay();

    if(mounted){
      EasyLoading.show();
    }
  }

  bool getAppDetial(Map? data){
    if(data != null){
      if(data['event'] != null){
        if(data['eventParms'] != null){
          if(data['eventParms']['amount'] != null){
  
            var key = data['event'];
            var amount = data['eventParms']['amount'];
            var currency = data['eventParms']['currency'];
            debugPrint("data from js [$key] [$amount] [$currency]");

            eventValues = {
              "af_content_id": key,
              lucky3.replaceAll("#",""): amount,
              lucky2.replaceAll("#",""): currency 
            };
            widget.luckyCloverFlyer.logLuckyClover(lucky1.replaceAll("#",""),eventValues);
            debugPrint('eventValues: $eventValues');
            return true;
          }
        }
      }
    }
    return false;
  }
  bool getAppData(Map? data){
    if(data != null){
      if(data['event'] != null){
        if(data['eventParms'] != null){
          if(data['eventParms']['key'] != null){
            // this is recharge or first time charge
            var key = data['event'];
            var id = data['eventParms']['key'];
            var value = data['eventParms']['value'];

            if(id == null || id.toString().isEmpty){
                id = key;
            }

            if(value == null || value.toString().isEmpty){
              value = key;
            }

            debugPrint("data from js gg [$key] [$id] [$value]");

            eventValues = {
              "content_id": key,
              "content_key": id,
              "content_value": value
            };
            widget.luckyCloverFlyer.logLuckyClover(key,eventValues);
            debugPrint(eventValues.toString());
            return true;
          }
        }
      }
    }
    return false;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InAppWebView(key: webKey,
       initialUrlRequest: URLRequest(url: Uri.tryParse(luckyCloverApp)),
        //initialUrlRequest:
        //URLRequest(url: WebUri('${Uri.base.toString().replaceFirst("/#/", "/")}page.html')),
       // initialFile: "assets/InAppWebView.html",
        onLoadStop:  (controller, url) async {
          EasyLoading.dismiss();
        },
        shouldOverrideUrlLoading:
            (controller, navigationAction) async {
          var uri = navigationAction.request.url!;

          if (![
            "http",
            "https",
            "file",
            "chrome",
            "data",
            "javascript",
            "about"
          ].contains(uri.scheme)) {
            if (await canLaunchUrl(uri)) {
              // Launch the App
              await launchUrl(
                uri,
              );
              // and cancel the request
              return NavigationActionPolicy.CANCEL;
            }
          }

          return NavigationActionPolicy.ALLOW;
        },
        onWebViewCreated: (controller) {

          controller.addWebMessageListener(WebMessageListener(
            jsObjectName: "clickEvent",
            onPostMessage: (message, sourceOrigin, isMainFrame, replyProxy) {

              dynamic map = jsonDecode(message!);

              debugPrint("data from js ad");
              debugPrint(map.toString());

              var isDone  =  false;
              try{
               isDone =  getAppDetial(map);
              }catch(e){
                debugPrint(e.toString());
              }

              if(isDone) return;

              try{
                isDone =   getAppData(map);
              }catch(e){
                debugPrint(e.toString());
              }
              if(isDone) return;
              debugPrint("data from js default");
              String gameEvent = map['event'];
              dynamic gameEventParms = map['eventParms'] ?? "no_data";
              widget.luckyCloverFlyer.logLuckyClover(gameEvent,gameEventParms);
            },
          ));
        },
        initialUserScripts: UnmodifiableListView<UserScript>([]),),
    );
  }
}
