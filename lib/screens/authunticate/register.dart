
import 'dart:ui';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:crewbrew/screens/authunticate/Sign_in.dart';
import 'package:crewbrew/screens/authunticate/Sign_up.dart';
import 'package:crewbrew/screens/authunticate/delayed_animation.dart';
import 'package:crewbrew/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:crewbrew/services/auth.dart';
import 'package:crewbrew/shared/constant.dart';
import 'package:nice_button/nice_button.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
class Register extends StatefulWidget {
  final Function ToggleView;
  Register({this.ToggleView});
  @override
  _RegisterState createState() => _RegisterState();

  //we define the function we sent from authenticate to use it here and save the data by the const


}

class _RegisterState extends State<Register> with SingleTickerProviderStateMixin {
  final int delayedAmount=500;
  final color=Colors.white;
  final AuthService _auth=AuthService();
  //to validate the form and associate him
  final _formKey=GlobalKey<FormState>();
  String email='';
  String password='';
  String error='';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xFF8185E2),
        body: Center(
          child: Column(
            children: <Widget>[
              AvatarGlow(
                endRadius: 90,
                duration: Duration(seconds:2),
                glowColor: Colors.white24,
                repeat: true,
                repeatPauseDuration: Duration(seconds: 2),
                startDelay: Duration(seconds: 1),
                child: Material(
                  elevation: 8.0,
                  shape: CircleBorder(),
                  child: CircleAvatar(
                    backgroundColor: Colors.grey[100],
                    child: FlutterLogo(
                      size: 50.0,
                    ),
                    radius: 50.0,
                  ),
                ),
              ),
              DelayedAnimation(
                child: Text("Hi There",style: TextStyle(fontWeight: FontWeight.w500,fontStyle:FontStyle.italic,fontSize: 35.0,color: color),),
                delay: delayedAmount+1000,
              ),
              SizedBox(height: 25.0,),
              DelayedAnimation(
                child: Text("Welcome To",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 35.0,color: color),),
                delay: delayedAmount+1200,
              ),
              DelayedAnimation(
                child: Text("G.M.G \n Store",style: TextStyle(fontWeight: FontWeight.bold,fontStyle:FontStyle.normal,fontSize: 35.0,color: color),),
                delay: delayedAmount+1200,
              ),
              SizedBox(height: 30.0,),
              DelayedAnimation(
                child: NiceButton(
               radius: 40,
               padding: const EdgeInsets.all(15),
               text: "Sign Up",
               icon: Icons.account_box,
               gradientColors: [Color(0xff5b86e5), Color(0xff36d1dc)],
                onPressed: () {
                 widget.ToggleView();
                },
                ),
                delay: delayedAmount+1200,
              ),
              SizedBox(height: 10,),
              DelayedAnimation(
                child: Text("Already Have an Account",style: TextStyle(fontWeight: FontWeight.w200,fontSize: 20.0,color: color),),
                delay: delayedAmount+1500,
              ),
              SizedBox(height: 10.0,),
              DelayedAnimation(
                child: SignInButtonBuilder(
                  text: 'Sign in with Email',
                  icon: Icons.email,
                  onPressed: () {widget.ToggleView();},
                  backgroundColor: Colors.blueAccent,
                ),
                delay: delayedAmount+1500,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
