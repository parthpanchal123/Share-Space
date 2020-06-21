import 'package:flutter/material.dart';
import 'package:flutter_overboard/flutter_overboard.dart';

final pages = [
  PageModel(color: Colors.indigo, imageAssetPath: 'assets/images/welcome.png', title: 'Welcome to , Share Space !', body: 'A fun social place where we together fight boredom !', doAnimateImage: true),
  PageModel.withChild(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 10.0, top: 25.0),
            child: Column(
              children: <Widget>[
                Image.asset('assets/images/friends.png', width: 200.0, height: 200.0),
                Text(
                  'How it works ?',
                  style: TextStyle(color: Colors.white, fontSize: 30),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              margin: EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      String.fromCharCode(0x2022) + " " + "Create a post describing an interesting thing you're doing . For eg : Reading an interesting book or binge watching some series .",
                      style: TextStyle(color: Colors.white, fontSize: 15.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(String.fromCharCode(0x2022) + " " + "Once created a post , you can see it posted on the home feed .", style: TextStyle(color: Colors.white, fontSize: 15.0)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(String.fromCharCode(0x2022) + " " + "Your friends can now get your amazing idea and like your post .", style: TextStyle(color: Colors.white, fontSize: 15.0)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      String.fromCharCode(0x2022) + " " + "Yayy ,Pat yourself ! , You just helped your friends .",
                      style: TextStyle(color: Colors.white, fontSize: 15.0),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      color: Colors.purple,
      doAnimateChild: true),
  PageModel.withChild(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 10.0, top: 25.0),
            child: Column(
              children: <Widget>[
                Image.asset('assets/images/chill.png', width: 300.0, height: 300.0),
                Text(
                  'What else ?',
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Heyy , but wait what if your friends too dont have any ideas ! Unless they get one , try Guessing the Puns 😁 and also some random dog 🐕 images from the world .',
                      style: TextStyle(color: Colors.white, fontSize: 15.0),
                      textAlign: TextAlign.center,
                    )),
              ],
            ),
          ),
        ],
      ),
      color: Colors.orange,
      doAnimateChild: true),
];

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OverBoard(
        pages: pages,
        showBullets: true,
        skipCallback: () {
          Navigator.pop(context);
        },
        finishCallback: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
