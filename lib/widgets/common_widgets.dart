import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:itproject_gadget_store/controllers/app_controller.dart';

//Loading text in button
Row loadingText(String text, BuildContext context) {
  return Row(
    children: [
      SizedBox(
        height: 20*screenScale(context),
        width: 20*screenScale(context),
        child: CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 2.5*screenScale(context),
        ),
      ),
      SizedBox(
        width: 10*screenScale(context),
      ),
      Text(
        "${text}...",
        style: TextStyle(fontSize: 17*fontScale(context), fontWeight: FontWeight.w900),
      )
    ],
    mainAxisAlignment: MainAxisAlignment.center,
  );
}

//Back button
Widget backBtn(BuildContext context) {
  return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.only(top: 10 * screenScale(context)),
      child: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Ionicons.chevron_back_outline,
            size: 24 * screenScale(context),
          )));
  
}

//Introduction text
Text introText(String text, BuildContext context) {
  return Text("${text}",
      style: TextStyle(
          fontSize: 30 * fontScale(context),
          color: Colors.blue,
          fontWeight: FontWeight.w900));
}

//Cover image
Container introImage(String imgPath, double h, double w, BuildContext context) {
  return Container(
    alignment: Alignment.center,
    child: Image(
        image: AssetImage("assets/images/${imgPath}"),
        height: h * screenScale(context),
        width: w * screenScale(context)),
  );
}

//Main content in the screen
Text mainText(String text, BuildContext context) {
  return Text(text,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 15 * screenScale(context)));
}
