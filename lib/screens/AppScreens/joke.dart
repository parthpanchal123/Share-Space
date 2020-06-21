import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:random_Fun/Animations/fade_in.dart';
import 'package:random_Fun/models/joke.dart';
import 'package:random_Fun/services/api.dart';
import 'package:random_Fun/values/values.dart';

class Joke extends StatefulWidget {
  @override
  _JokeState createState() => _JokeState();
}

class _JokeState extends State<Joke> {
  bool isLoading = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Fluttertoast.showToast(gravity: ToastGravity.BOTTOM, backgroundColor: AppColors.whiteShade2, msg: "Click on the card to reveal the pun !", timeInSecForIosWeb: 5);
  }

  @override
  Widget build(BuildContext context) {
    final _api = Provider.of<Api>(context, listen: false);
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Color(0xffF7F8FA),
      appBar: AppBar(
        title: Text('Its Joke time :p'),
        elevation: 0.0,
        centerTitle: true,
        actions: <Widget>[
          InkWell(
            onTap: () async {
              setState(() {
                isLoading = true;
                _api.jokes.clear();
              });
              await _api.getJoke().then((value) {
                setState(() {
                  isLoading = false;
                });
                scaffoldKey.currentState.showSnackBar(SnackBar(
                  content: Text("Seems you're having a fun time , New jokes updated !"),
                ));
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Icon(Icons.refresh),
            ),
          )
        ],
      ),
      body: ModalProgressHUD(
        color: AppColors.blueShade2,
        opacity: 0.4,
        inAsyncCall: isLoading,
        progressIndicator: CircularProgressIndicator(),
        child: Container(
            child: FutureBuilder(
          future: _api.getJoke(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return FadeAnimation(1.2, ListView.builder(itemCount: snapshot.data.length, shrinkWrap: true, itemBuilder: (context, index) => joke_card(snapshot.data[index], context)));
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        )),
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //     icon: Icon(FontAwesomeIcons.smileWink),
      //     onPressed: () async {
      // setState(() {
      //   isLoading = true;
      // });
      // await _api.getJoke().then((value) {
      //   setState(() {
      //     isLoading = false;
      //   });
      // });
      //     },
      //     label: Text('Get a new joke')),
    );
  }
}

Widget joke_card(Joke_Model joke, BuildContext context) {
  return FlipCard(
    direction: FlipDirection.HORIZONTAL,
    front: Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 15.0),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          spreadRadius: 3,
          blurRadius: 10,
          offset: Offset(0, 3), // changes position of shadow
        ),
      ], borderRadius: BorderRadius.all(Radius.circular(10.0)), color: Colors.white),
      margin: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Text(
              "Type : ${joke.type}",
              style: TextStyle(fontWeight: FontWeight.w300),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(FontAwesomeIcons.arrowRight),
              ),
              Flexible(
                child: Text(
                  "Question : ${joke.setup}",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18.0),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
    back: Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 15.0),
      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10.0)), color: Colors.white),
      margin: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              "Question : ${joke.setup}",
              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16.0),
            ),
          ),
          Text(
            "Answer : ${joke.punchline}",
            style: TextStyle(fontWeight: FontWeight.w500, fontFamily: 'Aileron', fontStyle: FontStyle.italic, fontSize: 18.0),
          ),
        ],
      ),
    ),
  );

  // child: Column(
  //   crossAxisAlignment: CrossAxisAlignment.start,
  //   children: <Widget>[
  //     Text(
  //       "Catergory : ${joke.type}",
  //       textAlign: TextAlign.left,
  //       style: TextStyle(),
  //     ),
  //     FlipCard(
  //       flipOnTouch: true,
  //       direction: FlipDirection.HORIZONTAL,
  //       front: ListTile(
  //         title: Text(joke.setup),
  //       ),
  //       back: ListTile(
  //         title: Text(joke.punchline),
  //       ),
  //     ),
  //   ],
  // ),
}
