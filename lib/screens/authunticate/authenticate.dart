import 'package:crewbrew/screens/authunticate/Sign_up.dart';
import 'package:crewbrew/screens/authunticate/register.dart';
import 'package:flutter/material.dart';
import 'Sign_in.dart';
import '../home/home.dart';


class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  //to see switch btw pages so we reverse the value of the bool when the method triggered to switch
  bool showSignIn=true;
  void ToggleView(){
    setState(()=>showSignIn=!showSignIn);
  }
  @override
  Widget build(BuildContext context) {
    if(showSignIn){
      return SignIn(ToggleView:ToggleView);
    }else{
      return SignUp(ToggleView:ToggleView);
    }

  }
}
