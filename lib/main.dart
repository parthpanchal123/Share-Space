import 'package:flutter/material.dart';
import 'package:random_Fun/Router/routes.dart';
import 'package:random_Fun/screens/AppScreens/splashscreen.dart';
import 'package:random_Fun/screens/AuthScreens/auth.dart';
import 'package:provider/provider.dart';
import 'package:random_Fun/services/Authenticate.dart';
import 'package:random_Fun/services/api.dart';
import 'package:random_Fun/services/database.dart';
import 'package:random_Fun/services/firebase_storage.dart';
import 'package:random_Fun/services/image_picker.dart';
import 'package:random_Fun/services/push_notification-_service.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      Provider<Authenticate>(create: (_) => Authenticate()),
      Provider<Api>(create: (_) => Api()),
      Provider<Database>(
        create: (_) => Database(),
      ),
      Provider<Image_Picker>(create: (_) => Image_Picker()),
      Provider<Storage>(create: (_) => Storage()),
      Provider<PushNotificationService>(create: (_) => PushNotificationService())
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.black, accentColor: Color(0xff212121), fontFamily: 'Aileron'),
      routes: routes,
      home: SplashScreen(),
    ),
  ));
}
