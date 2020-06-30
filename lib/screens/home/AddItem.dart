import 'dart:async';

import 'package:crewbrew/services/database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
class AddItem extends StatefulWidget {
  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  final List<String> descType=<String>['Keys','Paint','Tools'];
  final _formKey=GlobalKey<FormState>();
  DataBaseService Data=DataBaseService();
//form Values
  String _currentName;
  String _currentImage;
  String _currentDescription;
  int _currentPrice;
  int _currentQuantity;
  File _image;
  String image;
  String _type;
  @override
  Widget build(BuildContext context) {
Future getImage() async{
  var image=await ImagePicker.pickImage(source: ImageSource.gallery,imageQuality: 50,maxWidth: 400,maxHeight: 400);
  setState(() {
    _image= image;
    print(image);
  });
}
var url;
Future uploadPic() async{
  String fileName=basename(_image.path);
  image=fileName;
  StorageReference storageReference=FirebaseStorage.instance.ref().child(fileName);
  StorageUploadTask storageUploadTask=storageReference.putFile(_image);
  StorageTaskSnapshot taskSnapshot=await storageUploadTask.onComplete;
  url=await storageReference.getDownloadURL();
  print(url);
 await Data.additem(_currentName,url,_type , _currentPrice, _currentQuantity,_currentDescription,0);
  setState(() {
    Scaffold.of(context).showSnackBar(SnackBar(content: Text('Item Image Has been Uploaded'),));
  });
}
    return Scaffold(
      appBar: AppBar(
        title: Text('App Item Page'),
      ),
      body:
      Column(
        children: <Widget>[
          Text('Add an Item:',
            style: TextStyle(fontSize: 18.0),),
          //  SizedBox(height: 20.0,),
          TextFormField(
            //  style: TextStyle(height: 0.0),
            decoration: InputDecoration(
              hintText: 'Enter a name',
            ),
            validator: (val)=>val.isEmpty? 'please Enter a name':null,
            onChanged: (val)=> setState(()=>_currentName=val),
          ),
          //  SizedBox(height: 20.0,),
          TextFormField(
            //  style: TextStyle(height: 0.0),
            decoration: InputDecoration(
              hintText: 'Enter a description',
            ),
            validator: (val)=>val.isEmpty? 'please Enter a desc':null,
            onChanged: (val)=> setState(()=>_type=val),
          ),
          DropdownButtonFormField(
            //decoration: InputDecoration,
            hint:Text ('Choose one'),
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
          RaisedButton.icon(
            label: Text('Browse'),
            icon: Icon(Icons.camera),
           color: Colors.lightBlue,
            onPressed: (){
             getImage();

            },


          ),
          //SizedBox(height: 20.0,),
          TextFormField(
            decoration: InputDecoration(
              hintText: 'Enter a price ',
            ),
            validator: (val)=>val.isEmpty? 'please Enter a Price':null,
            onChanged: (val)=> setState(()=>_currentPrice=int.parse(val)),
          ),
          // SizedBox(height: 20.0,),
          TextFormField(
            decoration: InputDecoration(
              hintText: 'Enter The Quantity',
            ),
            validator: (val)=>val.isEmpty? 'please Enter a Quantity':null,
            onChanged: (val)=> setState(()=>_currentQuantity=int.parse(val)),
          ),
          RaisedButton.icon(onPressed:(){ uploadPic();Navigator.pop(context);},
              icon: Icon(Icons.update),
              color: Colors.brown,
              highlightColor: (Colors.redAccent),
              label: Text('Add')),
        ],
      ),
    );
  }
}
