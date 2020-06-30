import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crewbrew/models/Item.dart';
import 'package:crewbrew/screens/User/ItemDetails.dart';
import 'package:crewbrew/screens/User/Order.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class WishList extends StatefulWidget {
  @override
  _WishListState createState() => _WishListState();
}

class _WishListState extends State<WishList> {
  Item item=Item();
  List Wishlist=[];
  int price;
  List tags;
  _wishList()async {
    print("WishList");
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    var favoriteList = Firestore.instance
        .collection('User Role')
        .document(user.email)
        .collection('Favorite')
        .document(user.email);
//      favoriteList.setData({
//        'tags':FieldValue.arrayUnion(['']),
//      });
    print("done2");
    DocumentSnapshot doc = await favoriteList.get();
     tags = doc.data['tags'];
     setState(() {
       Wishlist=tags;
     });

    Wishlist.forEach((element) => print(element));
  }
  searchByName(String searchField) {
    return  Firestore.instance
        .collection('Store Items')
        .where('name',
        isEqualTo: searchField)
        .getDocuments();

  }
  getItem(String single)async{
    print("ggg");
   await searchByName(single).then((QuerySnapshot docs){
setState(() {


        item.quantity=docs.documents[0].data['quantity'];
        item.name=docs.documents[0].data['name'];
        item.image=docs.documents[0].data['image'];
        item.price=docs.documents[0].data['price'];
        item.searchKey=docs.documents[0].data['searchKey'];
        item.quantitySold=docs.documents[0].data['quantitySold'];
        item.description=docs.documents[0].data['description'];
        item.type=docs.documents[0].data['type'];
        price=docs.documents[0].data['price'];
        print("hege"+docs.documents[0].data['name']);
        print("hege"+docs.documents[0].data['price'].toString());

});

    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _wishList();
  }
  @override
  Widget build(BuildContext context) {


    return  Scaffold(
      appBar: AppBar(
        title: Text("WishList"),
      ),
       body:ListView.builder(
         itemCount: (Wishlist.length),
         itemBuilder: (BuildContext context, int index){

           return new ListTile(title:Text(Wishlist[index].toString()),trailing: IconButton(icon: Icon(Icons.delete_forever),onPressed: ()async{
             FirebaseUser user = await FirebaseAuth.instance.currentUser();
             var card = Firestore.instance
                 .collection('User Role')
                 .document(user.email).collection('Favorite').document(user.email);
             setState(()async {
               await card.updateData({
                 'tags':FieldValue.arrayRemove([Wishlist[index]]),

               });
               _wishList();
             });
           },),
             onTap: ()async{
            await getItem(Wishlist[index]);
             print(item.price);
              Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context)=>new ItemDetails(item: item,)),);
             },
           );
         },

       )
    );
  }
}
