import 'dart:async';

import 'package:email_auth/email_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:itproject_gadget_store/controllers/auth.config.dart';
import 'package:itproject_gadget_store/controllers/app_controller.dart';
import 'package:itproject_gadget_store/controllers/user_preferences.dart';
import 'package:itproject_gadget_store/screens/main/main_screen.dart';
import 'package:itproject_gadget_store/screens/recover_pass/recover_pass_screen.dart';
import 'package:itproject_gadget_store/screens/additional_screens/update_pass_screen.dart';
import 'package:itproject_gadget_store/widgets/common_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpVerifyScreen extends StatefulWidget {
  final String? imgUrl, fbOrgg;
  final String mail, fullName, password;
  final bool fromStartScreen;
  final bool fromProfileScreen;
  const OtpVerifyScreen(
      {Key? key,
      required this.mail,
      required this.fromStartScreen,
      required this.fullName,
      required this.password,
      required this.fromProfileScreen,
      this.imgUrl,
      this.fbOrgg})
      : super(key: key);

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  //Variables for otp digits and email_auth
  TextEditingController _digit1 = TextEditingController();
  TextEditingController _digit2 = TextEditingController();
  TextEditingController _digit3 = TextEditingController();
  TextEditingController _digit4 = TextEditingController();
  TextEditingController _digit5 = TextEditingController();
  TextEditingController _digit6 = TextEditingController();
  late EmailAuth emailAuth;

  //Variables for remaining time
  int _minutes = 0;
  int _seconds = 120;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    emailAuth = new EmailAuth(sessionName: "GearZ");
    emailAuth.config(remoteServerConfiguration);

    _startTimer();
  }

  //Timer text
  _startTimer() {
    if (_seconds > 60) {
      _minutes = (_seconds / 60).floor();
      _seconds -= _minutes * 60;
    }
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        if (_seconds > 0) {
          _seconds--;
        } else {
          if (_minutes > 0) {
            _seconds = 59;
            _minutes--;
          } else {
            openCustomizedAlertDialog(
              context: context,
              title: "Time's up!",
              mainText: "Authentication time has out. \nPlease choose ",
              additionalText: ", we'll send your another OTP code.",
              iconName: "error.png",
              importantText: "Resend ",
            );
            _timer.cancel();
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //Convert 1 digit to 2 digits
    final m = _minutes.toString().padLeft(2, "0");
    final s = _seconds.toString().padLeft(2, "0");
    Size screenSize = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: LayoutBuilder(builder: (context, snapshot) {
            if (snapshot.maxWidth <= screenSize.width &&
                orientation == Orientation.portrait) {
              return SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.fromLTRB(30 * screenScale(context), 0,
                      30 * screenScale(context), 30 * screenScale(context)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(children: [
                        introImage("otp.jpg", screenSize.height * 0.32,
                            screenSize.width * 0.85, context),
                        backBtn(context),
                      ]),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 10 * screenScale(context),
                            bottom: 20 * screenScale(context)),
                        child: introText("OTP Verification", context),
                      ),
                      _mainText(m, s),
                      _otpDigits(),
                      _confirmBtn(),
                      _footerText(),
                    ],
                  ),
                ),
              );
            } else {
              return Container(
                padding: EdgeInsets.fromLTRB(
                    30 * screenScale(context), 0, 30 * screenScale(context), 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    backBtn(context),
                    Center(
                      child: SingleChildScrollView(
                          child: introImage("otp.jpg", screenSize.height * 0.85,
                              screenSize.width * 0.41, context)),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.only(
                              bottom: 30 * screenScale(context)),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    bottom: 20 * screenScale(context)),
                                child: introText("OTP Verification", context),
                              ),
                              _mainText(m, s),
                              _otpDigits(),
                              _confirmBtn(),
                              _footerText()
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            }
          }),
        ),
      ),
    );
  }

  //Text below the button
  Container _footerText() {
    return Container(
      padding: EdgeInsets.only(top: 20 * screenScale(context)),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('Still did not recieve the code? '),
            GestureDetector(
              onTap: () {
                sendOTP(emailAuth, widget.mail);
                _timer.cancel();
                _minutes = 0;
                _seconds = 120;
                _startTimer();
              },
              child: Text(
                'Resend',
                style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w800,
                    fontSize: 15 * fontScale(context)),
              ),
            ),
          ]),
    );
  }

  //Confirm button
  Widget _confirmBtn() {
    return SizedBox(
      width: double.infinity,
      height: 45 * screenScale(context),
      child: ElevatedButton(
        onPressed: () async {
          String code = _digit1.text +
              _digit2.text +
              _digit3.text +
              _digit4.text +
              _digit5.text +
              _digit6.text;
          SnackBar snackBar;
          SharedPreferences pref = await SharedPreferences.getInstance();

          if (code.isEmpty) {
            snackBar = SnackBar(
              content: Text("Please enter the code."),
              action: SnackBarAction(
                label: "Retry",
                onPressed: () {},
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } else {
            if (verifyOTP(emailAuth, widget.mail, code)) {
              _timer.cancel();
              widget.fromStartScreen == false &&
                      widget.fromProfileScreen == false
                  ? {
                      await UserPreferences.setUserMail(
                          preferences: pref, mail: widget.mail),
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  RecoverPassScreen(mail: widget.mail))),
                    }
                  : widget.fromProfileScreen == false &&
                          widget.fromStartScreen == true
                      ? {
                          await UserPreferences.setUserMail(
                              preferences: pref, mail: widget.mail),
                          signup(
                              name: widget.fullName,
                              mail: widget.mail,
                              password: widget.password,
                              type: widget.fbOrgg == null
                                  ? "DTB"
                                  : widget.fbOrgg!,
                              imgUrl:
                                  widget.imgUrl == null ? "" : widget.imgUrl!),
                          Get.snackbar(
                            "Hoorah!",
                            "Welcome to the tech world - Gearz. Have a good day.",
                            icon: Icon(
                              Ionicons.checkmark_done_outline,
                              color: Colors.white,
                            ),
                            colorText: Colors.white,
                            snackStyle: SnackStyle.FLOATING,
                            barBlur: 30,
                            backgroundColor: Colors.black45,
                            isDismissible: true,
                            duration: Duration(seconds: 3),
                            dismissDirection: DismissDirection.horizontal,
                          ),
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MainScreen(userMail: widget.mail))),
                        }
                      : widget.fromProfileScreen == true &&
                              widget.fromStartScreen == false
                          ? {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UpdatePassScreen()))
                            }
                          : {};
            } else {
              openCustomizedAlertDialog(
                context: context,
                title: "Failed verification!",
                mainText:
                    "You tried to confirm an invalid OTP code. \nPlease check again or choose ",
                additionalText: "if you didn't reveive the code.",
                iconName: "error.png",
                importantText: "Resend ",
              );
            }
          }
        },
        child: Text(
          'Confirm',
          style: TextStyle(
              fontSize: 17 * fontScale(context),
              fontWeight: FontWeight.w900,
              color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7 * screenScale(context))),
            primary: Color(hexColor("#346ec9"))),
      ),
    );
  }

  //The block of OTP digits
  Widget _otpDigits() {
    return Container(
      padding: EdgeInsets.only(
          top: 30 * screenScale(context), bottom: 30 * screenScale(context)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          OtpTextField(digit: _digit1, isLast: false, isFirst: true),
          OtpTextField(digit: _digit2, isLast: false, isFirst: false),
          OtpTextField(digit: _digit3, isLast: false, isFirst: false),
          OtpTextField(digit: _digit4, isLast: false, isFirst: false),
          OtpTextField(digit: _digit5, isLast: false, isFirst: false),
          OtpTextField(digit: _digit6, isLast: true, isFirst: false),
        ],
      ),
    );
  }

  //Main content in the screen
  Widget _mainText(String m, String s) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          style: TextStyle(
              color: Colors.black,
              fontSize: 15 * fontScale(context),
              fontFamily: 'OpenSans'),
          children: [
            TextSpan(text: "We sent to "),
            TextSpan(
                text: widget.mail.trim(), style: TextStyle(color: Colors.blue)),
            TextSpan(
                text:
                    " an OTP code with 6 digits. \nPlease check and confirm within "),
            TextSpan(
              text: "${m}:${s}",
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            )
          ]),
    );
  }
}

//The widget of a single digit
class OtpTextField extends StatelessWidget {
  final TextEditingController digit;
  final bool isLast, isFirst;
  const OtpTextField(
      {Key? key,
      required this.digit,
      required this.isLast,
      required this.isFirst})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55 * screenScale(context),
      width: 40 * screenScale(context),
      child: TextField(
        controller: digit,
        onChanged: (value) {
          if (value.length == 1) {
            if (isLast) {
              FocusScope.of(context).unfocus();
            } else {
              FocusScope.of(context).nextFocus();
            }
          }
          if (value.length == 0) {
            if (isFirst) {
              return;
            } else {
              FocusScope.of(context).previousFocus();
            }
          }
        },
        showCursor: false,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: TextStyle(
            fontSize: 20 * fontScale(context), fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          counter: Offstage(),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(width: 2 * screenScale(context))),
          hintText: "*",
        ),
      ),
    );
  }
}
