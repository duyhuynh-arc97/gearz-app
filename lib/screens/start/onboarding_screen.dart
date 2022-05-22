import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:itproject_gadget_store/controllers/app_controller.dart';
import 'package:itproject_gadget_store/screens/start/start_screen.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(children: [
          IntroductionScreen(
            globalBackgroundColor: Colors.white,
            pages: [
              _slidingPages(
                  title: "Lastest & stylish gadgets",
                  desc:
                      "Our store specializes in providing the latest gadgets on the market with a variety of categories",
                  imgFile: "page1.png",
                  height: 280,
                  paddingBottom: 30),
              _slidingPages(
                  title: "Famous brands",
                  desc:
                      "We bring you gadgets from global technology brands and a wide range of models",
                  imgFile: "page2.png",
                  height: 280,
                  paddingBottom: 30),
              _slidingPages(
                  title: "Shopping anywhere",
                  desc:
                      "Just install our app, you can enjoy shopping anywhere and whenever you want",
                  imgFile: "page3.png",
                  height: 300,
                  paddingBottom: 15),
              _slidingPages(
                  title: "Fast & Convenient",
                  desc:
                      "With a team of professional shipping staffs, we guarantee to deliver in the shortest time",
                  imgFile: "page4.png",
                  height: 280,
                  paddingBottom: 25),
              _slidingPages(
                  title: "Guarantee",
                  desc:
                      "You can feel free in shopping and maintaining products when there is any issues",
                  imgFile: "page5.png",
                  height: 280,
                  paddingBottom: 15),
            ],
            dotsDecorator: DotsDecorator(
                activeColor: Colors.orange,
                activeShape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(10 * screenScale(context))),
                size: Size(8 * screenScale(context), 8 * screenScale(context)),
                activeSize:
                    Size(30 * screenScale(context), 8 * screenScale(context)),
                spacing: EdgeInsets.all(5 * screenScale(context))),
            showDoneButton: false,
            showSkipButton: false,
            showNextButton: false,
            isTopSafeArea: true,
            isBottomSafeArea: true,
            controlsMargin: EdgeInsets.only(bottom: 130 * screenScale(context)),
          ),
          Positioned(
            height: 47.5 * screenScale(context),
            bottom: 47.5 * screenScale(context),
            left: 30 * screenScale(context),
            right: 30 * screenScale(context),
            child: ElevatedButton(
              onPressed: () => Navigator.pushReplacement(
                  context, animatedRoute(StartScreen())),
              child: Text(
                "Get Started",
                style: TextStyle(
                  fontSize: 17 * fontScale(context),
                  fontWeight: FontWeight.w900,
                ),
              ),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(7 * screenScale(context))),
                primary: Color(hexColor("#346ec9")),
              ),
            ),
          )
        ]),
      ),
    );
  }

  //The sliding pages
  PageViewModel _slidingPages(
      {required String title,
      required String desc,
      required String imgFile,
      required double height,
      required double paddingBottom}) {
    return PageViewModel(
      title: title,
      image: ClipRRect(
        borderRadius: BorderRadius.circular(30 * screenScale(context)),
        child: Image.asset(
          "assets/images/${imgFile}",
          height: height,
          fit: BoxFit.cover,
        ),
      ),
      body: desc,
      decoration: PageDecoration(
        imagePadding: EdgeInsets.fromLTRB(30 * screenScale(context), 0,
            30 * screenScale(context), paddingBottom * screenScale(context)),
        descriptionPadding: EdgeInsets.all(30 * screenScale(context)),
        bodyTextStyle: TextStyle(
          fontSize: 18 * fontScale(context),
          color: Colors.black,
        ),
        titleTextStyle: TextStyle(
          fontSize: 30 * fontScale(context),
          color: Colors.blue,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
