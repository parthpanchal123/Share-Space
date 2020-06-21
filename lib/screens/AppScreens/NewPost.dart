import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:random_Fun/models/Post.dart';
import 'package:random_Fun/services/database.dart';
import 'package:random_Fun/values/values.dart';
import 'package:random_Fun/widgets/custom_button.dart';
import 'package:random_Fun/widgets/custom_text_form_field.dart';
import 'package:random_Fun/widgets/spaces.dart';

class NewPost extends StatefulWidget {
  @override
  _NewPostState createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final ssupController = TextEditingController(text: '');
  final detailController = TextEditingController(text: '');
  final linkController = TextEditingController(text: '');

  String _val, _desc, _links, _category;
  bool isLoading = false;
  final focus = FocusNode();
  int tag = 9;
  List<String> options = ['Books 📚 ', 'Series 🍿', 'Movies 🎬', 'Music 🎶', 'Writing ✍️', 'Technology 🖥️', 'Cars 🏎️', 'Food 🥘', 'Science 🔬', 'Random 🔀'];
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final db = Provider.of<Database>(context);
    final routes = ModalRoute.of(context).settings.arguments as Map<String, String>;
    final String uid = routes['uid'];

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xffEDF2F7),
      appBar: AppBar(
        title: Text('Share a cool idea !'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0.0,
      ),
      body: ModalProgressHUD(
        color: AppColors.blueShade2,
        opacity: 0.4,
        inAsyncCall: isLoading,
        progressIndicator: CircularProgressIndicator(),
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      CustomTextFormField(
                        hintText: 'Start like : I am reading a book !',
                        autofocus: false,
                        controller: ssupController,
                        validator: (val) {
                          if (val.isEmpty || val == "") {
                            return "Describe something interesting you are doing !";
                          }
                          if (val.length > 51) {
                            print(val.length);
                            return "Keep it at most 50 words ,describe more in the next field";
                          }
                        },
                        textInputType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        labelText: 'Whats Up ?',
                        border: Borders.customOutlineInputBorder(),
                        enabledBorder: Borders.customOutlineInputBorder(),
                        focusedBorder: Borders.customOutlineInputBorder(
                          color: AppColors.violetShade200,
                        ),
                        labelStyle: Styles.customTextStyle(),
                        hintTextStyle: Styles.customTextStyle(),
                        textStyle: Styles.customTextStyle(),
                        onChanged: (val) {
                          _val = val;
                        },
                      ),
                      SpaceH20(),
                      CustomTextFormField(
                        textInputAction: TextInputAction.next,
                        autofocus: false,
                        controller: detailController,
                        hintText: 'For Eg : How do you think it will entertain your friends too  ?',

                        validator: (desc) {
                          if (desc.isEmpty || desc == "" || desc.length > 151 || desc.length < 20) {
                            print(desc.length);
                            print(linkController.text.length);
                            return "Keep it atleast 20 to 150 characters for better understanding !";
                          }
                        },
                        textInputType: TextInputType.multiline,
                        maxLines: 3,
                        //   controller: emailController,
                        labelText: 'A bit more in detail !',
                        border: Borders.customOutlineInputBorder(),
                        enabledBorder: Borders.customOutlineInputBorder(),
                        focusedBorder: Borders.customOutlineInputBorder(
                          color: AppColors.violetShade200,
                        ),
                        labelStyle: Styles.customTextStyle(),
                        hintTextStyle: Styles.customTextStyle(),
                        textStyle: Styles.customTextStyle(),
                        onChanged: (desc) {
                          _desc = desc;
                        },
                      ),
                      SpaceH20(),
                      CustomTextFormField(
                        hintText: 'A platform like Netfix , Prime or simply Google !',
                        autofocus: false,
                        controller: linkController,
                        validator: (link) {
                          if (link.isEmpty || link == "") {
                            return "Where to find the resource you suggested ?";
                          }
                          if (link.length > 20) {
                            return "Keep it under 20 characters";
                          }
                        },
                        textInputType: TextInputType.text,

                        //   controller: emailController,
                        labelText: 'Some links to it ?',
                        border: Borders.customOutlineInputBorder(),
                        enabledBorder: Borders.customOutlineInputBorder(),
                        focusedBorder: Borders.customOutlineInputBorder(
                          color: Theme.of(context).primaryColor,
                        ),
                        labelStyle: Styles.customTextStyle(),
                        hintTextStyle: Styles.customTextStyle(),
                        textStyle: Styles.customTextStyle(),
                        onChanged: (link) {
                          _links = link;
                        },
                      ),
                      SpaceH12(),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Select a category'),
                            ChipsChoice<int>.single(
                              value: tag,
                              options: ChipsChoiceOption.listFrom<int, String>(
                                source: options,
                                value: (i, v) => i,
                                label: (i, v) => v,
                              ),
                              onChanged: (val) {
                                setState(() {
                                  tag = val;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      SpaceH12(),
                      Container(
                        width: Sizes.WIDTH_200,
                        decoration: Decorations.customBoxDecoration(blurRadius: 10),
                        child: CustomButton(
                          hasIcon: true,
                          icon: Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
                          title: 'Share It !',
                          elevation: Sizes.ELEVATION_8,
                          textStyle: theme.textTheme.subtitle2.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w600,
                          ),
                          color: Theme.of(context).accentColor,
                          height: Sizes.HEIGHT_40,
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                isLoading = true;
                              });
                              await db.createNewPost(uid, Post().toMap(_val, _desc, _links, options[tag])).then((status) {
                                setState(() {
                                  isLoading = false;
                                  ssupController.clear();
                                  detailController.clear();
                                  linkController.clear();
                                });
                                _scaffoldKey.currentState.showSnackBar(SnackBar(
                                  content: Text('Awesome 😘 , that was a great idea and now your friends can see it on their feeds !'),
                                ));
                              }).catchError((errorMsg) {
                                setState(() {
                                  isLoading = false;
                                });
                                _scaffoldKey.currentState.showSnackBar(SnackBar(
                                  content: Text(errorMsg.toString()),
                                ));
                                print(errorMsg.toString());
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
