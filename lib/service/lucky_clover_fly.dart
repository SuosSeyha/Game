import 'package:appsflyer_sdk/appsflyer_sdk.dart';
class LuckyCloverFlyer{
  late AppsflyerSdk afSDK ;
  Future <void> luckyCloverConfApp()async{
    AppsFlyerOptions appsFlyerOptions = AppsFlyerOptions(
      afDevKey: "6wN6gRfRqgxTxm7pYpXhwf",
      appId: "APP_ID",
      timeToWaitForATTUserAuthorization: 10.00
    );
    afSDK = AppsflyerSdk(appsFlyerOptions);
  }
  Future <void> luckyCloverInitApp()async{
    afSDK.initSdk(
      registerOnAppOpenAttributionCallback: true,
      registerOnDeepLinkingCallback: true,
      registerConversionDataCallback: true,
    );
 } 
  Future<bool?> logLuckyClover(String appEvent, Map<dynamic,dynamic> appValue){
   List<Map> map=[
    {1:'Green'},
    {2:'Red'},
    {3:'Yellow'},
    {4:'Gray'}
  ];
  map.insert(0, {99:'Blue'});
  return afSDK.logEvent(appEvent, appValue);
 }
}