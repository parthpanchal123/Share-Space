import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:random_Fun/services/database.dart';
import 'package:random_Fun/values/values.dart';
import 'package:random_Fun/widgets/custom_button.dart';

class AllUsers extends StatefulWidget {
  @override
  _AllUsersState createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {
  String _name = '';
  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController(text: '');
    final _formKey = GlobalKey<FormState>();

    final db = Provider.of<Database>(context);
    final focus = FocusNode();

    return Scaffold(
        appBar: AppBar(
          title: Text('All Users'),
          centerTitle: true,
          actions: <Widget>[
            InkWell(
              onTap: () {
                showDialog(
                    barrierDismissible: true,
                    context: context,
                    builder: (context) => AlertDialog(
                          content: Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(40.0))),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  TextFormField(
                                    autofocus: true,
                                    textInputAction: TextInputAction.done,
                                    controller: nameController,
                                    decoration: InputDecoration(hintText: "Enter user's name to search .."),
                                    validator: (name) {
                                      if (name.isEmpty || name == '' || name.length > 20) {
                                        return "Enter a valid name to search !. ";
                                      }
                                    },
                                    onFieldSubmitted: (name) {
                                      _name = name;
                                      Navigator.pop(context);
                                    },
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  CustomButton(
                                    title: 'Search',
                                    textStyle: TextStyle(color: Colors.white),
                                    elevation: Sizes.ELEVATION_8,
                                    color: Theme.of(context).accentColor,
                                    height: Sizes.HEIGHT_40,
                                    onPressed: () async {
                                      if (_formKey.currentState.validate()) {
                                        _name = nameController.text;
                                        Navigator.pop(context);
                                      }
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                        ));
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Icon(FontAwesomeIcons.search),
              ),
            )
          ],
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 15.0, right: 15.0, top: 8.0),
                child: Column(
                  children: <Widget>[],
                ),
              ),
              Expanded(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: StreamBuilder<QuerySnapshot>(
                      stream: Firestore.instance.collection('users').where('displayName', isEqualTo: _name == '' ? null : _name).snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (_name == '') {
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                              child: ListView(
                                shrinkWrap: true,
                                itemExtent: 100,
                                controller: ScrollController(initialScrollOffset: 1.0),
                                children: snapshot.data.documents.map((document) {
                                  return UserCard(document, context);
                                }).toList(),
                              ),
                            );
                          } else {
                            return FutureBuilder<dynamic>(
                              future: db.getUserByName(_name),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  if (snapshot.data.length == 0) {
                                    return Center(
                                      child: Container(
                                        height: MediaQuery.of(context).size.height,
                                        color: Colors.white,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Container(width: 200.0, height: 200.0, child: Image.asset('assets/images/noUser.png')),
                                            Center(
                                              child: Text('No such user found !'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }

                                  return ListView.builder(
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (context, index) => UserCard(snapshot.data[index], context),
                                  );
                                } else {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              },
                            );
                          }
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      }),
                ),
              )
            ],
          ),
        ));
  }
}

Widget UserCard(DocumentSnapshot user, BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.pushNamed(context, '/profile', arguments: {'uid': user['uid']});
    },
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 100.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 3,
              blurRadius: 10,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            Hero(
              tag: Text('profile'),
              child: Container(
                margin: EdgeInsets.only(left: 10.0),
                height: 60.0,
                width: 60.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 1),
                  image: new DecorationImage(fit: BoxFit.fill, image: CachedNetworkImageProvider(user['photoUrl'])),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(left: 14.0),
                    child: Hero(
                      tag: Text('displyaName'),
                      child: Text(
                        user['displayName'],
                        style: TextStyle(fontSize: 18),
                      ),
                    )),
                Container(margin: EdgeInsets.only(left: 14.0), child: Hero(tag: Text('status'), child: Text(user['status']))),
              ],
            )
          ],
        ),
      ),
    ),
  );
}
