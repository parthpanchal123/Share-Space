import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:random_Fun/models/user.dart';
import 'package:random_Fun/screens/AppScreens/AllUsers.dart';
import 'package:random_Fun/services/Authenticate.dart';
import 'package:random_Fun/services/database.dart';
import 'package:random_Fun/services/push_notification-_service.dart';
import 'package:random_Fun/values/values.dart';
import 'package:random_Fun/widgets/custom_button.dart';
import 'package:time_formatter/time_formatter.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User user;
  GlobalKey _bottomNavigationKey = GlobalKey();
  CurvedNavigationBarState navBarState;
  bool isLiked = false;

  @override
  void initState() {
    _initNotifs(context);
    super.initState();
  }

  void _initNotifs(BuildContext context) async {
    final fcm = Provider.of<PushNotificationService>(context, listen: false);
    await fcm.init();
  }

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context, listen: false);
    final db = Provider.of<Database>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 5.0),
              child: Container(width: 35.0, height: 35.0, child: Image.asset('assets/images/app_icon.png')),
            ),
            Text(
              'Share Space',
              style: TextStyle(fontFamily: 'Aileron', fontWeight: FontWeight.w900),
            ),
          ],
        ),
        elevation: 0.0,
        actions: <Widget>[
          PopupMenuButton(
            offset: Offset(0, 3),
            onSelected: choiceAction,
            itemBuilder: (BuildContext context) {
              return StringConst.menuChoices.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Row(
                    children: <Widget>[Text(choice), Icon(Icons.person)],
                  ),
                );
              }).toList();
            },
          ),
        ],
      ),
      drawer: StreamBuilder(
          stream: db.getUserDetails(user.uid),
          builder: (context, snapshot) {
            if (snapshot.hasData)
              return drawer(context, snapshot.data);
            else
              return Center(
                child: CircularProgressIndicator(),
              );
          }),
      body: WillPopScope(
        onWillPop: _onWillPop,
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('all_posts').orderBy('createdAt', descending: true).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                else if (snapshot.data.documents.length == 0) {
                  return Center(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                            child: Image.asset(
                              'assets/images/empty.png',
                              height: 200,
                            ),
                          ),
                          Text(
                            'Too empty here !',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return ListView(
                      controller: ScrollController(initialScrollOffset: 1.0),
                      shrinkWrap: true,
                      children: snapshot.data.documents.map((doc) {
                        return StreamBuilder<QuerySnapshot>(
                          stream: Firestore.instance.collection('all_posts/${doc.documentID}/my_posts').orderBy('createdAt', descending: true).limit(1).snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return FutureBuilder(
                                future: db.getUser(doc.data['postOwner']),
                                builder: (context, snap) {
                                  if (!snap.hasData) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }

                                  return ListView(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    children: snapshot.data.documents.map((post) {
                                      final curr_post = post.data;
                                      final timeOfUpload = formatTime(curr_post['createdAt'].seconds * 1000);

                                      return Container(
                                        margin: EdgeInsets.all(10.0),
                                        height: 320,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.3),
                                              spreadRadius: 3,
                                              blurRadius: 10,
                                              offset: Offset(0, 3), // changes position of shadow
                                            ),
                                          ],
                                        ),

                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.pushNamed(context, '/profile', arguments: {'uid': doc.documentID});
                                              },
                                              child: Container(
                                                height: MediaQuery.of(context).size.height * 0.14,
                                                decoration: BoxDecoration(
                                                  gradient: GradientColors[0],
                                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
                                                ),
                                                child: Container(
                                                  child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                                        child: Hero(
                                                          tag: Text('profile'),
                                                          child: Container(
                                                            height: 60.0,
                                                            width: 60.0,
                                                            decoration: BoxDecoration(
                                                              shape: BoxShape.circle,
                                                              border: Border.all(color: Colors.white, width: 1),
                                                              image: new DecorationImage(fit: BoxFit.fill, image: CachedNetworkImageProvider(snap.data['photoUrl'])),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: <Widget>[
                                                          Container(
                                                              child: Hero(
                                                            tag: Text('displayName'),
                                                            child: Text(
                                                              snap.data['displayName'],
                                                              style: TextStyle(color: Colors.white, fontSize: 14.0),
                                                            ),
                                                          )),
                                                          Text(
                                                            "Category : ${curr_post['category']}",
                                                            style: TextStyle(color: Colors.white),
                                                          ),
                                                          Text(
                                                            '$timeOfUpload',
                                                            style: TextStyle(color: Colors.white),
                                                          )
                                                        ],
                                                      ),
                                                      Expanded(
                                                        child: Center(
                                                          child: GestureDetector(
                                                            onTap: () async {
                                                              if (!isLiked) {
                                                                Firestore.instance.runTransaction((transaction) async {
                                                                  final record = post.reference;
                                                                  await transaction.update(record, {'likes': FieldValue.increment(1)});
                                                                });
                                                              } else {
                                                                Firestore.instance.runTransaction((transaction) async {
                                                                  final record = post.reference;
                                                                  await transaction.update(record, {'likes': post['likes'] != 0 ? post['likes'] - 1 : 0});
                                                                });
                                                              }
                                                              // Firestore.instance.collection('all_posts').document(doc.documentID).updateData({'likedByMe': !doc.data['likedByMe']});
                                                              isLiked = !isLiked;
                                                            },
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: Container(
                                                                margin: EdgeInsets.all(8.0),
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                                  children: <Widget>[
                                                                    Icon(
                                                                      isLiked ? Icons.favorite : Icons.favorite_border,
                                                                      color: Colors.white,
                                                                    ),
                                                                    SizedBox(
                                                                      width: 4.0,
                                                                    ),
                                                                    Text(
                                                                      curr_post['likes'].toString(),
                                                                      style: TextStyle(color: Colors.white),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Container(
                                                  margin: EdgeInsets.only(left: 8.0),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.max,
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text(
                                                          "Status : ${curr_post['todo']}",
                                                          style: TextStyle(fontSize: 14.0),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text(
                                                          "My likes in it : ${curr_post['desc']}",
                                                          textAlign: TextAlign.left,
                                                          style: TextStyle(fontSize: 14.0),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0, bottom: 10.0),
                                                        child: Text("Where to find it : ${curr_post['link']}", style: TextStyle(fontSize: 14.0)),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),

                                        // onTap: () {},
                                        // leading: Image.network(snap.data['photoUrl']),
                                        // trailing: Text(curr_post['category']),
                                        // title: Text(curr_post['todo']),
                                        // subtitle: Text(curr_post['desc']),
                                      );
                                    }).toList(),
                                  );
                                },
                              );
                            } else {
                              return Center(child: CircularProgressIndicator());
                            }
                          },
                        );
                      }).toList());
                }
              },
            ),
          ),
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        color: Theme.of(context).primaryColor,
        height: 55,
        index: 2,
        backgroundColor: Colors.white,
        items: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 8.0, bottom: 2.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.people, size: 30, color: Colors.white),
                Text(
                  'All Users',
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 8.0, bottom: 2.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.edit, size: 30, color: Colors.white),
                Text(
                  'Create',
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 8.0, bottom: 2.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.home,
                  size: 30,
                  color: Colors.blue,
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 8.0, bottom: 2.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(FontAwesomeIcons.smileBeam, size: 30, color: Colors.white),
                Text(
                  'Try this',
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 8.0, bottom: 2.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.info, size: 30, color: Colors.white),
                Text(
                  'About',
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeftWithFade, child: AllUsers())).whenComplete(() {
                setState(() {
                  navBarState = _bottomNavigationKey.currentState;
                  navBarState.setPage(2);
                });
              });

              // Navigator.pushNamed(
              //   context,
              //   '/allUsers',
              // ).whenComplete(() {
              //   setState(() {
              //     navBarState = _bottomNavigationKey.currentState;
              //     navBarState.setPage(2);
              //   });
              // });

              break;
            case 1:
              Navigator.pushNamed(context, '/newPost', arguments: {'uid': user.uid}).whenComplete(() {
                setState(() {
                  navBarState = _bottomNavigationKey.currentState;
                  navBarState.setPage(2);
                });
              });
              break;
            case 3:
              Navigator.pushNamed(context, '/todo', arguments: {'uid': user.uid}).whenComplete(() {
                setState(() {
                  navBarState = _bottomNavigationKey.currentState;
                  navBarState.setPage(2);
                });
              });
              break;
            case 4:
              Navigator.pushNamed(context, '/about').whenComplete(() {
                setState(() {
                  navBarState = _bottomNavigationKey.currentState;
                  navBarState.setPage(2);
                });
              });
              break;
          }
        },
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => showExitDialog(context),
        )) ??
        false;
  }

  AlertDialog showExitDialog(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Image.asset(
            'assets/images/app_icon.png',
            width: 50.0,
            height: 50.0,
          ),
          SizedBox(
            width: 8.0,
          ),
          Text(
            'Share Space',
            style: TextStyle(fontSize: 22, color: Colors.black),
          ),
        ],
      ),
      content: Text(
        'Do you want to exit 😔 ?',
        style: TextStyle(fontSize: 16, color: Colors.black),
      ),
      actions: <Widget>[
        Container(
          width: 100.0,
          child: CustomButton(
            hasIcon: true,
            icon: Icon(FontAwesomeIcons.timesCircle),
            height: 40,
            onPressed: () => Navigator.of(context).pop(false),
            title: 'No',
          ),
        ),
        Container(
          width: 100.0,
          child: CustomButton(
            hasIcon: true,
            icon: Icon(FontAwesomeIcons.checkCircle),
            height: 40,
            onPressed: () => SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
            title: 'Yes',
          ),
        ),
      ],
    );
  }

  void choiceAction(String choice) async {
    final auth = Provider.of<Authenticate>(context, listen: false);
    final user = Provider.of<User>(context, listen: false);

    if (choice == StringConst.Profile) {
      Navigator.pushNamed(context, '/profile', arguments: {'uid': user.uid});
    } else if (choice == StringConst.SignOut) {
      await auth.logOut().whenComplete(() {});
    }
  }
}

Widget drawer(BuildContext context, User user) {
  return Drawer(
      child: ListView(
    padding: EdgeInsets.zero,
    children: <Widget>[
      DrawerHeader(
          decoration: BoxDecoration(color: Theme.of(context).accentColor, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Container(
                  height: 90.0,
                  width: 90.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1),
                    image: new DecorationImage(fit: BoxFit.fill, image: CachedNetworkImageProvider(user.photoUrl)

                        // image :Image(
                        //   image: CachedNetworkImageProvider(user['photoUrl'])),
                        ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 2.0),
                child: Text(
                  'Welcome , ' + user.displayName,
                  style: TextStyle(color: Colors.white, fontSize: 16.0),
                ),
              ),
            ],
          )),
      Padding(
        padding: const EdgeInsets.only(left: 15.0, top: 8.0, bottom: 15.0),
        child: Text(
          'Other fun things to try !',
          style: TextStyle(fontSize: 16),
        ),
      ),
      Divider(),
      ListTile(
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/joke');
          },
          title: Text(
            'Guess the Puns !',
            style: TextStyle(fontSize: 16.0),
          ),
          trailing: Icon(FontAwesomeIcons.smileWink)),
      ListTile(
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/dog');
          },
          title: Text(
            'Meet a  🐕 ',
            style: TextStyle(fontSize: 16.0),
          ),
          trailing: Icon(FontAwesomeIcons.dog)),
    ],
  ));
}
