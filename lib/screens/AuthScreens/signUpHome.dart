import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:random_Fun/screens/AuthScreens/signUp.dart';
import 'package:random_Fun/services/Authenticate.dart';
import 'package:random_Fun/services/database.dart';
import 'package:random_Fun/values/values.dart';
import 'package:random_Fun/widgets/custom_button.dart';
import 'package:random_Fun/widgets/spaces.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SignUpHome extends StatefulWidget {
  @override
  _SignUpHomeState createState() => _SignUpHomeState();
}

class _SignUpHomeState extends State<SignUpHome> {
  bool isLoading = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isChecked = false;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences prefs;
  @override
  void initState() {
    _checkIfAccepted();
    super.initState();
  }

  _checkIfAccepted() async {
    prefs = await _prefs;

    if (prefs.getBool('isAccepted') == null) {
      prefs.setBool('isAccepted', false);
    } else {
      isChecked = prefs.getBool('isAccepted');
      print(isChecked);
    }

    setState(() {
      isChecked = prefs.getBool("isAccepted");
    });
  }

  onAgreementAccepted(bool value) async {
    prefs = await _prefs;
    prefs.setBool("isAccepted", value);

    setState(() {
      isChecked = value;
    });
  }

  _launchURL() async {
    const url = StringConst.policy;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final _auth = Provider.of<Authenticate>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      body: ModalProgressHUD(
        color: AppColors.blueShade2,
        opacity: 0.4,
        inAsyncCall: isLoading,
        progressIndicator: CircularProgressIndicator(),
        child: SafeArea(
          child: Container(
            child: Column(
              children: <Widget>[
                Spacer(flex: 1),
                Image(
                  image: AssetImage('assets/images/girl_comp.png'),
                  height: 300,
                  filterQuality: FilterQuality.high,
                ),
                Spacer(flex: 1),
                Text(
                  StringConst.SIGN_UP_2,
                  style: theme.textTheme.headline5.copyWith(
                    color: AppColors.black,
                    fontSize: Sizes.TEXT_SIZE_40,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SpaceH8(),
                Text(
                  StringConst.EASY_SIGN_UP,
                  style: theme.textTheme.subtitle2.copyWith(color: AppColors.greyShade8, fontWeight: FontWeight.bold),
                ),
                Spacer(flex: 1),
                Container(
                  decoration: Decorations.customBoxDecoration(blurRadius: 10),
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: CustomButton(
                    title: StringConst.CONTINUE_WITH_GOOGLE,
                    elevation: Sizes.ELEVATION_12,
                    hasIcon: true,
                    icon: Icon(
                      FontAwesomeIcons.google,
                      color: AppColors.white,
                    ),
                    color: AppColors.blue,
                    textStyle: theme.textTheme.button.copyWith(color: AppColors.white, fontWeight: FontWeight.w600, fontSize: Sizes.TEXT_SIZE_14),
                    onPressed: () async {
                      prefs = await _prefs;

                      if (prefs.getBool("isAccepted") == false) {
                        _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Please accept the terms before proceeding !")));
                        return;
                      }

                      final _db = Provider.of<Database>(context, listen: false);
                      setState(() {
                        isLoading = true;
                      });
                      final c_user = await _auth.handleSignIn().catchError((error) {
                        print(error.toString());
                        setState(() {
                          isLoading = false;
                        });
                        _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(error.toString())));
                      });
                      if (c_user != null) {
                        final isNew = await _db.checkNewUser(c_user);
                        print("The user isn " + isNew.toString());
                        if (isNew) {
                          await _db.addUserToDatabase(c_user).catchError((error) {
                            print("From here " + error.toString());
                          });
                        }
                      }
                    },
                  ),
                ),
                SpaceH12(),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: CustomButton(
                      title: StringConst.USE_EMAIL,
                      elevation: Sizes.ELEVATION_2,
                      color: AppColors.white,
                      borderSide: Borders.customBorder(width: 1.5),
                      textStyle: theme.textTheme.button.copyWith(color: AppColors.blackShade10, fontWeight: FontWeight.w600, fontSize: Sizes.TEXT_SIZE_14),
                      onPressed: () {
                        Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeftWithFade, child: SignUp()));
                      }),
                ),
                Spacer(flex: 1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Checkbox(
                      value: isChecked ?? false,
                      onChanged: onAgreementAccepted,
                      activeColor: AppColors.blue,
                    ),
                    isChecked != true
                        ? GestureDetector(
                            onTap: _launchURL,
                            child: Text(
                              'Accept terms and conditions',
                              style: TextStyle(
                                fontSize: Sizes.TEXT_SIZE_14,
                                decoration: TextDecoration.underline,
                                color: AppColors.purple,
                              ),
                            ))
                        : Text("Already accepted terms ! Login now . ")
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
