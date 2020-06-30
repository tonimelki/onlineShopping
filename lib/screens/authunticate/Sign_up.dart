import 'package:crewbrew/models/user.dart';
import 'package:crewbrew/screens/authunticate/delayed_animation.dart';
import 'package:crewbrew/services/auth.dart';
import 'package:crewbrew/services/database.dart';
import 'package:crewbrew/shared/constant.dart';
import 'package:crewbrew/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
  final Function ToggleView;
  SignUp({this.ToggleView});
}

class _SignUpState extends State<SignUp> {
  final AuthService _auth=AuthService();

  //to validate the form and associate him
  final _formKey=GlobalKey<FormState>();
  final int delayedAmount=500;
  bool loading=false;
  String email='';
  String password='';
  String location='';
  String error='';
  @override
  Widget build(BuildContext context) {
    final user=Provider.of<User>(context);
     return loading? Loading(): MaterialApp(
        home: Scaffold(
          backgroundColor: Color(0xFF8185E2),
          appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          elevation: 0.0,
           title: Text('Sign Up to G.M.G Store'),
          actions: <Widget>[
            FlatButton.icon(onPressed:(){
              //call the method to switch
              widget.ToggleView();
            }, icon: Icon(Icons.person),
                label:Text('Sign in'))
          ],
        ),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 20,horizontal: 50),
          child: Form(
            //now we can validate the form with this key is we need to register and track it
            key: _formKey,
            child: Column(
              children: <Widget>[
                DelayedAnimation(
                  child: Text("Enter Your Info Here",style: TextStyle(fontWeight: FontWeight.w500,fontStyle:FontStyle.italic,fontSize: 20.0,color: Colors.white70),),
                  delay: delayedAmount+800,
                ),
                SizedBox(height: 20.0,),
                TextFormField(
                  decoration: textinputdecoration.copyWith(hintText: 'Email'),
                  //check for the data
                  validator: (val)=> val.isEmpty ? 'Enter an email':null,
                  onChanged: (val){
                    setState(() {
                      email=val;
                    });
                  },
                ),
                SizedBox(height: 20.0,),
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
                SizedBox(height: 20.0,),
                TextFormField(
                  decoration: textinputdecoration.copyWith(hintText: 'Location'),
                  validator: (val)=> val.length <4 ? 'We Need Your Location To Send The Order ':null,
                  obscureText: false,
                  onChanged: (val){
                    setState(() {
                      location=val;
                    });
                  },
                ),
                SizedBox(height: 20.0,),
                RaisedButton(
                  color: Colors.pink[500],
                  child: Text(
                    'Register',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: ()async{
                    //to see what values in this key (return true or false)true when all validator return null
                  if(_formKey.currentState.validate()){
                    setState(() {
                      loading=true;
                    });
                    //return null id error or result user
                    dynamic result =await _auth.registerWithEmailAndPassword(email,password,location);

                    //Navigator.pop(context);
                    if(result==null){
                      setState(() {
                        error='please supply with email and password';
                        loading=false;
                      });
                    }
                  }
                  },
                ),
                SizedBox(height: 20.0,),
                Text(error),
              ],
            ),
          ),
        ),
        )
     );
  }
}
