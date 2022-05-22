import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  //Put user's email to localstorage
  static Future setUserMail(
      {required SharedPreferences preferences, required String mail}) async {
    await preferences.setString("mail", mail);
  }

  //Get user's email
  static String? getUserEmail(SharedPreferences preferences) {
    return preferences.getString("mail");
  }

}
