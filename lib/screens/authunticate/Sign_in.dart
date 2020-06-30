
import 'dart:async';
import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crewbrew/screens/authunticate/AsAdmin.dart';
import 'package:crewbrew/screens/authunticate/delayed_animation.dart';
import 'package:crewbrew/screens/home/home.dart';
import 'package:crewbrew/services/auth.dart';
import 'package:crewbrew/shared/loading.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:crewbrew/shared/constant.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:nice_button/nice_button.dart';
class SignIn extends StatefulWidget {
  final Function ToggleView;
  SignIn({this.ToggleView});
  @override
  _SignInState createState() => _SignInState();
}
class _SignInState extends State<SignIn> with TickerProviderStateMixin {
  //give an instance of authentication form the class to run the method
  final AuthService _auth=AuthService();
  final _formKey=GlobalKey<FormState>();
  bool loading=false;
  final int delayedAmount=500;
  final color=Colors.white;
  //text field value
  String email='';
  String password='';
  String error='';
  @override
  Widget build(BuildContext context) {
    return loading? Loading():Scaffold(
      backgroundColor: Color(0xFF8185E2),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              DelayedAnimation(
                child:
              AvatarGlow(
                endRadius: 50,
                duration: Duration(seconds:2),
                glowColor: Colors.white24,
                repeat: true,
                repeatPauseDuration: Duration(seconds: 2),
                startDelay: Duration(seconds: 1),
                child: Material(
                  elevation: 8.0,
                  shape: CircleBorder(),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child:Image(image:AssetImage('assets/Logo2.PNG'),width: 55,height: 55,),


                    radius:40.0,
                  ),
                ),
              ),
                delay: delayedAmount+1000,
              ),
              DelayedAnimation(
                child: Text("Hi There",style: TextStyle(fontWeight: FontWeight.w500,fontStyle:FontStyle.italic,fontSize: 20.0,color: color),),
                delay: delayedAmount+800,
              ),
              SizedBox(height: 5.0,),
              DelayedAnimation(
                child: Text("Welcome To",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 20.0,color: color),),
                delay: delayedAmount+1200,
              ),
              DelayedAnimation(
                child: Text("M.G.M \n Store",style: TextStyle(fontWeight: FontWeight.bold,fontStyle:FontStyle.normal,fontSize: 20.0,color: color),),
                delay: delayedAmount+1200,
              ),
              SizedBox(height: 5.0,),
              DelayedAnimation(
                child:
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Email',
                  fillColor: Colors.white,
                  filled: true,
                  //when we not focused in the label
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.pink,
                        width: 2.0,
                      )
                  ),
                ),
                validator: (val)=> val.isEmpty ? 'Enter an email':null,
                onChanged: (val){
                  setState(() {
                    email=val;
                  });
                },
              ),
                delay: delayedAmount+1400,
              ),
              SizedBox(height: 10.0,),
              DelayedAnimation(
                child:
              TextFormField(
                decoration: textinputdecoration.copyWith(hintText: 'Password'),
                validator: (val)=> val.length < 6 ? 'Enter a password 6+ chars long':null,
                obscureText: true,
                onChanged: (val){
                  setState(() {
                    password=val;
                  });
                },
              ),
                delay: delayedAmount+1400,
              ),
              SizedBox(height: 10.0,),
              DelayedAnimation(
                child: NiceButton(
                  radius: 40,
                  padding: const EdgeInsets.all(15),
                  text: "Sign In",
                  icon: Icons.account_box,
                  gradientColors: [Color(0xff5b86e5), Color(0xff36d1dc)],
                  onPressed: ()async{
                    if(_formKey.currentState.validate()){
                      setState(() {
                        loading=true;

                      });
                      bool result = await DataConnectionChecker().hasConnection;
                      if(result == true) {
                        dynamic result=await _auth.signInWithEmailAndPassword(email, password);
                        final FirebaseMessaging _fcm=FirebaseMessaging();
                        FirebaseUser user = await FirebaseAuth.instance.currentUser();
                        // Get the token for this device
                        String fcmToken = await _fcm.getToken();
                        StreamSubscription iosSubscription;
                        if (Platform.isIOS){
                          iosSubscription = _fcm.onIosSettingsRegistered.listen((data) async {
                            // save the token  OR subscribe to a topic here
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
                          });
                          _fcm.requestNotificationPermissions(IosNotificationSettings());
                        }else
                        {
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
                        //return null id error or result user
                        if(result==null){
                          setState(() {
                            error='could not sign in with those crendentials ';
                            loading=false;
                          });
                        }
                      } else {
                        setState(() {
                          loading=false;
                        });
                        showDialog(context: context,
                          builder: (context)=>AlertDialog(
                            title: Text("No Internet"),
                            content: Text("please make sure your are connected"),
                          )
                        );
                        print('No internet :( Reason:');
                        print(DataConnectionChecker().lastTryResults);
                      }

                    }
                  },
                ),
                delay: delayedAmount+1400,
              ),
              SizedBox(height:10,),
              DelayedAnimation(
                child: Text("Create new Account ?",style: TextStyle(fontWeight: FontWeight.w200,fontSize: 17.0,color: color),),
                delay: delayedAmount+1500,
              ),
              SizedBox(height: 7.0,),
              DelayedAnimation(
                child: SignInButtonBuilder(

                  text: '            Sign Up',
                  icon: Icons.email,
                  onPressed: () {widget.ToggleView();},
                  backgroundColor: Colors.blueAccent,
                ),
                delay: delayedAmount+1500,
              ),
              Text(error),
            ],
          ),
        ),
      ),
    );
  }
}

