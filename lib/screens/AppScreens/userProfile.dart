import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:random_Fun/models/user.dart';
import 'package:random_Fun/services/Authenticate.dart';
import 'package:random_Fun/services/database.dart';
import 'package:random_Fun/services/firebase_storage.dart';
import 'package:random_Fun/services/image_picker.dart';
import 'package:random_Fun/values/values.dart';
import 'package:random_Fun/widgets/custom_button.dart';
import 'package:time_formatter/time_formatter.dart';

String curr_user_id;

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  _getCurrentUser() async {
    final auth = Provider.of<Authenticate>(context);
    curr_user_id = await auth.getCurrentUserID();
    // print("The true user is" + true_id);
    assert(curr_user_id != null);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _getCurrentUser();
    final db = Provider.of<Database>(context, listen: false);
    final scaffoldKey = GlobalKey<ScaffoldState>();
    final routes = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    final String uid = routes['uid'];

    bool isMe = false;

    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: StreamBuilder(
        stream: db.getUserDetails(uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ProfileView(user: snapshot.data, uid: uid, scaffoldKey: scaffoldKey, isMe: curr_user_id == uid);
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class ProfileView extends StatefulWidget {
  final User user;
  final bool isMe;
  final String uid;
  final GlobalKey<ScaffoldState> scaffoldKey;

  //  ProfileView({ user,  context,  uid,
  //    scaffoldKey});

  const ProfileView({this.user, this.uid, this.scaffoldKey, this.isMe});
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    final fullWidth = MediaQuery.of(context).size.width;
    final fullHeight = MediaQuery.of(context).size.height;
    final db = Provider.of<Database>(context, listen: false);
    final statusController = TextEditingController(text: widget.user.status);
    final image_service = Provider.of<Image_Picker>(context, listen: false);
    final storage = Provider.of<Storage>(context, listen: false);
    bool isLoading = false;
    String now = widget.isMe == true ? curr_user_id : widget.uid;
    Random random = new Random();

    final key = GlobalKey<FormState>();
    String _status;

    return ModalProgressHUD(
      inAsyncCall: isLoading,
      progressIndicator: CircularProgressIndicator(),
      child: SingleChildScrollView(
        child: Container(
          color: Theme.of(context).accentColor,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(color: Theme.of(context).accentColor),
                width: fullWidth,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Stack(
                      alignment: Alignment.topLeft,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Flexible(
                                flex: 2,
                                child: Hero(
                                  tag: Text('profile'),
                                  child: InkWell(
                                    onTap: () async {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      if (widget.isMe) {
                                        await image_service.pickImage(source: ImageSource.gallery).then((file) async {
                                          if (file == null) {
                                            setState(() {
                                              isLoading = false;
                                            });
                                            widget.scaffoldKey.currentState.showSnackBar(SnackBar(
                                              content: Text('You did not select any new picture !'),
                                            ));
                                          } else {
                                            widget.scaffoldKey.currentState.showSnackBar(SnackBar(
                                              content: Text('Hold back tight! It might take a while to update your dp !'),
                                            ));
                                          }

                                          await storage.uploadProfileImage(file, widget.uid).then((downloadUrl) async {
                                            await db.updatePhotoUrl(widget.uid, downloadUrl).then((status) {
                                              setState(() {
                                                isLoading = false;
                                              });
                                              widget.scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Profile Picture Updated ! You are looking Awesome :p')));
                                            });
                                          });
                                        });
                                      }
                                    },
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.only(top: 10.0),
                                          height: 115.0,
                                          width: 115.0,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(color: Colors.white, width: 2),
                                            image: DecorationImage(fit: BoxFit.fill, image: CachedNetworkImageProvider(widget.user.photoUrl)),
                                          ),
                                        ),
                                        widget.isMe
                                            ? Container(
                                                margin: EdgeInsets.only(left: 95, top: 90),
                                                width: 50.0,
                                                height: 50.0,
                                                decoration: BoxDecoration(border: Border.all(color: Colors.black), shape: BoxShape.circle, color: Colors.white),
                                                child: Icon(
                                                  Icons.edit,
                                                  color: Theme.of(context).accentColor,
                                                ))
                                            : Container(),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 3,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Container(
                                        height: MediaQuery.of(context).size.height * 0.2,
                                        margin: EdgeInsets.only(top: 40.0, left: 40.0, right: 10.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            Hero(
                                              tag: Text("displayName"),
                                              child: Text(
                                                widget.user.displayName,
                                                style: TextStyle(color: Colors.white),
                                              ),
                                            ),
                                            Hero(
                                              tag: Text('status'),
                                              child: Text(
                                                'Status : ${widget.user.status}',
                                                style: TextStyle(color: Colors.white),
                                              ),
                                            ),
                                            Text(
                                              'Joined : ${widget.user.memberSince}',
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          ],
                                        )),
                                    widget.isMe
                                        ? InkWell(
                                            onTap: () {
                                              showDialog(
                                                  barrierDismissible: true,
                                                  context: context,
                                                  builder: (context) => AlertDialog(
                                                        title: Text("Heyy , ${widget.user.displayName.split(" ")[0]} whats up ?"),
                                                        content: Container(
                                                          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(40.0))),
                                                          child: Form(
                                                            key: key,
                                                            child: Column(
                                                              mainAxisSize: MainAxisSize.min,
                                                              children: <Widget>[
                                                                TextFormField(
                                                                  autofocus: true,
                                                                  textInputAction: TextInputAction.done,
                                                                  controller: statusController,
                                                                  validator: (status) {
                                                                    print(status.length);
                                                                    if (status.isEmpty || status == '' || status.length > 50 || status.length < 2) {
                                                                      return "Status should be between 2 to 50 characters.";
                                                                    } else if (status == widget.user.status) {
                                                                      return "You did not update any new status";
                                                                    }
                                                                  },
                                                                  keyboardType: TextInputType.multiline,
                                                                  onChanged: (status) {
                                                                    _status = status;
                                                                  },
                                                                ),
                                                                SizedBox(
                                                                  height: 10.0,
                                                                ),
                                                                CustomButton(
                                                                  title: 'Update Status',
                                                                  textStyle: TextStyle(color: Colors.white),
                                                                  elevation: Sizes.ELEVATION_8,
                                                                  color: Theme.of(context).accentColor,
                                                                  height: Sizes.HEIGHT_40,
                                                                  onPressed: () async {
                                                                    if (key.currentState.validate()) {
                                                                      db.updateStatus(widget.uid, _status).whenComplete(() {
                                                                        setState(() {});
                                                                        widget.scaffoldKey.currentState.showSnackBar(SnackBar(
                                                                          content: Text("Status Updated !"),
                                                                        ));
                                                                        Navigator.pop(context);
                                                                      }).catchError((errorMsg) {
                                                                        print(errorMsg);
                                                                      });
                                                                    }
                                                                  },
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ));
                                            },
                                            child: Container(
                                              width: 140.0,
                                              height: 35.0,
                                              decoration: BoxDecoration(gradient: Gradients.curvesGradient0, borderRadius: BorderRadius.all(Radius.circular(40.0))),
                                              margin: EdgeInsets.only(bottom: 10.0),
                                              child: CustomButton(
                                                icon: Icon(Icons.edit),
                                                title: 'Update Status',
                                                color: Colors.white,
                                                textStyle: TextStyle(color: Colors.white),
                                              ),
                                            ),
                                          )
                                        : Container()
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
                    color: Colors.white,
                  ),
                  child: Container(
                      child: StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance.collection('all_posts/$now/my_posts').orderBy('createdAt', descending: true).snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data.documents.length == 0) {
                          return Container(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(top: 10.0),
                                  child: Text(
                                    'All recent posts will appear here !',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 10.0),
                                  child: Image.asset(
                                    'assets/images/empty.png',
                                    height: MediaQuery.of(context).size.height * 0.25,
                                  ),
                                ),
                                widget.isMe
                                    ? Text(
                                        'Awww snap , your friends are bored . Suggest them something to do by creating a post !',
                                        textAlign: TextAlign.center,
                                      )
                                    : Container(),
                                widget.isMe == true
                                    ? Container(
                                        margin: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
                                        width: 200.0,
                                        child: CustomButton(
                                          onPressed: () {
                                            Navigator.pushReplacementNamed(context, '/newPost', arguments: {'uid': widget.user.uid});
                                          },
                                          title: 'Create a post !',
                                          textStyle: TextStyle(color: Colors.white),
                                          elevation: Sizes.ELEVATION_8,
                                          color: Theme.of(context).accentColor,
                                          height: Sizes.HEIGHT_40,
                                        ),
                                      )
                                    : Container()
                              ],
                            ),
                          );
                        } else {
                          return FutureBuilder(
                            future: db.getUser(now),
                            builder: (context, snap) {
                              if (!snap.hasData) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              return ListView(
                                shrinkWrap: true,
                                children: snapshot.data.documents.map((post) {
                                  final curr_post = post.data;
                                  final timeOfUpload = formatTime(curr_post['createdAt'].seconds * 1000);

                                  return Container(
                                    margin: EdgeInsets.all(15.0),
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
                                        Container(
                                          height: MediaQuery.of(context).size.height * 0.14,
                                          decoration: BoxDecoration(
                                            gradient: GradientColors[random.nextInt(5)],
                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
                                          ),
                                          child: Container(
                                            margin: EdgeInsets.only(top: 10.0),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets.all(10.0),
                                                  child: Container(
                                                    height: 50.0,
                                                    width: 50.0,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(color: Colors.white, width: 1),
                                                      image: new DecorationImage(fit: BoxFit.fill, image: CachedNetworkImageProvider(snap.data['photoUrl'])),
                                                    ),
                                                  ),
                                                ),
                                                Column(
                                                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Container(
                                                        margin: EdgeInsets.only(top: 15.0),
                                                        child: Text(
                                                          snap.data['displayName'],
                                                          style: TextStyle(color: Colors.white),
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
                                              ],
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
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Text(
                                                      "My likes in it : ${curr_post['desc']}",
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0, bottom: 10.0),
                                                    child: Text("Where to find it : ${curr_post['link']}"),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                }).toList(),
                              );
                            },
                          );
                        }
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
