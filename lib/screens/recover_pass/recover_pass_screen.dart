import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:ionicons/ionicons.dart';
import 'package:itproject_gadget_store/controllers/app_controller.dart';
import 'package:itproject_gadget_store/screens/start/start_screen.dart';
import 'package:itproject_gadget_store/widgets/common_widgets.dart';

class RecoverPassScreen extends StatefulWidget {
  final String mail;
  const RecoverPassScreen({Key? key, required this.mail}) : super(key: key);

  @override
  _RecoverPassScreenState createState() => _RecoverPassScreenState();
}

class _RecoverPassScreenState extends State<RecoverPassScreen> {
  TextEditingController _newPassController = TextEditingController();
  TextEditingController _confirmedPassController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isShowed1 = true, _isShowed2 = true, _isLoading = false;

  @override
  void initState() {
    super.initState();

    _newPassController.addListener(() {
      setState(() {});
    });

    _confirmedPassController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        print(widget.mail);
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
                      30 * screenScale(context), 30 * screenScale(context)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _backBtn(),
                      Padding(
                        padding:
                            EdgeInsets.only(bottom: 20 * screenScale(context)),
                        child: introImage(
                            "verify.png",
                            screenSize.height * 0.27,
                            screenSize.width * 0.85,
                            context),
                      ),
                      introText("Update password", context),
                      Padding(
                        padding:
                            EdgeInsets.only(top: 20 * screenScale(context)),
                        child: mainText(
                            "Let's create new password. \nYour new password must be different from previous used password.",
                            context),
                      ),
                      _newpassField(30),
                      _confirmpassField(15),
                      _confirmBtn(),
                    ],
                  ),
                ),
              );
            } else {
              return Container(
                padding: EdgeInsets.fromLTRB(
                    30 * screenScale(context), 0, 30 * screenScale(context), 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      padding:
                          EdgeInsets.only(right: 20 * screenScale(context)),
                      child: Stack(
                        children: [
                          _backBtn(),
                          Center(
                              child: SingleChildScrollView(
                                  child: introImage(
                                      "verify.png",
                                      screenSize.height * 0.85,
                                      screenSize.width * 0.41,
                                      context))),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            introText("Update password", context),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 20 * screenScale(context)),
                              child: mainText(
                                  "Let's create new password. \nYour new password must be different from previous used password.",
                                  context),
                            ),
                            _newpassField(30),
                            _confirmpassField(15),
                            _confirmBtn()
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          }),
        )),
      ),
    );
  }

  //New password field
  Widget _newpassField(double topPadding) {
    return StatefulBuilder(builder: (context, setState) {
      return Container(
        padding: EdgeInsets.only(top: topPadding * screenScale(context)),
        child: TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: _newPassController,
          keyboardType: TextInputType.visiblePassword,
          obscureText: _isShowed1,
          style: TextStyle(fontSize: 15 * fontScale(context)),
          validator: MultiValidator([
            RequiredValidator(errorText: "Please fill in your new password."),
            MinLengthValidator(8,
                errorText: "Should have at least 8 characters."),
          ]),
          decoration: InputDecoration(
            isDense: true,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7 * screenScale(context))),
            contentPadding: EdgeInsets.only(
                top: 25 * screenScale(context),
                left: 10 * screenScale(context)),
            hintText: 'New password',
            suffixIconConstraints: BoxConstraints(
                maxWidth: 40 * screenScale(context),
                maxHeight: 40 * screenScale(context)),
            suffixIcon: _newPassController.text.isEmpty
                ? Container(width: 0)
                : IconButton(
                    icon: Icon(
                        _isShowed1
                            ? Ionicons.eye_outline
                            : Ionicons.eye_off_outline,
                        size: 20 * screenScale(context)),
                    onPressed: () {
                      setState(() {
                        _isShowed1 = !_isShowed1;
                      });
                    },
                  ),
          ),
        ),
      );
    });
  }

  //Confirm new password field
  Widget _confirmpassField(double topPadding) {
    return StatefulBuilder(builder: (context, setState) {
      return Container(
        padding: EdgeInsets.only(top: 15 * screenScale(context)),
        child: TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: _confirmedPassController,
          keyboardType: TextInputType.visiblePassword,
          obscureText: _isShowed2,
          validator: (value) =>
              checkConfirmedPass(value!, _newPassController.text),
          style: TextStyle(fontSize: 15 * fontScale(context)),
          decoration: InputDecoration(
            isDense: true,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7 * screenScale(context))),
            contentPadding: EdgeInsets.only(
                top: 25 * screenScale(context),
                left: 10 * screenScale(context)),
            hintText: 'Confirm new password',
            suffixIconConstraints: BoxConstraints(
                maxWidth: 40 * screenScale(context),
                maxHeight: 40 * screenScale(context)),
            suffixIcon: _confirmedPassController.text.isEmpty
                ? Container(width: 0)
                : IconButton(
                    icon: Icon(
                        _isShowed2
                            ? Ionicons.eye_outline
                            : Ionicons.eye_off_outline,
                        size: 20 * screenScale(context)),
                    onPressed: () {
                      setState(() {
                        _isShowed2 = !_isShowed2;
                      });
                    },
                  ),
          ),
        ),
      );
    });
  }

  //Confirm button
  Widget _confirmBtn() {
    return Container(
      width: double.infinity,
      height: 45 * screenScale(context),
      margin: EdgeInsets.only(top: 45 * screenScale(context)),
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            setState(() {
              _isLoading = true;
            });
            updatePassword(widget.mail, _newPassController.text).then((value) {
              if (value == true) {
                setState(() {
                  _isLoading = false;
                });
                openSuccessMessageDialog(
                  context: context,
                  title: "Success!",
                  mainText: "Your new password is updated. \nNow you can ",
                  importantText: "Sign in ",
                  additionalText: "again and continue enjoying your day.",
                  iconName: "success.png",
                  action: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => StartScreen(initPage: 1)));
                  },
                );
              }
            });
          } else {
            print("not good at all...");
          }
        },
        child: _isLoading == false
            ? Text('Confirm',
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

  //Back button
  Widget _backBtn() {
    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.only(top: 10 * screenScale(context)),
      child: GestureDetector(
          onTap: () {
            int count = 0;
            Navigator.popUntil(context, (route) {
              return count++ == 2;
            });
          },
          child: Icon(
            Ionicons.chevron_back_outline,
            size: 24 * screenScale(context),
          )),
    );
  }
}
