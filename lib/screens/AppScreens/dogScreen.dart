import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:random_Fun/models/dog.dart';
import 'package:random_Fun/services/api.dart';
import 'package:random_Fun/values/values.dart';

class DogScreen extends StatefulWidget {
  @override
  _DogScreenState createState() => _DogScreenState();
}

class _DogScreenState extends State<DogScreen> {
  int tag = 0;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dogs's Lovers Only :P"),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Container(
              //height: 130.0,
              decoration: BoxDecoration(color: Theme.of(context).accentColor, borderRadius: BorderRadius.all(Radius.circular(10.0))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(gradient: Gradients.curvesGradient0, borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0))),
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            'Select a breed ....',
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10.0),
                    child: ChipsChoice<int>.single(
                      value: tag,
                      options: ChipsChoiceOption.listFrom<int, String>(
                        source: Dog().breeds,
                        value: (i, v) => i,
                        label: (i, v) => v,
                      ),
                      onChanged: (val) {
                        setState(() {
                          tag = val;
                          isLoading = true;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ModalProgressHUD(
                color: AppColors.blueShade2,
                opacity: 0.4,
                inAsyncCall: isLoading,
                progressIndicator: CircularProgressIndicator(),
                child: FutureBuilder(
                  future: Api().getDogs(tag).whenComplete(() {
                    setState(() {
                      isLoading = false;
                    });
                  }),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(20.0)),
                              child: Container(
                                decoration: BoxDecoration(),
                                child: Image.network(
                                  snapshot.data[index],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
