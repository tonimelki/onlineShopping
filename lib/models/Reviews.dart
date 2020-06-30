import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crewbrew/models/Item.dart';
import 'package:crewbrew/screens/User/ItemDetails.dart';
class Reviews{
  String username;
  String itemName;
  String rating;
  Timestamp date;
  Reviews({this.username,this.date,this.rating,this.itemName});
  getLatestReview(String itemName){
    return Firestore.instance.collection('Reviews')
        .where('ItemName',isEqualTo: itemName)
        .snapshots();
  }

  final CollectionReference itemCollection =Firestore.instance.collection('Reviews');

  List<Reviews> _rateListFromSnapshot(QuerySnapshot snapshot){
    //we return a list from all the document we have using the snapshot we receive then we convert it to map of lists and put it in the class Brew to use it
    return snapshot.documents.map((doc){
      return Reviews(
        username: doc.data['name'] ?? '',
        date: doc.data['Date'] ?? 0,
        rating: doc.data['Rating'] ?? '0',
        itemName: doc.data['ItemName']?? '0',
      );
    }).toList();
  }

//  Stream<List<Reviews>> get review{
//    //we convert the snapshot we have to map and run the method to convert it to list
//    return itemCollection.where('ItemName',isEqualTo:itemName).snapshots().map(_rateListFromSnapshot);
//  }
  Future addReview(String username,DateTime date,String rating ,String itemName,)async{
    return await itemCollection.document().setData(
        { 'name':username,
          'Date':date,
          'Rating':rating,
          'ItemName':itemName,
        }
    );
  }
}
