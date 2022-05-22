import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInApi {
  static final _googleSignin = GoogleSignIn();

  static Future<GoogleSignInAccount?> googelLogin() => _googleSignin.signIn();
  static Future googleLogout() => _googleSignin.disconnect();
}
