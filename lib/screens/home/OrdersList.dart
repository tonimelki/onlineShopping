import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crewbrew/models/Delivery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
class OrdersList extends StatefulWidget {
  @override
  _OrdersListState createState() => _OrdersListState();
}

class _OrdersListState extends State<OrdersList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Orders List"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('Order').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError)
            return new Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting: return new Text('Loading...');
            default:
              return new ListView(
                children: snapshot.data.documents.map((DocumentSnapshot document) {
                   return Card(
                      child: ListTile(
                        title: new Text("${document['Email']} \n${document['location']}"??'hi'),
                        subtitle: new Text("${document['Item']} \nQuantity:${document['quantity']} \nTotal: ${document['Total']}"??0),
                          trailing:Column(
                            children: <Widget>[
                              new Container(
                                  child: new IconButton(icon: Icon(Icons.send),
                                    onPressed:()async {
                                      Delivery().addDelivery(
                                          document['Email'], DateTime.now(),
                                          document['location'],
                                          document['Item'], document['Total'],
                                          document['quantity']);

                                      await Firestore.instance
                                          .collection('Order')
                                          .document(document.documentID)
                                          .delete();
                                    }
                                  )
                              )
                            ],
                          )
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
