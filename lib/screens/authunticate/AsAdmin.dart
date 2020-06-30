import 'package:crewbrew/screens/home/home.dart';
import 'package:crewbrew/services/auth.dart';
import 'package:crewbrew/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:crewbrew/shared/constant.dart';
class AsAdmin extends StatefulWidget {

  @override
  _AsAdminState createState() => _AsAdminState();
}

class _AsAdminState extends State<AsAdmin> {
  final AuthService _auth=AuthService();
  final _formKey=GlobalKey<FormState>();
  bool loading=false;
  //text field value
  String email='';
  String password='';
  String error='';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: Text('Sign In As Admin'),

      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20,horizontal: 50),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0,),
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
              RaisedButton(
                color: Colors.pink[500],
                child: Text(
                  'Sign In',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: (){
                  if(email=='tonimelki@gmail.com'&&password=='12345678'){
                    Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context)=>new Home()),);
                  }
                },
              ),
              SizedBox(height: 20.0,),
              Text(error),
              RaisedButton.icon(onPressed: (){
                Navigator.pop(context);
              },
                icon: Icon(Icons.supervisor_account),
                label: Text("As User"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
