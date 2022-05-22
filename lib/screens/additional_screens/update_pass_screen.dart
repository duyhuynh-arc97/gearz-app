import 'package:dbcrypt/dbcrypt.dart';
import 'package:email_auth/email_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:itproject_gadget_store/controllers/app_controller.dart';
import 'package:itproject_gadget_store/controllers/auth.config.dart';
import 'package:itproject_gadget_store/controllers/user_controller.dart';
import 'package:itproject_gadget_store/widgets/common_widgets.dart';

class UpdatePassScreen extends StatefulWidget {
  const UpdatePassScreen({Key? key}) : super(key: key);

  @override
  _UpdatePassScreenState createState() => _UpdatePassScreenState();
}

class _UpdatePassScreenState extends State<UpdatePassScreen> {
  TextEditingController _newPassController = TextEditingController();
  TextEditingController _confirmedPassController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isShowed1 = true, _isShowed2 = true, _isLoading = false;
  UserController _userController = Get.find();
  late EmailAuth _emailAuth;

  @override
  void initState() {
    super.initState();

    _newPassController.addListener(() {
      setState(() {});
    });

    _confirmedPassController.addListener(() {
      setState(() {});
    });

    _emailAuth = new EmailAuth(sessionName: "GearZ");
    _emailAuth.config(remoteServerConfiguration);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: Text(
            "Update password",
            style: TextStyle(color: Colors.black),
          ),
          leading: IconButton(
              onPressed: () => Get.back(),
              icon: Icon(
                Ionicons.chevron_back_outline,
                color: Colors.black,
              )),
          backgroundColor: Colors.white,
        ),
        body: SafeArea(
            child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.fromLTRB(30 * screenScale(context), 0,
                  30 * screenScale(context), 30 * screenScale(context)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _newpassField(15),
                  _confirmpassField(15),
                  _confirmBtn(),
                ],
              ),
            ),
          ),
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
          DBCrypt dBCrypt = DBCrypt();
          if (_formKey.currentState!.validate()) {
            setState(() {
              _isLoading = true;
            });
            if (dBCrypt.checkpw(_newPassController.text,
                    _userController.user.value.password) ==
                false) {
              updatePassword(
                      _userController.user.value.mail, _newPassController.text)
                  .then((value) {
                if (value == true) {
                  openSuccessMessageDialog(
                    context: context,
                    title: "Updated!",
                    mainText:
                        "Your new password has been updated. \nNow you can ",
                    additionalText: "continue enjoying your day.",
                    iconName: "success.png",
                    action: () {
                      Navigator.pop(context);
                    },
                  );
                }
              });
              setState(() {
                _isLoading = false;
              });
            } else {
              setState(() {
                _isLoading = false;
                openCustomizedAlertDialog(
                  context: context,
                  title: "Same password!",
                  mainText:
                      "The new password is the current password. \nPlease choose a new password ",
                  additionalText: "that has not been used before.",
                  iconName: "error.png",
                );
              });
            }
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
}
