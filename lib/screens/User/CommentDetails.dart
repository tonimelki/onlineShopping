import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crewbrew/models/Item.dart';
import 'package:crewbrew/models/Reviews.dart';
import 'package:crewbrew/screens/User/Review.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommentDetails extends StatelessWidget {
  final Item item;
  CommentDetails({this.item});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('Reviews').where('ItemName',isEqualTo: item.name).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return new Text('Loading...');
          default:
            return new ListView(
              children: snapshot.data.documents.map((DocumentSnapshot document) {
                return new ListTile(
                  title: new Text(document['Rating']??'hi'),
                  subtitle: new Text(document['name']??'hello'),
                );
              }).toList(),
            );
        }
      },
    );
  }
}
