import 'package:email_auth/email_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ionicons/ionicons.dart';
import 'package:itproject_gadget_store/controllers/app_controller.dart';
import 'package:itproject_gadget_store/controllers/google_api.dart';
import 'package:itproject_gadget_store/controllers/user_preferences.dart';
import 'package:itproject_gadget_store/screens/main/main_screen.dart';
import 'package:itproject_gadget_store/screens/recover_pass/otp_verify_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

//The text below the signin signup screens
Container footerText(
    {required BuildContext context,
    required String mainText,
    required String actionText,
    required bool toSignIn,
    required PageController controller}) {
  return Container(
    padding: EdgeInsets.only(top: 10 * screenScale(context)),
    child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '${mainText} ',
            style: TextStyle(fontSize: 14 * fontScale(context)),
          ),
          GestureDetector(
              onTap: () {
                if (toSignIn == true) {
                  controller.animateToPage(1,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.decelerate);
                } else {
                  controller.animateToPage(0,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.decelerate);
                }
              },
              child: Text(actionText,
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w800,
                      fontSize: 15 * fontScale(context)))),
        ]),
  );
}

//The text for another method of signin signup
Column portraitSocialMediaIcons(BuildContext context, EmailAuth auth) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              child: Divider(
                  color: Colors.black45,
                  height: 20 * screenScale(context),
                  thickness: 1 * screenScale(context),
                  endIndent: 10 * screenScale(context))),
          Text(
            "Or",
            style: TextStyle(fontSize: 14 * fontScale(context)),
          ),
          Expanded(
              child: Divider(
                  color: Colors.black45,
                  height: 20 * screenScale(context),
                  thickness: 1 * screenScale(context),
                  indent: 10 * screenScale(context))),
        ],
      ),
      Text("Continue with",
          style: TextStyle(fontSize: 14 * fontScale(context))),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          googleIcon(context, auth),
          facebookIcon(context, auth),
        ],
      )
    ],
  );
}

//Facebook icon
GestureDetector facebookIcon(BuildContext context, EmailAuth auth) {
  return GestureDetector(
    onTap: () async {
      final result =
          await FacebookAuth.i.login(permissions: ["public_profile", "email"]);
      SharedPreferences pref = await SharedPreferences.getInstance();
      if (result.status == LoginStatus.success) {
        final data = await FacebookAuth.i.getUserData();
        var res = await continueWithSMAccount(
            mail: data["email"],
            imgUrl: data["picture"]["data"]["url"] == null
                ? ""
                : data["picture"]["data"]["url"],
            name: data["name"],
            type: "FB");

        if (res == "create") {
          sendOTP(auth, data["email"]);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OtpVerifyScreen(
                      mail: data["email"],
                      fromStartScreen: true,
                      fullName: data["name"],
                      password: "",
                      fromProfileScreen: false,
                      imgUrl: data["picture"]["data"]["url"],
                      fbOrgg: "FB")));
        } else {
          await UserPreferences.setUserMail(
              preferences: pref, mail: res["email"]);
          Get.snackbar(
            "Welcome back!",
            "Here you are my friend. Have a good day.",
            colorText: Colors.white,
            snackStyle: SnackStyle.FLOATING,
            barBlur: 30,
            backgroundColor: Colors.black45,
            isDismissible: true,
            duration: Duration(seconds: 3),
            dismissDirection: DismissDirection.horizontal,
          );
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => MainScreen(userMail: res["email"])));
        }
        print(data["picture"]["data"]["url"]);
        print(data["name"]);
        print(data["email"]);
      }
    },
    child: Padding(
        padding: EdgeInsets.only(
            top: 10 * screenScale(context), left: 10 * screenScale(context)),
        child: SvgPicture.asset("assets/images/facebook.svg",
            height: 32 * screenScale(context))),
  );
}

//Google icon
GestureDetector googleIcon(BuildContext context, EmailAuth auth) {
  return GestureDetector(
    onTap: () async {
      GoogleSignInAccount? user = await GoogleSignInApi.googelLogin();
      if (user != null) {
        var result = await continueWithSMAccount(
            mail: user.email,
            imgUrl: user.photoUrl == null ? "" : user.photoUrl!,
            name: user.displayName!,
            type: "GG");
        SharedPreferences pref = await SharedPreferences.getInstance();

        if (result == "create") {
          sendOTP(auth, user.email);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OtpVerifyScreen(
                      mail: user.email,
                      fromStartScreen: true,
                      fullName: user.displayName!,
                      password: "",
                      fromProfileScreen: false,
                      imgUrl: user.photoUrl,
                      fbOrgg: "GG")));
        } else {
          await UserPreferences.setUserMail(
              preferences: pref, mail: result["email"]);
          Get.snackbar(
            "Welcome back!",
            "Here you are my friend. Have a good day.",
            colorText: Colors.white,
            snackStyle: SnackStyle.FLOATING,
            barBlur: 30,
            backgroundColor: Colors.black45,
            isDismissible: true,
            duration: Duration(seconds: 3),
            dismissDirection: DismissDirection.horizontal,
          );
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => MainScreen(userMail: result["email"])));
        }
      } else {
        print("something was wrong with that account");
      }
    },
    child: Padding(
        padding: EdgeInsets.only(
            top: 10 * screenScale(context), right: 10 * screenScale(context)),
        child: SvgPicture.asset("assets/images/google.svg",
            height: 30 * screenScale(context))),
  );
}

//Email textfield
Widget mailField(
    {required BuildContext context,
    required TextEditingController mailController,
    required double topPadding}) {
  return Container(
    margin: EdgeInsets.only(top: topPadding * screenScale(context)),
    child: TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: mailController,
      keyboardType: TextInputType.emailAddress,
      validator: MultiValidator([
        EmailValidator(errorText: "Invalid email address."),
        RequiredValidator(errorText: "Please fill in your emai."),
      ]),
      style: TextStyle(fontSize: 15 * fontScale(context)),
      decoration: InputDecoration(
        isDense: true,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7 * screenScale(context))),
        contentPadding: EdgeInsets.only(
            top: 25 * screenScale(context), left: 10 * screenScale(context)),
        hintText: 'Email address',
        suffixIconConstraints: BoxConstraints(
            maxWidth: 40 * screenScale(context),
            maxHeight: 40 * screenScale(context)),
        suffixIcon: mailController.text.isEmpty
            ? Container(width: 0)
            : IconButton(
                icon: Icon(
                  Ionicons.close_outline,
                  size: 24 * screenScale(context),
                ),
                onPressed: () {
                  mailController.clear();
                },
              ),
      ),
    ),
  );
}

//Name field (first name and last name)
Widget nameField(
    {required BuildContext context,
    required TextEditingController fnameController,
    required TextEditingController lnamController,
    required double topPadding}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        width: MediaQuery.of(context).orientation == Orientation.portrait
            ? MediaQuery.of(context).size.width / 2 - 40 * screenScale(context)
            : MediaQuery.of(context).size.width / 2 -
                230 * screenScale(context),
        margin: EdgeInsets.only(top: topPadding * screenScale(context)),
        child: TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: fnameController,
          keyboardType: TextInputType.name,
          validator: MultiValidator([
            RequiredValidator(errorText: "Please fill in your first name."),
          ]),
          style: TextStyle(fontSize: 15 * fontScale(context)),
          decoration: InputDecoration(
            isDense: true,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7 * screenScale(context))),
            contentPadding: EdgeInsets.only(
                top: 25 * screenScale(context),
                left: 10 * screenScale(context)),
            hintText: 'First name',
            suffixIconConstraints: BoxConstraints(
                maxWidth: 40 * screenScale(context),
                maxHeight: 40 * screenScale(context)),
            suffixIcon: fnameController.text.isEmpty
                ? Container(width: 0)
                : IconButton(
                    icon: Icon(
                      Ionicons.close_outline,
                      size: 24 * screenScale(context),
                    ),
                    onPressed: () {
                      fnameController.clear();
                    },
                  ),
            errorMaxLines: 2,
          ),
        ),
      ),
      Container(
        width: MediaQuery.of(context).orientation == Orientation.portrait
            ? MediaQuery.of(context).size.width / 2 - 40 * screenScale(context)
            : MediaQuery.of(context).size.width / 2 -
                230 * screenScale(context),
        margin: EdgeInsets.only(top: topPadding * screenScale(context)),
        child: TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: lnamController,
          keyboardType: TextInputType.name,
          validator: MultiValidator([
            RequiredValidator(errorText: "Please fill in your last name."),
          ]),
          style: TextStyle(fontSize: 15 * fontScale(context)),
          decoration: InputDecoration(
            isDense: true,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7 * screenScale(context))),
            contentPadding: EdgeInsets.only(
                top: 25 * screenScale(context),
                left: 10 * screenScale(context)),
            hintText: 'Last name',
            suffixIconConstraints: BoxConstraints(
                maxWidth: 40 * screenScale(context),
                maxHeight: 40 * screenScale(context)),
            suffixIcon: lnamController.text.isEmpty
                ? Container(width: 0)
                : IconButton(
                    icon: Icon(
                      Ionicons.close_outline,
                      size: 24 * screenScale(context),
                    ),
                    onPressed: () {
                      lnamController.clear();
                    },
                  ),
            errorMaxLines: 2,
          ),
        ),
      )
    ],
  );
}
