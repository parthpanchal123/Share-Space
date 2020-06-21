import 'package:random_Fun/screens/AppScreens/AllUsers.dart';
import 'package:random_Fun/screens/AppScreens/NewPost.dart';
import 'package:random_Fun/screens/AppScreens/about.dart';
import 'package:random_Fun/screens/AppScreens/dogScreen.dart';
import 'package:random_Fun/screens/AppScreens/donate.dart';
import 'package:random_Fun/screens/AppScreens/joke.dart';
import 'package:random_Fun/screens/AppScreens/todos.dart';
import 'package:random_Fun/screens/AppScreens/userProfile.dart';
import 'package:random_Fun/screens/AuthScreens/auth.dart';
import 'package:random_Fun/screens/AuthScreens/login.dart';
import 'package:random_Fun/screens/AuthScreens/signUp.dart';
import 'package:random_Fun/screens/AuthScreens/signUpHome.dart';
import 'package:random_Fun/screens/homeScreen.dart';

final routes = {
  '/home': (context) => HomeScreen(),
  '/initial': (context) => AuthWidget(),
  '/login': (context) => LoginScreen(),
  'signUp': (context) => SignUp(),
  '/signUpHome': (context) => SignUpHome(),
  '/profile': (context) => UserProfile(),
  '/joke': (context) => Joke(),
  '/newPost': (context) => NewPost(),
  '/allUsers': (context) => AllUsers(),
  '/dog': (context) => DogScreen(),
  '/todo': (context) => Todo(),
  '/about': (context) => About(),
  '/donate': (context) => Donate(),
};
