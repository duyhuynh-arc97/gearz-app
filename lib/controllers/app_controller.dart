import 'dart:convert';

import 'package:email_auth/email_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:dbcrypt/dbcrypt.dart';
import 'package:flutter/material.dart';
import 'package:itproject_gadget_store/models/user.dart';
import 'package:itproject_gadget_store/widgets/alert_dialogs.dart';
import 'package:http/http.dart' as http;

//Convert hexcolor to int
int hexColor(String a) {
  String newcolor = '0xff' + a;
  newcolor = newcolor.replaceAll('#', '');
  return int.parse(newcolor);
}

//Checking account when logging in
Future<int> login(String mail, String pwd) async {
  DBCrypt dBCrypt = DBCrypt();
  int check = 0;

  var response = await http.post(
      Uri.parse(
          "https://gearz-gadget.000webhostapp.com/user_controllers/signin.php"),
      body: {"email": mail});
  var jsonData = jsonDecode(response.body);

  if (jsonData != "not found") {
    User u = User.fromJson(jsonData);

    if (!dBCrypt.checkpw(pwd, u.password)) {
      check = 0;
    } else {
      check = 1;
    }
  } else {
    check = 0;
  }

  return check;
}

//Continue with social media accounts
Future continueWithSMAccount(
    {required String mail,
    required String imgUrl,
    required String name,
    required String type}) async {
  var response = await http.post(
      Uri.parse(
          "https://gearz-gadget.000webhostapp.com/user_controllers/continue_with_sm.php"),
      body: {
        "mail": mail,
        "imgUrl": imgUrl,
        "type": type,
        "name": name,
        "time": DateTime.now().toString()
      });
  var jsonData = jsonDecode(response.body);

  return jsonData;
}

//Checking account when signing up
Future<void> signup(
    {required String name,
    required String mail,
    required String password,
    required String type,
    required String imgUrl}) async {
  DBCrypt dbCrypt = DBCrypt();
  String salt = dbCrypt.gensaltWithRounds(10);
  String hashPwd = dbCrypt.hashpw(password, salt);
  var now = DateTime.now();

  var response = await http.post(
      Uri.parse(
          "https://gearz-gadget.000webhostapp.com/user_controllers/signup.php"),
      body: {
        "full_name": name,
        "email": mail,
        "password": hashPwd,
        "type": type,
        "imgUrl": imgUrl,
        "created_time": now.toString()
      });
  var jsonData = jsonDecode(response.body);

  print(jsonData);
}

//Animation for alert dialog
class Animations {
  static shrink(Animation<double> _animation,
      Animation<double> _secondaryAnimation, Widget _child) {
    return ScaleTransition(
      child: _child,
      scale: Tween<double>(end: 1, begin: 0.01).animate(CurvedAnimation(
          parent: _animation, curve: Interval(0.0, 1.0, curve: Curves.linear))),
    );
  }
}

//Send OTP to given email
void sendOTP(EmailAuth emailAuth, String input) async {
  bool res = await emailAuth.sendOtp(recipientMail: input.trim(), otpLength: 6);
  if (res) {
    print("sent successfully");
  } else {
    print("sent fail");
  }
}

//Verify Otp
bool verifyOTP(EmailAuth emailAuth, String mail, String code) {
  return emailAuth.validateOtp(
      recipientMail: mail.trim(), userOtp: code.trim());
}

//Open customized alert dialog
openCustomizedAlertDialog(
    {required BuildContext context,
    required String title,
    required String mainText,
    required String additionalText,
    required String iconName,
    String? importantText}) {
  return showGeneralDialog(
    context: context,
    transitionDuration: Duration(milliseconds: 300),
    transitionBuilder: (context, _animation, _secondaryAnimation, _child) {
      return Animations.shrink(_animation, _secondaryAnimation, _child);
    },
    pageBuilder: (_animation, _secondaryAnimation, _child) {
      return CustomizedAlertDialog(
          context: context,
          mainText: mainText,
          additionalText: additionalText,
          importantText: importantText,
          title: title,
          iconName: iconName);
    },
  );
}

//Open success message dialog in reset-pass screen
openSuccessMessageDialog(
    {required BuildContext context,
    required String title,
    required String mainText,
    required String additionalText,
    required String iconName,
    String? importantText,
    required VoidCallback action}) {
  return showGeneralDialog(
    context: context,
    transitionDuration: Duration(milliseconds: 300),
    transitionBuilder: (context, _animation, _secondaryAnimation, _child) {
      return Animations.shrink(_animation, _secondaryAnimation, _child);
    },
    pageBuilder: (_animation, _secondaryAnimation, _child) {
      return SuccessMessageDialog(
        context: context,
        mainText: mainText,
        additionalText: additionalText,
        importantText: importantText,
        title: title,
        iconName: iconName,
        action: action,
      );
    },
  );
}

//Calculate the screen scale
double screenScale(BuildContext context) {
  Size screenSize = MediaQuery.of(context).size;
  Orientation orientation = MediaQuery.of(context).orientation;
  double hScale = 0, wScale = 0;

  if (orientation == Orientation.portrait) {
    hScale = screenSize.height / 891.4286;
    wScale = screenSize.width / 411.4286;
  } else {
    hScale = screenSize.height / 411.4286;
    wScale = screenSize.width / 891.4286;
  }

  return (hScale + wScale) / 2;
}

//Scale for font
double fontScale(BuildContext context) {
  Size screenSize = MediaQuery.of(context).size;
  Orientation orientation = MediaQuery.of(context).orientation;
  double fScale = 0;

  if (orientation == Orientation.portrait) {
    fScale = screenSize.width / 411.4286;
  } else {
    fScale = screenSize.width / 891.4286;
  }

  return fScale;
}

//Animated page route
PageRouteBuilder<dynamic> animatedRoute(Widget destination) {
  return PageRouteBuilder(
      transitionDuration: Duration(seconds: 1),
      transitionsBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secAnimation, Widget child) {
        animation =
            CurvedAnimation(parent: animation, curve: Curves.linearToEaseOut);
        return ScaleTransition(
          scale: animation,
          child: child,
          alignment: Alignment.center,
        );
      },
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secAnimation) {
        return destination;
      });
}

//Check valid phone and email in forgot-pass screen
String? inputCheck(value) {
  if (value.toString().isEmpty) {
    return "Please fill in your contact.";
  }
  if (RegExp(r'^-?[0-9]+$').hasMatch(value.toString().trim())) {
    if (!RegExp(r"^(?:[+0]9)?[0-9]{10}$").hasMatch(value.toString().trim())) {
      return "Invalid phone number.";
    }
  } else {
    if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value.toString().trim())) {
      return "Invalid email address.";
    }
  }

  return null;
}

//Check existed account when sign up and get OTP code
Future<int> checkAccount(String mail) async {
  int check = 0;
  var response = await http.post(
      Uri.parse(
          "https://gearz-gadget.000webhostapp.com/user_controllers/check_account.php"),
      body: {"email": mail});
  var jsonData = jsonDecode(response.body);

  if (jsonData == "found") {
    check = 1;
  } else {
    check = 0;
  }

  return check;
}

//Check the confirmed password
String? checkConfirmedPass(String value, String previousPwd) {
  if (value == "") {
    return "Please confirm your new password.";
  }
  if (value.length < 8) {
    return "Should have at least 8 characters.";
  }
  if (previousPwd != value) {
    return "Does not match.";
  }
  return null;
}

//Update password
Future<bool> updatePassword(String mail, String password) async {
  DBCrypt dbCrypt = DBCrypt();
  String salt = dbCrypt.gensaltWithRounds(10);
  String hashPwd = dbCrypt.hashpw(password, salt);

  var response = await http.post(
      Uri.parse(
          "https://gearz-gadget.000webhostapp.com/user_controllers/update_password.php"),
      body: {
        "email": mail,
        "password": hashPwd,
      });
  var jsonData = jsonDecode(response.body);

  if (jsonData == "failed") {
    return false;
  }

  return true;
}

//Check integer
bool isInt(num value) {
  if (value / value.toDouble() == 1) {
    return true;
  }

  return false;
}
