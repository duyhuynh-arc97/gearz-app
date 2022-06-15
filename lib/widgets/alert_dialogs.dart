import 'package:flutter/material.dart';
import 'package:itproject_gadget_store/controllers/app_controller.dart';

//For signup and login screen
class CustomizedAlertDialog extends StatelessWidget {
  final String mainText, additionalText, title, iconName;
  final String? importantText;
  final bool? hasCancelBtn;
  final VoidCallback? okAction;
  const CustomizedAlertDialog(
      {Key? key,
      required this.context,
      required this.mainText,
      required this.additionalText,
      this.importantText,
      required this.title,
      required this.iconName,
      this.hasCancelBtn,
      this.okAction})
      : super(key: key);

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10 * screenScale(context))),
      child: Container(
        height: 210 * screenScale(context),
        width: 350 * screenScale(context),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                  0, 10 * screenScale(context), 0, 10 * screenScale(context)),
              child: Image.asset("assets/images/${iconName}",
                  height: 60 * screenScale(context)),
            ),
            Positioned(
              top: 75 * screenScale(context),
              child: Text(title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15 * fontScale(context),
                      color: Colors.blue)),
            ),
            Positioned(
              top: 105 * screenScale(context),
              left: 25 * screenScale(context),
              right: 25 * screenScale(context),
              child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14 * fontScale(context)),
                      children: [
                        TextSpan(text: mainText),
                        TextSpan(
                            text: importantText,
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold)),
                        TextSpan(text: additionalText)
                      ])),
            ),
            Positioned(
              bottom: 10 * screenScale(context),
              right: 25 * screenScale(context),
              child: TextButton(
                  onPressed: hasCancelBtn == true
                      ? okAction
                      : () => Navigator.of(context).pop(),
                  child: Text("OK",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14 * fontScale(context)))),
            ),
            hasCancelBtn == true
                ? Positioned(
                    bottom: 10 * screenScale(context),
                    left: 25 * screenScale(context),
                    child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("Cancel",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14 * fontScale(context)))),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}

//Success message dialog for reset-pass screen
class SuccessMessageDialog extends StatelessWidget {
  final String mainText, additionalText, title, iconName;
  final String? importantText;
  final VoidCallback action;
  const SuccessMessageDialog(
      {Key? key,
      required this.context,
      required this.mainText,
      required this.additionalText,
      this.importantText,
      required this.title,
      required this.iconName,
      required this.action})
      : super(key: key);

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10 * screenScale(context))),
      child: Container(
        height: 210 * screenScale(context),
        width: 350 * screenScale(context),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                  0, 10 * screenScale(context), 0, 10 * screenScale(context)),
              child: Image.asset("assets/images/${iconName}",
                  height: 60 * screenScale(context)),
            ),
            Positioned(
              top: 75 * screenScale(context),
              child: Text(title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15 * fontScale(context),
                      color: Colors.blue)),
            ),
            Positioned(
              top: 105 * screenScale(context),
              left: 25 * screenScale(context),
              right: 25 * screenScale(context),
              child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14 * fontScale(context)),
                      children: [
                        TextSpan(text: mainText),
                        TextSpan(
                            text: importantText,
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold)),
                        TextSpan(text: additionalText)
                      ])),
            ),
            Positioned(
              bottom: 10 * screenScale(context),
              right: 25 * screenScale(context),
              child: TextButton(
                  onPressed: action,
                  child: Text("OK",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14 * fontScale(context)))),
            )
          ],
        ),
      ),
    );
  }
}
