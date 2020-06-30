import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crewbrew/models/BestSeller.dart';
import 'package:crewbrew/models/Item.dart';
import 'package:crewbrew/models/user.dart';
import 'package:crewbrew/screens/User/ItemDetails.dart';
import 'package:crewbrew/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:status_alert/status_alert.dart';

class Order extends StatefulWidget {
  final Item item;
  Order({this.item});

  @override
  _OrderState createState() => _OrderState();
}

class _OrderState extends State<Order> {
bool loaded;
  bool added=true;
  bool isFavorite=false;
@override
void setState(fn) {
  // TODO: implement setState
  _checkFav();
  super.setState(fn);

}
  _checkFav() async{
    FirebaseUser user1 = await FirebaseAuth.instance.currentUser();
    // Get the token for this device
    // Save it to FireStore
    var favoriteList = Firestore.instance
        .collection('User Role')
        .document(user1.email)
        .collection('Favorite')
        .document(user1.email);
//      favoriteList.setData({
//        'tags':FieldValue.arrayUnion(['']),
//      });

    DocumentSnapshot doc = await favoriteList.get();
    List tags = doc.data['tags'];
    print("heello");
    if (tags.contains(widget.item.name) == true) {
      setState(() {
        isFavorite=true;
      });

    } else {
      setState(() {
        isFavorite=false;
      });

    }
    print("ahah");

//        await favoriteList.setData({
//          'ItemName': item.name,
//        });
    print("done5");
  }

  @override
  void initState() {
    // TODO: implement initState
    _checkFav();
    loaded=false;
    super.initState();

  }
  @override
  void didChangeDependencies() {
    if(!loaded) {
        _checkFav();
    }
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    final data=MediaQuery.of(context);
    int _currentQuantity;
    final user=Provider.of<User>(context);
    DataBaseService Data = DataBaseService();
    BestSeller bestSeller=BestSeller();

    _addFavorite() async {
      // Get the current user
      print("done1");
      // FirebaseUser user = await _auth.currentUser();
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      // Get the token for this device
      // Save it to FireStore
      var favoriteList = Firestore.instance
          .collection('User Role')
          .document(user.email)
          .collection('Favorite')
          .document(user.email);
//      favoriteList.setData({
//        'tags':FieldValue.arrayUnion(['']),
//      });
      print("done2");
        DocumentSnapshot doc=await favoriteList.get();
        List tags=doc.data['tags'];

      print("done3");
        if(tags.contains(widget.item.name)==true){
         await favoriteList.updateData({
            'tags':FieldValue.arrayRemove([widget.item.name]),
            //'price':FieldValue.arrayRemove([widget.item.price]),
          });
        }else{
         await favoriteList.updateData({
            'tags':FieldValue.arrayUnion([widget.item.name]),
           // 'price':FieldValue.arrayUnion([widget.item.price]),
          });
        }
      print("done4");

//        await favoriteList.setData({
//          'ItemName': item.name,
//        });
      print("done5");

    }
        return Padding(

            padding: EdgeInsets.only(top: 10.0, bottom: 0.0, left: 22.0, right: 22.0),
            child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ItemDetails(
                          item: widget.item,

                      )));
                },
                child: Container(

                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 3.0,
                              blurRadius: 5.0)
                        ],
                        color: Colors.white),
                    child: Column(children: [
                      Padding(
                          padding: EdgeInsets.all(0.0),
                          child: InkWell(
                            onTap: (){setState(() {
                              isFavorite=!isFavorite;
                              _addFavorite();
                            });

                              if(isFavorite) {
                                StatusAlert.show(
                                  context,
                                  duration: Duration(seconds: 1),
                                  title: 'Done',
                                  subtitle: 'Add To Favorites',
                                  configuration: IconConfiguration(
                                      icon: Icons.favorite),
                                );
                              }else{
                                StatusAlert.show(
                                  context,
                                  duration: Duration(seconds: 1),
                                  title: 'Done',
                                  subtitle: 'Removed From Favorites',
                                  configuration: IconConfiguration(
                                      icon: Icons.favorite_border),
                                );
                              }
                            },
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  isFavorite
                                      ? Icon(Icons.favorite, color: Color(0xFFEF7532))
                                      : Icon(Icons.favorite_border,
                                      color: Color(0xFFEF7532))
                                ]),
                          )),
                      CachedNetworkImage(
                        fit: BoxFit.fitWidth,
                        imageUrl: widget.item.image,
                        placeholder: (context, url) => CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
//                  Hero(
//                      tag: item.image,
//                      child: Container(
//                          height: 1.0,
//                          width: 1.0,
//                          decoration: BoxDecoration(
//                              image: DecorationImage(
//                                  image: NetworkImage(item.image),
//                                  fit: BoxFit.contain)))),

                      Text(widget.item.name,
                          style: TextStyle(
                              color: Color(0xFFCC8053),
                              fontFamily: 'Varela',
                              fontSize: 14.0)),
                      Text('${widget.item.price} Dollars - ${widget.item.quantity} Left',
                          style: TextStyle(
                              color: Color(0xFF575E67),
                              fontFamily: 'Varela',
                              fontSize: 14.0)),
                      Padding(
                          padding: EdgeInsets.all(1.0),
                          child: Container(color: Color(0xFFEBEBEB), height: 1.0)),
                      Padding(
                          padding: EdgeInsets.only(left: 5.0, right: 5.0,bottom:1.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                if (added) ...[
                                  Icon(Icons.shopping_basket,
                                      color: Color(0xFFD17E50), size: 10),
                                  Text('Add to cart',
                                      style: TextStyle(
                                          fontFamily: 'Varela',
                                          color: Color(0xFFD17E50),
                                          fontSize: 12.0))
                                ],
                                if (!added) ...[
                                  Icon(Icons.remove_circle_outline,
                                      color: Color(0xFFD17E50), size: 10.0),
                                  Text('3',
                                      style: TextStyle(
                                          fontFamily: 'Varela',
                                          color: Color(0xFFD17E50),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.0)),
                                  Icon(Icons.add_circle_outline,
                                      color: Color(0xFFD17E50), size: 10.0),
                                ]
                              ]))
                    ]))));
      }

  }
