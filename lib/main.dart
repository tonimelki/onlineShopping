
import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crewbrew/models/user.dart';
import 'package:crewbrew/services/auth.dart';
import 'package:crewbrew/services/push_Notification_Services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/Wrapper.dart';
void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
final FirebaseMessaging _fcm=FirebaseMessaging();
final Firestore _firestore=Firestore();
StreamSubscription iosSubscription;
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Platform.isIOS) {
      iosSubscription = _fcm.onIosSettingsRegistered.listen((data) {
        // save the token  OR subscribe to a topic here
        _saveDeviceToken();
      });
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }else
      {
        _saveDeviceToken();
      }
    _fcm.configure(
      onMessage: (Map<String,dynamic>message)async{
        print("on message:$message");
        final snackbar=SnackBar(
          content: Text(message['notification']['title']),
          action: SnackBarAction(
            label: 'ok',
            onPressed: ()=>Null,
          ),
        );
        Scaffold.of(context).showSnackBar(snackbar);
      },
      onResume: (Map<String,dynamic>message)async{
        print("on Resume:$message");
      },
      onLaunch: (Map<String,dynamic>message)async{
        print("on Launch:$message");
      },
    );
  }

_saveDeviceToken() async {
  // Get the current user

  // FirebaseUser user = await _auth.currentUser();
  FirebaseUser user = await FirebaseAuth.instance.currentUser();
  // Get the token for this device
  String fcmToken = await _fcm.getToken();
  // Save it to Firestore
  if (fcmToken != null) {
    var tokens = Firestore.instance
        .collection('User Role')
        .document(user.email)
        .collection('tokens')
        .document(fcmToken);

    await tokens.setData({
      'token': fcmToken,
      'createdAt': FieldValue.serverTimestamp(), // optional
      'platform': Platform.operatingSystem // optional
    });
  }

}

  @override
  Widget build(BuildContext context) {

    //listen and provide the data if the user login or not and give the value to other pages like now Wrapper
    return StreamProvider<User>.value(
      //choose what u want to access /user is who called in the Stream method in auth.dart and we get instance of AuthService class in auth
      value: AuthService().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Wrapper(),

      ),
    );
  }
}

