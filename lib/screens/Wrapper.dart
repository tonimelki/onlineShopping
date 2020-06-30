import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crewbrew/models/Role.dart';
import 'package:crewbrew/services/push_Notification_Services.dart';
import 'package:crewbrew/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'authunticate/authenticate.dart';
import 'package:crewbrew/models/user.dart';
import 'User/userHome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home/home.dart';
class Wrapper extends StatelessWidget {
 // const Wrapper({Key key,this.user}):super(key:key);
  //final FirebaseUser user;
  @override
  Widget build(BuildContext context) {

    final user=Provider.of<User>(context);
    if(user==null){
      return Authenticate();
    }

    return Scaffold(
      body:

      StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance.collection('User Role').document(user.email).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){

        try {
          if (user == null) {
            return Authenticate();

          }
          else {
            if (snapshot.data['Role'] == 'user') {
              return UserHome();
            }
            else {
              return Home();
            }
          }
        }catch(ex){return Loading();}
          },
      ),
    );
    //we get and access the user data who login or out by the StreamProvider
  }
}
//builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
//if (snapshot.hasError)
//return new Text('Error: ${snapshot.error}');
//switch (snapshot.connectionState) {
//case ConnectionState.waiting:
//return new Text('Loading...');
//default:
//if (user == null) {
//return Authenticate();
//} else {
//if (snapshot.data['Role'] == 'user') {
//return UserHome();
//}
//else {
//return Home();
//}
//}
//}
//}
