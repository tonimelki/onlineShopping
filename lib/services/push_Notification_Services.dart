import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationServices{
final FirebaseMessaging _fcm=FirebaseMessaging();

Future initialize()async{
  if(Platform.isIOS){
    _fcm.requestNotificationPermissions(IosNotificationSettings());
  }
  _fcm.configure(
    //when we are in the foreground and we receive a message
    onMessage: (Map<String,dynamic> message )async{
    print('on message $message');
  },
    //called when its completed closed
    onLaunch: (Map<String,dynamic> message )async{
      print('on message $message');
    },
    //when it is on the background
    onResume: (Map<String,dynamic> message )async{
      print('on message $message');
    },
  );

}
}