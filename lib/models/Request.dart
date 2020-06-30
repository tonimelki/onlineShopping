import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Request {
  final String name;
  final String itemName;
  final int quantity;
  Request({this.name,this.itemName,this.quantity});
  final CollectionReference requestCollection= Firestore.instance.collection('Request');
  List<Request> _requestListFromSnapshot(QuerySnapshot snapshot){
    //we return a list from all the document we have using the snapshot we receive then we convert it to map of lists and put it in the class Brew to use it
    return snapshot.documents.map((doc){
      return Request(
        name: doc.data['name'] ?? 'not Found',
        itemName: doc.data['item'] ?? 'not Found',
        quantity: doc.data['quantity']??0,
      );
    }).toList();
  }
  Stream<List<Request>> get request{
    //we convert the snapshot we have to map and run the method to convert it to list
    return requestCollection.snapshots().map(_requestListFromSnapshot);
  }

  Future addRequest(String name,int qty,String item)async{
        return await requestCollection.document().setData({
          'name':name,
          'quantity':qty,
          'item':item,
        });
      }
}