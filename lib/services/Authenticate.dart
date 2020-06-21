import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:random_Fun/models/user.dart';

class Authenticate {
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
    ],
  );
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> getCurrentUserID() async {
    final user = await _auth.currentUser();
    return user.uid;
  }

//Handling Google sign in
  Future<User> handleSignIn() async {
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return Future.error("You did not select an account to sign in !");
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;

      return userFromFirebase(user);
    } catch (e) {
      print("Problem is " + e.toString());
      print(e.code);

      switch (e.code) {
        case "network_error":
          return Future.error("Please check your internet connection !");
          break;
        case "ERROR_USER_DISABLED":
          return Future.error("Sorry your account is disabled !");
          break;
        case "ERROR_TOO_MANY_REQUESTS":
          return Future.error("Too many requests. Try again later.");
          break;
        default:
          return Future.error("Cannot sign you now :( ");
          break;
      }
    }
  }

  Future<FirebaseUser> signUpWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult res = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      print("User registered ");
      return res.user;
    } catch (e) {
      switch (e.code) {
        case "ERROR_INVALID_EMAIL":
          return Future.error("Your email is invalid");
          break;
        case "ERROR_EMAIL_ALREADY_IN_USE":
          return Future.error("This email is already registered !");
          break;
        case "ERROR_WEAK_PASSWORD":
          return Future.error("This password is too weak !");
          break;
      }
      return Future.error("Cannot register you now , Try checking your internet connection !");
    }
  }

  Future<User> signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult res = await _auth.signInWithEmailAndPassword(email: email, password: password);
      print("User Signed In ");
      print(res.user.uid);
      return userFromFirebase(res.user);
    } catch (e) {
      switch (e.code) {
        case "ERROR_WRONG_PASSWORD":
          return Future.error("Please check your password again !");
          break;
        case "ERROR_INVALID_EMAIL":
          return Future.error("Your email is invalid");
          break;
        case "ERROR_EMAIL_ALREADY_IN_USE":
          return Future.error("This email is already registered !");
          break;
        case "ERROR_USER_NOT_FOUND":
          return Future.error("There is no user corresponding to that email , try again !");
          break;
        case "ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL":
          return Future.error("There's already a google account with that email . Try signing instead with google !");
          break;
      }
      return Future.error("No such user exists . Try registering first !");
    }
  }

  Stream<User> get onStateChanged {
    return _auth.onAuthStateChanged.map(userFromFirebase);
  }

  User userFromFirebase(FirebaseUser user) {
    return user != null ? User(uid: user.uid, displayName: user.displayName ?? "", email: user.email ?? "", photoUrl: user.photoUrl ?? "", status: "I am new here !") : null;
  }

  Future<void> logOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}
