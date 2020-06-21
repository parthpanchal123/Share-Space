import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:random_Fun/screens/AuthScreens/auth.dart';
import 'package:random_Fun/screens/homeScreen.dart';
import 'package:random_Fun/services/Authenticate.dart';
import 'package:random_Fun/values/values.dart';
import 'package:random_Fun/widgets/clipShadowPath.dart';
import 'package:random_Fun/widgets/custom_button.dart';
import 'package:random_Fun/widgets/custom_shape_clippers.dart';
import 'package:random_Fun/widgets/custom_text_form_field.dart';
import 'package:random_Fun/widgets/spaces.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController(text: "");
  TextEditingController passController = TextEditingController(text: "");
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  String _email, _password;
  bool _isSignedIn = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _check();
  }

  _check() async {
    var _googleSignIn = GoogleSignIn();
    var res = await _googleSignIn.isSignedIn();
    if (res) {
      setState(() {
        _isSignedIn = res;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    var heightOfScreen = MediaQuery.of(context).size.height;
    var widthOfScreen = MediaQuery.of(context).size.width;

    if (_isSignedIn == false) {
      return Scaffold(
        key: scaffoldKey,
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
                      height: heightOfScreen * 0.4,
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
                              StringConst.WELCOME_BACK,
                              style: theme.textTheme.headline6.copyWith(
                                fontSize: Sizes.TEXT_SIZE_20,
                                color: AppColors.white,
                              ),
                            ),
                            Text(
                              StringConst.LOG_IN_5,
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
                        height: heightOfScreen * 0.45,
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
    } else {
      return HomeScreen();
    }
  }

  Widget _buildForm() {
    ThemeData theme = Theme.of(context);
    final _auth = Provider.of<Authenticate>(context);
    final focus = FocusNode();

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          CustomTextFormField(
            autofocus: false,
            textInputAction: TextInputAction.next,
            hasSuffixIcon: true,
            suffixIcon: Icon(
              Icons.email,
              color: AppColors.blackShade10,
            ),
            validator: (email) {
              if (email.isEmpty || email == "") {
                return "Email cant be empty";
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
          SpaceH20(),
          CustomTextFormField(
            maxLines: 1,
            autofocus: false,
            textInputAction: TextInputAction.next,
            validator: (pass) {
              if (pass.isEmpty || pass == '') {
                return "Password cannot be empty !";
              } else if (pass.length < 8) {
                return "Password too short !";
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
            children: <Widget>[
              Spacer(flex: 2),
            ],
          ),
          SpaceH12(),
          Container(
            width: Sizes.WIDTH_200,
            decoration: Decorations.customBoxDecoration(blurRadius: 10),
            child: CustomButton(
              title: StringConst.LOG_IN_2,
              elevation: Sizes.ELEVATION_8,
              textStyle: theme.textTheme.subtitle2.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
              color: AppColors.blue,
              height: Sizes.HEIGHT_40,
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  setState(() {
                    isLoading = true;
                  });

                  await _auth.signInWithEmailAndPassword(_email, _password).then((user) {
                    setState(() {
                      isLoading = false;
                    });

                    Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.leftToRightWithFade, child: AuthWidget()));
                  }).catchError((errorMsg) {
                    setState(() {
                      isLoading = false;
                    });
                    scaffoldKey.currentState.showSnackBar(SnackBar(
                      content: Text(errorMsg.toString()),
                    ));
                  });
                  // .then((value) => Navigator.pushReplacement(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => HomeScreen(),
                  //     )));
                }
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/signUpHome');
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: StringConst.DONT_HAVE_AN_ACCOUNT,
                          style: theme.textTheme.subtitle.copyWith(
                            color: AppColors.greyShade8,
                            fontSize: Sizes.TEXT_SIZE_14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                            text: StringConst.REGISTER,
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
        ],
      ),
    );
  }
}
