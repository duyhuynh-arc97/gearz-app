import 'package:email_auth/email_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:itproject_gadget_store/controllers/auth.config.dart';
import 'package:itproject_gadget_store/controllers/app_controller.dart';
import 'package:itproject_gadget_store/controllers/user_preferences.dart';
import 'package:itproject_gadget_store/screens/main/main_screen.dart';
import 'package:itproject_gadget_store/screens/recover_pass/forgot_pass_screen.dart';
import 'package:itproject_gadget_store/screens/recover_pass/otp_verify_screen.dart';
import 'package:itproject_gadget_store/widgets/common_widgets.dart';
import 'package:itproject_gadget_store/widgets/login_signup_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StartScreen extends StatefulWidget {
  final int? initPage;
  const StartScreen({Key? key, this.initPage}) : super(key: key);

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  bool _isShowed = true;
  TextEditingController _fnameController = TextEditingController();
  TextEditingController _lnameController = TextEditingController();
  TextEditingController _mailController = TextEditingController();
  TextEditingController _pwdController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  late EmailAuth _emailAuth;
  bool _isLoading = false;
  bool _isLoading2 = false;

  late PageController _pageController;

  @override
  void initState() {
    super.initState();

    _fnameController.addListener(() {
      setState(() {});
    });

    _lnameController.addListener(() {
      setState(() {});
    });

    _mailController.addListener(() {
      setState(() {});
    });

    _pwdController.addListener(() {
      setState(() {});
    });

    _emailAuth = new EmailAuth(sessionName: "GearZ");
    _emailAuth.config(remoteServerConfiguration);

    _pageController = PageController(
        initialPage: widget.initPage != null ? widget.initPage! : 0);
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: PageView(
            // physics: NeverScrollableScrollPhysics(),
            controller: _pageController,
            children: [
              Form(
                key: _formKey,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(30 * screenScale(context), 0,
                        30 * screenScale(context), 30 * screenScale(context)),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        introImage("signup.png", screenSize.height * 0.33,
                            screenSize.width * 0.85, context),
                        introText("Get Started,", context),
                        nameField(
                            context: context,
                            fnameController: _fnameController,
                            lnamController: _lnameController,
                            topPadding: 30),
                        mailField(
                            context: context,
                            mailController: _mailController,
                            topPadding: 15),
                        _passwordField(15),
                        _signupBtn(45, double.infinity),
                        portraitSocialMediaIcons(context, _emailAuth),
                        footerText(
                            context: context,
                            mainText: "Already have an account?",
                            actionText: "Sign in",
                            toSignIn: true,
                            controller: _pageController),
                      ],
                    ),
                  ),
                ),
              ),
              Form(
                key: _formKey2,
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(30 * screenScale(context), 0,
                        30 * screenScale(context), 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        introImage("login.jpg", screenSize.height * 0.33,
                            screenSize.width * 0.85, context),
                        introText("Welcome Back,", context),
                        mailField(
                            context: context,
                            mailController: _mailController,
                            topPadding: 30),
                        _passwordField2(15),
                        _forgotpassField(context, 15, _mailController),
                        _signinBtn(45, double.infinity),
                        portraitSocialMediaIcons(context, _emailAuth),
                        footerText(
                            context: context,
                            mainText: "Don't have an account?",
                            actionText: "Sign up",
                            toSignIn: false,
                            controller: _pageController),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //Password textfield
  Widget _passwordField2(double topPadding) {
    return StatefulBuilder(builder: (context, setState) {
      return Container(
        margin: EdgeInsets.only(top: topPadding * screenScale(context)),
        child: TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: _pwdController,
          keyboardType: TextInputType.visiblePassword,
          obscureText: _isShowed,
          validator: MultiValidator([
            RequiredValidator(errorText: "Please fill in your password."),
            MinLengthValidator(8,
                errorText: "Should have at least 8 characters."),
          ]),
          style: TextStyle(fontSize: 15 * fontScale(context)),
          decoration: InputDecoration(
            isDense: true,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7 * screenScale(context))),
            contentPadding: EdgeInsets.only(
                top: 25 * screenScale(context),
                left: 10 * screenScale(context)),
            hintText: 'Password',
            suffixIconConstraints: BoxConstraints(
                maxWidth: 40 * screenScale(context),
                maxHeight: 40 * screenScale(context)),
            suffixIcon: _pwdController.text.isEmpty
                ? Container(width: 0)
                : IconButton(
                    icon: Icon(
                        _isShowed
                            ? Ionicons.eye_outline
                            : Ionicons.eye_off_outline,
                        size: 20 * screenScale(context)),
                    onPressed: () {
                      setState(() {
                        _isShowed = !_isShowed;
                      });
                    },
                  ),
          ),
        ),
      );
    });
  }

  //Signin button
  Widget _signinBtn(double paddingTop, double w) {
    return Container(
      width: w * screenScale(context),
      height: 45 * screenScale(context),
      margin: EdgeInsets.only(
          top: paddingTop * screenScale(context),
          bottom: 10 * screenScale(context)),
      child: ElevatedButton(
        onPressed: () async {
          SharedPreferences pref = await SharedPreferences.getInstance();

          if (_formKey2.currentState!.validate()) {
            setState(() {
              _isLoading2 = true;
            });
            login(_mailController.text, _pwdController.text)
                .then((value) async {
              if (value == 1) {
                await UserPreferences.setUserMail(
                    preferences: pref, mail: _mailController.text);
                setState(() {
                  _isLoading2 = false;
                });
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
                        builder: (context) =>
                            MainScreen(userMail: _mailController.text)));
              } else {
                if (_mailController.text.isEmpty ||
                    _pwdController.text.isEmpty) {
                  return;
                } else {
                  openCustomizedAlertDialog(
                    context: context,
                    title: "Something went wrong!",
                    mainText:
                        "Your account may not exist or you've filled in wrong password. Please try again or ",
                    importantText: "Sign up ",
                    additionalText: "for new account.",
                    iconName: "error.png",
                  );
                  setState(() {
                    _isLoading2 = false;
                  });
                }
              }
            });
          } else {
            return;
          }
        },
        child: _isLoading2 == false
            ? Text('Sign in',
                style: TextStyle(
                    fontSize: 17 * fontScale(context),
                    fontWeight: FontWeight.w900,
                    color: Colors.white))
            : loadingText("Please wait", context),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7 * screenScale(context))),
          primary: Color(hexColor("#346ec9")),
        ),
      ),
    );
  }

//Forgot password text
  Container _forgotpassField(BuildContext context, double paddingTop,
      TextEditingController controller) {
    return Container(
      margin: EdgeInsets.only(top: paddingTop * screenScale(context)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ForgotPassScreen()));
              },
              child: Text("Forgot password?",
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 14 * fontScale(context))))
        ],
      ),
    );
  }

  //Password textfield
  Widget _passwordField(double topPadding) {
    return StatefulBuilder(builder: (context, setState) {
      return Container(
        margin: EdgeInsets.only(top: topPadding * screenScale(context)),
        child: TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: _pwdController,
          keyboardType: TextInputType.visiblePassword,
          obscureText: _isShowed,
          validator: MultiValidator([
            RequiredValidator(errorText: "Please fill in your password."),
            MinLengthValidator(8,
                errorText: "Should have at least 8 characters."),
          ]),
          style: TextStyle(fontSize: 15 * fontScale(context)),
          decoration: InputDecoration(
            isDense: true,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7 * screenScale(context))),
            contentPadding: EdgeInsets.only(
                top: 25 * screenScale(context),
                left: 10 * screenScale(context)),
            hintText: 'Password',
            suffixIconConstraints: BoxConstraints(
                maxWidth: 40 * screenScale(context),
                maxHeight: 40 * screenScale(context)),
            suffixIcon: _pwdController.text.isEmpty
                ? Container(width: 0)
                : IconButton(
                    icon: Icon(
                        _isShowed
                            ? Ionicons.eye_outline
                            : Ionicons.eye_off_outline,
                        size: 20 * screenScale(context)),
                    onPressed: () {
                      setState(() {
                        _isShowed = !_isShowed;
                      });
                    },
                  ),
          ),
        ),
      );
    });
  }

  //Signup button
  Widget _signupBtn(double paddingTop, double w) {
    return Container(
      height: 45 * screenScale(context),
      width: w * screenScale(context),
      margin: EdgeInsets.only(
          top: paddingTop * screenScale(context),
          bottom: 10 * screenScale(context)),
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            setState(() {
              _isLoading = true;
            });
            checkAccount(_mailController.text).then((value) {
              if (value == 1) {
                openCustomizedAlertDialog(
                  context: context,
                  title: "Something went wrong!",
                  mainText:
                      "An account with that email address adready exists. Please choose another one or ",
                  additionalText: "if you adready have an account.",
                  iconName: "error.png",
                  importantText: "Sign in ",
                );
                setState(() {
                  _isLoading = false;
                });
              } else {
                sendOTP(_emailAuth, _mailController.text);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OtpVerifyScreen(
                              mail: _mailController.text,
                              fullName: _fnameController.text +
                                  " " +
                                  _lnameController.text,
                              password: _pwdController.text,
                              fromStartScreen: true,
                              fromProfileScreen: false,
                            )));
                setState(() {
                  _isLoading = false;
                });
              }
            });
          } else {
            print("not good at all...");
          }
        },
        child: _isLoading == false
            ? Text('Sign up',
                style: TextStyle(
                    fontSize: 17 * fontScale(context),
                    fontWeight: FontWeight.w900,
                    color: Colors.white))
            : loadingText("Please wait", context),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7 * screenScale(context))),
          primary: Color(hexColor("#346ec9")),
        ),
      ),
    );
  }
}
