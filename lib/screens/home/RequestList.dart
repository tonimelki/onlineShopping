import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
class RequestList extends StatefulWidget {
  @override
  _RequestListState createState() => _RequestListState();
}

class _RequestListState extends State<RequestList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Request List"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('Request').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError)
            return new Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting: return new Text('Loading...');
            default:
              return new ListView(
                children: snapshot.data.documents.map((DocumentSnapshot document) {
                  return Slidable(
                    actionPane: SlidableDrawerActionPane(),
                    actionExtentRatio: 0.25,
                    child:Card(
                    child: ListTile(
                      leading: IconButton(
                        icon: Icon(Icons.check_circle_outline),
                        onPressed: ()async{
                          await Firestore.instance
                              .collection('Request')
                              .document(document.documentID)
                              .delete();
                          final snackBar = SnackBar(content: Text('Request Working on it'));
                          print("accept");

// Find the Scaffold in the widget tree and use it to show a SnackBar.
                          Scaffold.of(context).showSnackBar(snackBar);
                        },
                      ),
                    title: new Text(document['item']??'hi'),
                    subtitle: new Text(document['name']+'\n'+(document['quantity']).toString()+'Requested'??0),
                      trailing: IconButton(
                        icon: Icon(Icons.block),
                        onPressed: ()async{
                          await Firestore.instance
                              .collection('Request')
                              .document(document.documentID)
                              .delete();

                          final snackBar = SnackBar(content: Text('Request cancelled '));
                          print("accept");

// Find the Scaffold in the widget tree and use it to show a SnackBar.
                          Scaffold.of(context).showSnackBar(snackBar);

                        },
                      ),
                  ),
                    ),
                  );
                }).toList(),
              );
          }
        },
      ),
    );
  }
}
