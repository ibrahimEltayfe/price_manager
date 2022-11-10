import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper{
  static late SharedPreferences sharedPref;

  static Future<void> init() async{
    sharedPref = await SharedPreferences.getInstance();
  }

  static Future<bool> saveUserToken({required String token}) async{
      return await sharedPref.setString('token', token);
  }

  static String? getUserToken() {
    return sharedPref.getString('token');
  }

  static Future<bool> deleteUserToken() async{
    return await sharedPref.remove('token');
  }

  static Future<bool> setPhoneVerifiedState({required bool verified}) async{
    return await sharedPref.setBool('phoneVerified', verified);
  }

  static bool getPhoneVerifiedState() {
    bool? state = sharedPref.getBool('phoneVerified');
    if(state == null){
      return false;
    }else{
      return state;
    }

  }



}