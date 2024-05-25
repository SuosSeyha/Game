import 'package:shared_preferences/shared_preferences.dart';
class GameFunction{
  static const soundKey="sound";
  static const musickey="music";
  static const totalCoinkey="totalCoin";
  static const luckyKey="myLuckey";
  // Set Preference
  static Future<void> setLuckyCloverSound({required double soundGame})async{
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setDouble(soundKey, soundGame);
  }
  static Future<void> setLuckyCloverMusic({required double musicGame})async{
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setDouble(musickey, musicGame);
  }
  static Future<void> setTotalCoinGame({required double totalCoine})async{
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setDouble(totalCoinkey, totalCoine);
  }
  static Future<void> setGameRoute({required bool gameRoute})async{
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool(luckyKey, gameRoute);
  }
  // Get Preference
  static Future<double?> getLuckyCloverSound()async{
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getDouble(soundKey);
  }
  static Future<double?> getLuckyCloverMusic()async{
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getDouble(musickey);
  }
  static Future<double?> getTotalCoineGame()async{
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getDouble(totalCoinkey);
  }
  static Future<bool?> getGameRoute()async{
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(luckyKey);
  }

}