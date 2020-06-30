import 'package:cloud_firestore/cloud_firestore.dart';

class Delivery{
  String email;
  String itemName;
  Timestamp date;
  String quantity;
  int total;
  String location;

  Delivery({this.email, this.itemName, this.date, this.quantity, this.total,
      this.location});

  final CollectionReference deliveryCollection =Firestore.instance.collection('Delivery');

  List<Delivery> _rateListFromSnapshot(QuerySnapshot snapshot){
    //we return a list from all the document we have using the snapshot we receive then we convert it to map of lists and put it in the class Brew to use it
    return snapshot.documents.map((doc){
      return Delivery(
        email: doc.data['Email'] ?? '',
        date: doc.data['Date'] ?? 0,
        location: doc.data['location'] ?? '0',
        itemName: doc.data['Item']?? '0',
        total: doc.data['Total']??'',
        quantity: doc.data['quantity']??'',
      );
    }).toList();
  }

//  Stream<List<Reviews>> get review{
//    //we convert the snapshot we have to map and run the method to convert it to list
//    return itemCollection.where('ItemName',isEqualTo:itemName).snapshots().map(_rateListFromSnapshot);
//  }
  Future addDelivery(String email,DateTime date,String location,String itemName,int total,int quantity)async{
    return await deliveryCollection.document().setData(
        { 'Email':email,
          'Date':date,
          'Location':location,
          'Item':itemName,
          'Total':total,
          'quantity':quantity,
        }
    );
  }




}