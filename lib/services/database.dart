import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crewbrew/models/Item.dart';
import 'package:crewbrew/models/Role.dart';
import 'package:crewbrew/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
class DataBaseService{
  //create a instance uid to use it in the method to give every specific data a user by get his id from the class
  final String name;
  DataBaseService({this.name});

  //collection reference
  //create a collection named brews if is not created
  final CollectionReference itemCollection =Firestore.instance.collection('Store Items');
  final CollectionReference orderCollection=Firestore.instance.collection('Order');
  final CollectionReference roleCollection= Firestore.instance.collection('User Role');
  final CollectionReference sellerCollection= Firestore.instance.collection('Best Seller');


  //create document using the uid of the user who log in and set the data in it
Future additem(String name,String image,String description ,int price,int quantity,String type,int qua)async{
  var currentQty=Firestore.instance.collection('Store Items').where('name',isEqualTo: name);
  currentQty.getDocuments().then((data)async{
    if(data.documents.length>0){
      int current;
      current=data.documents[0].data['quantitySold'];
      print((current).toString());
      return await itemCollection.document(name).setData(
          { 'name':name,
            'image':image,
            'description':description,
            'price':price,
            'quantity':quantity,
            'type':type,
            'quantitySold':qua+current,
            'searchKey':name.substring(0,1).toUpperCase(),

          }
      );
    }
    else
      {
        return await itemCollection.document(name).setData(
            { 'name':name,
              'image':image,
              'description':description,
              'price':price,
              'quantity':quantity,
              'type':type,
              'quantitySold':qua,
              'searchKey':name.substring(0,1).toUpperCase(),

            }
        );

      }
  });
}
Future AddOrder(String name,DateTime date,String email,int quantity,int price,String location)async{
  return await orderCollection.document().setData(
    { 'Item':name,
      'Date':date,
      'Email':email,
      'quantity':quantity,
      'Total':quantity*price,
      'location':location,
    }
  );

}

Future addRole(String uid,String role,String location, String email)async{
  return await roleCollection.document(email).setData(
    {
      'email':email,
      'Role':role,
      'Location':location,
    }
  );
}
Future addToken()async {
  final FirebaseMessaging _fcm=FirebaseMessaging();
  FirebaseUser user = await FirebaseAuth.instance.currentUser();
  // Get the token for this device
  String fcmToken = await _fcm.getToken();
  StreamSubscription iosSubscription;
  if (Platform.isIOS){
    iosSubscription = _fcm.onIosSettingsRegistered.listen((data) async {
      // save the token  OR subscribe to a topic here
      if (fcmToken != null) {
        var tokens = Firestore.instance
            .collection('User Role')
            .document(user.email)
            .collection('tokens')
            .document(fcmToken);

        await tokens.setData({
          'token': fcmToken,
          'createdAt': FieldValue.serverTimestamp(), // optional
          'platform': Platform.operatingSystem // optional
        });
      }
    });
    _fcm.requestNotificationPermissions(IosNotificationSettings());
  }else
  {
    if (fcmToken != null) {
      var tokens = Firestore.instance
          .collection('User Role')
          .document(user.email)
          .collection('tokens')
          .document(fcmToken);

      await tokens.setData({
        'token': fcmToken,
        'createdAt': FieldValue.serverTimestamp(), // optional
        'platform': Platform.operatingSystem // optional
      });
    }
  }

}
Future addFavorite()async{
  FirebaseUser user = await FirebaseAuth.instance.currentUser();
  var favoriteList = Firestore.instance
      .collection('User Role')
      .document(user.email)
      .collection('Favorite')
      .document(user.email);
  favoriteList.setData({
    'tags':[],

  });
}
Future addCart()async{
  FirebaseUser user = await FirebaseAuth.instance.currentUser();
  var favoriteList = Firestore.instance
      .collection('User Role')
      .document(user.email)
      .collection('Cart')
      .document(user.email);
  favoriteList.setData({
'quantity':[],
    'tags':[],
  });
}
  Future addBestSeller(String name,int qua,String image,int price,int quantity,String description,String type)async{

    var currentQty=Firestore.instance.collection('Store Items').where('name',isEqualTo: name);
    currentQty.getDocuments().then((data)async{
      if(data.documents.length>0){
        int current;

        current=data.documents[0].data['quantitySold'];
        print((current).toString());
        return await itemCollection.document(name).setData(
            { 'name':name,
              'image':image,
              'description':description,
              'price':price,
              'quantity':quantity,
              'type':type,
              'quantitySold':qua+current,

            }
        );
      }
    });
  }



//Item list from snapshot
  List<Item> itemListFromSnapshot(QuerySnapshot snapshot){
  //we return a list from all the document we have using the snapshot we receive then we convert it to map of lists and put it in the class Brew to use it
  return snapshot.documents.map((doc){
    return Item(
      name: doc.data['name'] ?? '',
      image: doc.data['image'] ?? 0,
      description: doc.data['description'] ?? '0',
      price: doc.data['price']?? 0 ,
      quantity: doc.data['quantity']??0,
      type: doc.data['type']??'not found',
      quantitySold: doc.data['quantitySold']??0,
      searchKey: doc.data['searchKey']??0,

    );
  }).toList();
  }
  Item toItemFromSnapshot(var snapshot){
    //we return a list from all the document we have using the snapshot we receive then we convert it to map of lists and put it in the class Brew to use it
      return Item(
        name:snapshot['name'] ?? '',
        image: snapshot['image'] ?? 0,
        description: snapshot['description'] ?? '0',
        price: snapshot['price']?? 0 ,
        quantity: snapshot['quantity']??0,
        type: snapshot['type']??'not found',
        quantitySold: snapshot['quantitySold']??0,
        searchKey:snapshot['searchKey']??0,

      );

  }
// to access the data in other form get item collection stream to notify about anything happen
  Stream<List<Item>> get items{
  //we convert the snapshot we have to map and run the method to convert it to list
  return itemCollection.snapshots().map(itemListFromSnapshot);
}
  Stream<List<Item>> get bestSold{
    //we convert the snapshot we have to map and run the method to convert it to list
    return itemCollection.orderBy("quantitySold",descending: true).snapshots().map(itemListFromSnapshot);
  }
List<Role>_roleFromSnapshots(QuerySnapshot snapshot){
  return snapshot.documents.map((doc){
    return Role(
      role: doc.data['Role']??'user',
    );
  }).toList();
}
Stream<List<Role>> get role{
  return roleCollection.snapshots().map(_roleFromSnapshots);
}


deleteData(name){
  Firestore.instance.collection("Store Items").document(name).delete().catchError((error){
    print(error);
  });
}

updateData(selectedDoc,item){
  Firestore.instance.collection("Store Items").document(selectedDoc).updateData(item).catchError((e){
    print(e);
  });
}

}