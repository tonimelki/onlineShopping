
import 'package:crewbrew/services/database.dart';
import 'package:flutter/material.dart';
import 'package:crewbrew/shared/constant.dart';
import 'package:crewbrew/models/Item.dart';
import 'package:provider/provider.dart';
class UpDate extends StatefulWidget {

  @override
  _UpDateState createState() => _UpDateState();
}

class _UpDateState extends State<UpDate> {
  final List<String> descType=<String>['Keys','Paint','Tools'];
  final _formKey=GlobalKey<FormState>();

  DataBaseService Data=DataBaseService();
//form Values

  String _currentName;
  String _currentImage;
  String _currentDescription;
  int _currentPrice;
  int _currentQuantity;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Text('Update the Selected Item:',
          style: TextStyle(fontSize: 18.0),),
        //  SizedBox(height: 20.0,),
          TextFormField(
            initialValue:_currentName,
          //  style: TextStyle(height: 0.0),
            decoration: InputDecoration(
             // hintText: 'Enter a name',
            ),
            validator: (val)=>val.isEmpty? 'please Enter a name':null,
            onChanged: (val)=> setState(()=>_currentName=val),
          ),
        //  SizedBox(height: 20.0,),
        DropdownButtonFormField(
          //decoration: InputDecoration,
          //hint:Text ('Choose one'),
          value:_currentDescription,
          items:descType.map((type){
            return DropdownMenuItem(
              value: type,
              child: Text('$type'),
            );
          }).toList(),
          onChanged: (val)=> setState(()=>_currentDescription=val),
        ),
         // SizedBox(height: 20.0,),
          TextFormField(
            initialValue: _currentImage,
           decoration: InputDecoration(
             //hintText: 'Enter a Image',
           ),
            validator: (val)=>val.isEmpty? 'please Enter a Image':null,
            onChanged: (val)=> setState(()=>_currentImage=val),
          ),
          //SizedBox(height: 20.0,),
          TextFormField(
            initialValue: _currentPrice.toString(),
            decoration: InputDecoration(
            //  hintText: 'Enter a price ',
            ),
            validator: (val)=>val.isEmpty? 'please Enter a Price':null,
            onChanged: (val)=> setState(()=>_currentPrice=int.parse(val)),
          ),
         // SizedBox(height: 20.0,),
          TextFormField(
            initialValue: _currentQuantity.toString(),
           decoration: InputDecoration(
         //    hintText: 'Enter The Quantity',
           ),
            validator: (val)=>val.isEmpty? 'please Enter a Quantity':null,
            onChanged: (val)=> setState(()=>_currentQuantity=int.parse(val)),
          ),
          RaisedButton.icon(onPressed: ()=>(){},
              icon: Icon(Icons.update),
              color: Colors.brown,
              highlightColor: (Colors.redAccent),
              label: Text('Update')),
        ],
      ),
    );
  }
}

