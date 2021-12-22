
import 'package:shared_preferences/shared_preferences.dart';

class Singleton {
  Singleton._();

  static SharedPreferences _pref;
  static String apiPath="http://192.168.1.3:8000/api";

  static Future<SharedPreferences> getPrefInstace() async {
    if (_pref == null) {
      _pref = await SharedPreferences.getInstance();
    }
    return _pref;
  }

}