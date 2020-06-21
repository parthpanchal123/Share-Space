import 'dart:async';

import 'package:flare_loading/flare_loading.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:random_Fun/Animations/fade_in.dart';
import 'package:random_Fun/screens/AuthScreens/auth.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          margin: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FadeAnimation(
                  1.3,
                  Text(
                    'Share Space',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 40.0),
                  )),
              FadeAnimation(
                  1.6,
                  Container(
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 3,
                        blurRadius: 10,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ]),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset('assets/images/pablo-friendship.png'),
                    ),
                  )),
              FadeAnimation(
                  2.0,
                  Text(
                    'Welcome to the party ! 🎉',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20.0),
                  )),
              FadeAnimation(
                  2.3,
                  Text(
                    '#social 🌐  #fun 😉 ',
                    style: TextStyle(fontWeight: FontWeight.w100, fontSize: 20.0),
                  )),
              FadeAnimation(
                  2.5,
                  Container(
                      width: 50.0,
                      height: 50.0,
                      child: FlareLoading(
                        name: 'assets/flares/animation.flr',
                        startAnimation: 'active',
                        loopAnimation: 'active',
                        onError: (err, stack) {
                          print(err);
                        },
                        onSuccess: (_) {
                          print('Finished');
                        },
                      )))
            ],
          ),
        ));
  }

  startTime() async {
    var _duration = new Duration(seconds: 5);
    return Timer(_duration, () {
      Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.rightToLeftWithFade, child: AuthWidget()));
    });
  }
}
