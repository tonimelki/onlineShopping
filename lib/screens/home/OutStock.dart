import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crewbrew/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
class OutStock extends StatefulWidget {
  @override
  _OutStockState createState() => _OutStockState();
}

class _OutStockState extends State<OutStock> {
  @override
  Widget build(BuildContext context) {
    DataBaseService data=DataBaseService();
    int currentQuantity;
    return Scaffold(
      appBar: AppBar(
        title: Text('OutStock'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('Store Items').where('quantity',isLessThan: 10).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          try {
            if (snapshot.data.documents.isEmpty) {
              return Text("We Have No OutStock");
            } else {
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return new Text('Loading...');
                default:
                  return Container(
                    color: Colors.white,
                    child: new ListView(
                      children: snapshot.data.documents.map((
                          DocumentSnapshot document) {
                        return Slidable(
                          actionPane: SlidableDrawerActionPane(),
                          actionExtentRatio: 0.25,
                          child: Card(
                            child: ListTile(
                              title: new Text(document['name'] ?? 'hi'),
                              subtitle: new Text(document['quantity'].toString()),
                              trailing: IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () async {
                                  return showDialog<void>(
                                    context: context,
                                    barrierDismissible: true, // user must tap button!
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Enter The New Quantity Below:'),
                                        content: SingleChildScrollView(
                                          child: ListBody(
                                            children: <Widget>[
                                              TextFormField(
                                                onChanged: (val) {
                                                  setState(() {
                                                    currentQuantity = int.parse(val);
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
                                              data.additem(document['name'], document['image'],document['description'], document['price'],(currentQuantity),document['type'],document['quantitySold']);
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
              }
            }
          }catch(ex){return Container(); }
        }
      ),
    );
  }

}

