import 'package:email_auth/email_auth.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:itproject_gadget_store/controllers/auth.config.dart';
import 'package:itproject_gadget_store/controllers/app_controller.dart';
import 'package:itproject_gadget_store/screens/recover_pass/otp_verify_screen.dart';
import 'package:itproject_gadget_store/widgets/common_widgets.dart';

class ForgotPassScreen extends StatefulWidget {
  const ForgotPassScreen({Key? key}) : super(key: key);

  @override
  _ForgotPassScreenState createState() => _ForgotPassScreenState();
}

class _ForgotPassScreenState extends State<ForgotPassScreen> {
  TextEditingController _inputController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late EmailAuth _emailAuth;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _inputController.addListener(() {
      setState(() {});
    });
    _emailAuth = new EmailAuth(sessionName: "GearZ");
    _emailAuth.config(remoteServerConfiguration);
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: LayoutBuilder(builder: (context, snapshot) {
              if (snapshot.maxWidth <= screenSize.width &&
                  orientation == Orientation.portrait) {
                return SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(30 * screenScale(context), 0,
                        30 * screenScale(context), 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            introImage("forget.jpg", screenSize.height * 0.32,
                                screenSize.width * 0.85, context),
                            backBtn(context),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 10 * screenScale(context),
                              bottom: 20 * screenScale(context)),
                          child: introText("Forgot your password", context),
                        ),
                        mainText(
                            "Don't worry. Provide us your email or phone number and then we'll help you reset your password in few steps.",
                            context),
                        Padding(
                          padding:
                              EdgeInsets.only(top: 30 * screenScale(context)),
                          child: _inputField(),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(top: 15 * screenScale(context)),
                          child: _sendBtn(),
                        )
                      ],
                    ),
                  ),
                );
              } else {
                return Container(
                  padding: EdgeInsets.fromLTRB(30 * screenScale(context), 0,
                      30 * screenScale(context), 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      backBtn(context),
                      Center(
                          child: SingleChildScrollView(
                        child: introImage(
                            "forget.jpg",
                            screenSize.height * 0.85,
                            screenSize.width * 0.41,
                            context),
                      )),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    bottom: 20 * screenScale(context)),
                                child:
                                    introText("Forgot your password", context),
                              ),
                              mainText(
                                  "Don't worry. Provide us your email or phone number and then we'll help you reset your password in few steps.",
                                  context),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 30 * screenScale(context)),
                                child: _inputField(),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 15 * screenScale(context)),
                                child: _sendBtn(),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            }),
          ),
        ),
      ),
    );
  }

  //Send button
  Widget _sendBtn() {
    return SizedBox(
      width: double.infinity,
      height: 45 * screenScale(context),
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            setState(() {
              _isLoading = true;
            });
            checkAccount(_inputController.text).then((value) {
              if (value == 1) {
                sendOTP(_emailAuth, _inputController.text);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OtpVerifyScreen(
                            mail: _inputController.text,
                            fullName: "",
                            password: "",
                            fromStartScreen: false,
                            fromProfileScreen: false)));
                setState(() {
                  _isLoading = false;
                });
              } else {
                openCustomizedAlertDialog(
                    context: context,
                    title: 'Something was wrong!',
                    mainText:
                        "Provided email isn't associated with your account. ",
                    additionalText: "Please check and try again.",
                    iconName: "error.png");
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
            ? Text('Send OTP',
                style: TextStyle(
                    fontSize: 17 * fontScale(context),
                    fontWeight: FontWeight.w900,
                    color: Colors.white))
            : loadingText("Sending", context),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7 * screenScale(context))),
          primary: Color(hexColor("#346ec9")),
        ),
      ),
    );
  }

  //Input field
  Widget _inputField() {
    return TextFormField(
      onChanged: (value) {
        print(value);
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: _inputController,
      keyboardType: TextInputType.text,
      validator: inputCheck,
      style: TextStyle(fontSize: 15 * fontScale(context)),
      decoration: InputDecoration(
        isDense: true,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7 * screenScale(context))),
        contentPadding: EdgeInsets.only(
            top: 25 * screenScale(context), left: 10 * screenScale(context)),
        hintText: 'Email or phone',
        suffixIconConstraints: BoxConstraints(
            maxWidth: 40 * screenScale(context),
            maxHeight: 40 * screenScale(context)),
        suffixIcon: _inputController.text.isEmpty
            ? Container(width: 0)
            : IconButton(
                icon: Icon(Ionicons.close_outline,
                    size: 24 * screenScale(context)),
                onPressed: () {
                  _inputController.clear();
                },
              ),
      ),
    );
  }
}
