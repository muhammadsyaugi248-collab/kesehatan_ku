import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHandler {
  static const String isLogin = "isLogin";

  //Save data login pada saat login

  static saveLogin(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(isLogin, value);
  }

  // ambil data loho pasda saat mau login / ke dashboard
  static getLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isLogin);
  }

  // hapus data login saat logout
  static ramoveLogin() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(isLogin);
  }
}
