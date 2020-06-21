import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:random_Fun/models/user.dart';
import 'package:random_Fun/screens/AuthScreens/signUpHome.dart';
import 'package:random_Fun/screens/homeScreen.dart';
import 'package:random_Fun/services/Authenticate.dart';

class AuthWidget extends StatefulWidget {
  @override
  _AuthWidgetState createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<Authenticate>(context);

    return StreamBuilder(
      stream: _auth.onStateChanged,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          final user = snapshot.data;
          if (user != null) {
            return Provider<User>.value(
              value: user,
              child: HomeScreen(),
            );
          } else {
            return SignUpHome();
          }
        } else {
          return SignUpHome();
        }
      },
    );
  }
}
