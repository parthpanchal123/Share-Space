import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:random_Fun/models/user.dart';
import 'package:random_Fun/screens/AuthScreens/login.dart';
import 'package:random_Fun/services/Authenticate.dart';
import 'package:random_Fun/services/database.dart';
import 'package:random_Fun/values/values.dart';
import 'package:random_Fun/widgets/clipShadowPath.dart';
import 'package:random_Fun/widgets/custom_button.dart';
import 'package:random_Fun/widgets/custom_shape_clippers.dart';
import 'package:random_Fun/widgets/custom_text_form_field.dart';
import 'package:random_Fun/widgets/spaces.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SignUp extends StatefulWidget {
  SignUp();

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController emailController = TextEditingController(text: "");
  TextEditingController passController = TextEditingController(text: "");
  TextEditingController nameController = TextEditingController(text: "");
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String _email, _password, _name;
  bool isLoading = false;
  bool isChecked = false;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences prefs;
  @override
  void initState() {
    super.initState();
    _checkIfAccepted();
  }

  _checkIfAccepted() async {
    prefs = await _prefs;
    isChecked = prefs.getBool("isAccepted");
  }

  _launchURL() async {
    const url = StringConst.policy;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  onAgreementAccepted(bool value) async {
    prefs = await _prefs;
    prefs.setBool("isAccepted", value);

    setState(() {
      isChecked = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    var heightOfScreen = MediaQuery.of(context).size.height;
    var widthOfScreen = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _scaffoldKey,
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: ModalProgressHUD(
          color: AppColors.blueShade2,
          opacity: 0.4,
          inAsyncCall: isLoading,
          progressIndicator: CircularProgressIndicator(),
          child: Container(
            child: Stack(
              children: <Widget>[
                ClipShadowPath(
                  clipper: LoginDesign4ShapeClipper(),
                  shadow: Shadow(blurRadius: 24, color: AppColors.blue),
                  child: Container(
                    height: heightOfScreen * 0.38,
                    width: widthOfScreen,
                    color: AppColors.blue,
                    child: Container(
                      margin: EdgeInsets.only(left: Sizes.MARGIN_24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: heightOfScreen * 0.1,
                          ),
                          Text(
                            StringConst.WELCOME,
                            style: theme.textTheme.headline6.copyWith(
                              fontSize: Sizes.TEXT_SIZE_20,
                              color: AppColors.white,
                            ),
                          ),
                          Text(
                            StringConst.SIGN_UP_3,
                            style: theme.textTheme.headline4.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                ListView(
                  padding: EdgeInsets.all(Sizes.PADDING_0),
                  children: <Widget>[
                    SizedBox(
                      height: heightOfScreen * 0.4,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: Sizes.MARGIN_20),
                      child: _buildForm(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    ThemeData theme = Theme.of(context);
    final _auth = Provider.of<Authenticate>(context, listen: false);
    final focus = FocusNode();
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          CustomTextFormField(
            autofocus: false,
            hasSuffixIcon: true,
            textInputAction: TextInputAction.next,
            suffixIcon: Icon(
              Icons.person,
              color: AppColors.blackShade10,
            ),
            validator: (name) {
              if (name.isEmpty || name == '') {
                return "Not a proper name !";
              }
            },
            textInputType: TextInputType.text,
            controller: nameController,
            labelText: StringConst.USER_DISPLAY_NAME,
            border: Borders.customOutlineInputBorder(),
            enabledBorder: Borders.customOutlineInputBorder(),
            focusedBorder: Borders.customOutlineInputBorder(
              color: AppColors.violetShade200,
            ),
            labelStyle: Styles.customTextStyle(),
            hintTextStyle: Styles.customTextStyle(),
            textStyle: Styles.customTextStyle(),
            onChanged: (name) {
              _name = name;
            },
          ),
          SpaceH16(),
          CustomTextFormField(
            autofocus: false,
            textInputAction: TextInputAction.next,
            hasSuffixIcon: true,
            suffixIcon: Icon(
              Icons.email,
              color: AppColors.blackShade10,
            ),
            validator: (email) {
              if (!isValidEmail(email) || email.isEmpty || email == '') {
                return "Not a proper email !";
              }
            },
            textInputType: TextInputType.emailAddress,
            controller: emailController,
            labelText: StringConst.EMAIL_ADDRESS,
            border: Borders.customOutlineInputBorder(),
            enabledBorder: Borders.customOutlineInputBorder(),
            focusedBorder: Borders.customOutlineInputBorder(
              color: AppColors.violetShade200,
            ),
            labelStyle: Styles.customTextStyle(),
            hintTextStyle: Styles.customTextStyle(),
            textStyle: Styles.customTextStyle(),
            onChanged: (val) {
              _email = val;
            },
          ),
          SpaceH16(),
          CustomTextFormField(
            maxLines: 1,
            textInputAction: TextInputAction.done,
            autofocus: false,
            validator: (pass) {
              if (pass.isEmpty || pass == "" || pass.length < 8) {
                return "Password should be atleast 8 characters !";
              }
            },
            controller: passController,
            textInputType: TextInputType.text,
            labelText: StringConst.PASSWORD,
            obscured: true,
            hasSuffixIcon: true,
            suffixIcon: Icon(
              Icons.lock,
              color: AppColors.blackShade10,
            ),
            border: Borders.customOutlineInputBorder(),
            enabledBorder: Borders.customOutlineInputBorder(),
            focusedBorder: Borders.customOutlineInputBorder(
              color: AppColors.violetShade200,
            ),
            labelStyle: Styles.customTextStyle(),
            hintTextStyle: Styles.customTextStyle(),
            textStyle: Styles.customTextStyle(),
            onChanged: (val) {
              _password = val;
            },
          ),
          SpaceH12(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Checkbox(
                value: isChecked ?? false,
                onChanged: onAgreementAccepted,
                activeColor: AppColors.blue,
              ),
              isChecked == false
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
          SpaceH12(),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: Sizes.WIDTH_200,
                decoration: Decorations.customBoxDecoration(blurRadius: 10),
                child: CustomButton(
                  title: StringConst.SIGN_ME_UP,
                  elevation: Sizes.ELEVATION_8,
                  textStyle: theme.textTheme.subtitle2.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  color: AppColors.blue,
                  height: Sizes.HEIGHT_40,
                  onPressed: () async {
                    prefs = await _prefs;

                    if (prefs.getBool("isAccepted") == false) {
                      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Please accept the terms before proceeding !")));
                      return;
                    }
                    if (_formKey.currentState.validate()) {
                      setState(() {
                        isLoading = true;
                      });

                      final _auth = Provider.of<Authenticate>(context, listen: false);
                      final _db = Provider.of<Database>(context, listen: false);

                      await _auth.signUpWithEmailAndPassword(_email, _password).then((user) async {
                        if (user != null) {
                          print("Name is" + _name);
                          User newUser = User(uid: user.uid, displayName: _name, email: user.email, photoUrl: user.photoUrl, status: "I am new here");
                          emailController.clear();
                          passController.clear();
                          nameController.clear();
                          setState(() {
                            isLoading = false;
                          });
                          await _db.addUserToDatabase(newUser).whenComplete(() {
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                              content: Text("Successfully registered , Login now !"),
                            ));
                          });
                        }
                      }).catchError((errorMsg) {
                        setState(() {
                          isLoading = false;
                        });
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text(errorMsg.toString()),
                        ));
                      });
                    }
                  },
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.17,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.rightToLeftWithFade, child: LoginScreen()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: StringConst.ALREADY_HAVE_AN_ACCOUNT,
                                style: theme.textTheme.subtitle.copyWith(
                                  color: AppColors.greyShade8,
                                  fontSize: Sizes.TEXT_SIZE_14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                  text: StringConst.LOG_IN_2,
                                  style: theme.textTheme.subtitle.copyWith(
                                    color: AppColors.purple,
                                    fontSize: Sizes.TEXT_SIZE_14,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

bool isValidEmail(String email) {
  Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  return (!regex.hasMatch(email)) ? false : true;
}
