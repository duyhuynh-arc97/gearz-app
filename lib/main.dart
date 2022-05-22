import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:itproject_gadget_store/screens/main/main_screen.dart';
import 'package:itproject_gadget_store/screens/start/onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var mail = await preferences.getString("mail");
  runApp(mail != null
      ? MyApp(
          child: MainScreen(
          userMail: mail,
        ))
      : MyApp(child: OnboardingScreen()));
}

class MyApp extends StatelessWidget {
  final Widget? child;
  const MyApp({Key? key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'OpenSans'),
        home: child);
  }
}
