import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crewbrew/models/Item.dart';
import 'package:crewbrew/models/Reviews.dart';
import 'package:crewbrew/models/user.dart';
import 'package:crewbrew/screens/User/CommentDetails.dart';
import 'package:crewbrew/screens/User/Review.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class CommentPage extends StatefulWidget {
  final Item item;
  CommentPage({this.item});
  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
String currentComment;
Reviews currentreview=Reviews();
  @override
  Widget build(BuildContext context) {
    final user=Provider.of<User>(context);
           return Scaffold(
             appBar: AppBar(
               title: Text("Comment Section"),
               actions: <Widget>[
                 RaisedButton.icon(
                     onPressed: () {
                       return showDialog<void>(
                         context: context,
                         barrierDismissible: true, // user must tap button!
                         builder: (BuildContext context) {
                           return AlertDialog(
                             title: Text('Enter Your Comment Below:'),
                             content: SingleChildScrollView(
                               child: ListBody(
                                 children: <Widget>[
                                   Text(user.email),
                                   TextFormField(
                                     onChanged: (val) {
                                       setState(() {
                                         currentComment = val;
                                       });
                                     },
                                   ),
                                 ],
                               ),
                             ),
                             actions: <Widget>[
                               FlatButton(
                                 child: Text('Submit'),
                                 onPressed: () {
                                   currentreview.addReview(
                                       user.email, DateTime.now(),
                                       currentComment, widget.item.name);
                                   Navigator.of(context).pop();
                                 },
                               ),
                             ],
                           );
                         },
                       );
                     },
                     icon: Icon(Icons.add_comment),
                     label: Text("Add Comment"))
               ],
             ),
             body: CommentDetails(item: widget.item),
           );
       }
  }

