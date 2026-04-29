import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chatbot_app/appconstants/color_constant.dart';
import 'package:chatbot_app/appconstants/text_constant.dart';
import 'package:chiclet/chiclet.dart';
import 'package:flutter/material.dart';

class Getstarted extends StatefulWidget {
  const Getstarted({super.key});

  @override
  State<Getstarted> createState() => _GetstartedState();
}

class _GetstartedState extends State<Getstarted> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ChicletOutlinedAnimatedButton(
                  backgroundColor: ColorConstant.color_bluelight_shade,
                  onPressed: () {},
                  buttonType: ChicletButtonTypes.roundedRectangle,
                  child: Text(
                    Textconstant.txt_getstarted,
                    style: TextStyle(color: ColorConstant.color_black),
                  ),
                ),
              ),

              Text(Textconstant.txt_alreadyhaveanaccount),
            ],
          ),
        ),
        backgroundColor: ColorConstant.color_darkblueshade500,
        appBar: AppBar(
          backgroundColor: ColorConstant.color_blueDark_shade,
          leading: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Image.asset('assets/icon/appicon.png'),
          ),
          title: Text(
            Textconstant.txt_appname,
            style: TextStyle(
              color: ColorConstant.color_white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 30.0,
              ),
              child: SizedBox(
                height: 130,
                child: AnimatedTextKit(
                  repeatForever: true,
                  displayFullTextOnTap: true,
                  pause: Duration(seconds: 2),
                  animatedTexts: [
                    TyperAnimatedText(
                      Textconstant.txt_heading1,
                      speed: Duration(milliseconds: 90),

                      textStyle: Theme.of(context).textTheme.displayLarge,
                    ),

                    TyperAnimatedText(
                      Textconstant.txt_heading2,
                      speed: Duration(milliseconds: 90),

                      textStyle: Theme.of(context).textTheme.displayLarge,
                    ),
                    TyperAnimatedText(
                      Textconstant.txt_heading3,
                      speed: Duration(milliseconds: 90),

                      textStyle: Theme.of(context).textTheme.displayLarge,
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 14.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Container(
                      padding: EdgeInsets.all(15),

                      decoration: BoxDecoration(
                        color: ColorConstant.color_white.withAlpha(30),
                        border: Border.all(
                          width: 2,
                          color: ColorConstant.color_white.withAlpha(30),
                        ),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: SizedBox(
                              height: 30,
                              width: 30,
                              child: Image.asset(
                                'assets/icon/icon_fasttrack.png',
                              ),
                            ),
                          ),
                          Text(
                            Textconstant.txt_fasttrack,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Container(
                      padding: EdgeInsets.all(15),

                      decoration: BoxDecoration(
                        color: ColorConstant.color_white.withAlpha(30),

                        border: Border.all(
                          color: ColorConstant.color_white.withAlpha(30),

                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: SizedBox(
                              height: 30,
                              width: 30,
                              child: Image.asset(
                                'assets/icon/icon_deepfocus.png',
                              ),
                            ),
                          ),
                          Text(
                            Textconstant.txt_deepfocus,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
