import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class BestSeller {
  final String name;
  final String image;
  final int quantity;
  final int price;
  final String description;
  final int quantitySold;
  BestSeller({this.name,this.quantity,this.image,this.quantitySold,this.description,this.price});
  final CollectionReference sellerCollection= Firestore.instance.collection('Store Items');
  var bestList;
  getBestSeller(){
    return bestList= Firestore.instance.collection('Store Items').orderBy('quantitySold',descending: true).getDocuments();
  }
  List<BestSeller> _bestSellerListFromSnapshot(QuerySnapshot snapshot){
    //we return a list from all the document we have using the snapshot we receive then we convert it to map of lists and put it in the class Brew to use it
    return snapshot.documents.map((doc){
      return BestSeller(
        name: doc.data['name'] ?? 'not Found',
        quantity: doc.data['quantity'] ?? 0,
        image: doc.data['image']??'not found',
        price: doc.data['quantitySold']??'not found',


      );
    }).toList();
  }
  Stream<List<BestSeller>> get bestSeller{
    //we convert the snapshot we have to map and run the method to convert it to list
    return sellerCollection.orderBy('quantity',descending: true).snapshots().map(_bestSellerListFromSnapshot);
  }

//  Future addBestSeller(String name,int qua,String image)async{
//
//var currentQty=Firestore.instance.collection('Best Seller').where('name',isEqualTo: name);
//currentQty.getDocuments().then((data)async{
//  if(data.documents.length>0){
//    int current;
//     current=data.documents[0].data['quantity'];
//    return await sellerCollection.document(name).setData(
//        { 'name':name,
//          'quantity':qua+current,
//          'image':image,
//        }
//    );
//  }else{
//    return await sellerCollection.document(name).setData(
//        { 'name':name,
//          'quantity':qua,
//          'image':image,
//        }
//    );
//  }
//});
//  }
}