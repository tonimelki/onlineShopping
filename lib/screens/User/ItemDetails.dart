import 'package:cached_network_image/cached_network_image.dart';

import 'package:crewbrew/models/BestSeller.dart';
import 'package:crewbrew/models/Item.dart';
import 'package:crewbrew/models/Reviews.dart';
import 'package:crewbrew/models/Role.dart';
import 'package:crewbrew/models/user.dart';
import 'package:crewbrew/screens/User/CardList.dart';
import 'package:crewbrew/screens/User/CommentPage.dart';
import 'package:crewbrew/screens/User/Review.dart';
import 'package:crewbrew/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:crewbrew/shared/constant.dart';
class ItemDetails extends StatefulWidget {
  final Item item;

  ItemDetails({this.item});

  @override
  _ItemDetailsState createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final data=MediaQuery.of(context);
    CachedNetworkImage getImage() {
      return CachedNetworkImage(
        imageUrl: widget.item.image,
        imageBuilder: (context, imageProvider) =>
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.fill,
                ),
              ),
            ),
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Icon(Icons.error),
      );
    }
    final _formKey = GlobalKey<FormState>();

    int _Quantity;
    final user = Provider.of<User>(context);
    DataBaseService Data = DataBaseService();
    BestSeller bestSeller = BestSeller();
   // final role=Provider.of<Role>(context);
    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance.collection('User Role').document(user.email).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        return Scaffold(
          body: Builder(
            builder: (context1)=>
             Stack(
              children: <Widget>[
                Container(
                  height: 450,
                  child: getImage(),
                ),
                SafeArea(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            MaterialButton(
                              padding: const EdgeInsets.all(8.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Icon(Icons.arrow_back_ios),
                              color: Colors.white,
                              textColor: Colors.black,
                              minWidth: 0,
                              height: 40,
                              onPressed: (){Navigator.pop(context);},
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.white
                          ),
                          child:Column(
                            children: <Widget>[
                              const SizedBox(height: 30.0,),
                               Expanded(
                                 child:
                               SingleChildScrollView(
                                physics: BouncingScrollPhysics(),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    ListTile(
                                      title: Text(widget.item.name,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 28.0),),
//                                      trailing: IconButton(
//                                        icon: Icon(Icons.favorite_border),
//                                        onPressed: (){},
//                                      ),
                                    ),
                                    Padding(
                                      padding:const EdgeInsets.symmetric(horizontal: 2.0,vertical:2.0),
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Container(
                                            alignment:Alignment.centerLeft,
                                            child: Text('Quantity: ${widget.item.quantity} Left \nType: ${widget.item.type}',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18.0),)),
                                      ),
                                    ),
                                    ExpansionTile(
                                      title: Text('Show Details',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                      children: <Widget>[
                                        Container(
                                          alignment: Alignment.topLeft,
                                          padding: const EdgeInsets.all(16.0),
                                          child: Text("Description: ${widget.item.description}"),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                ),
                              ),
                              Container(
                                width: data.size.width/100*100,
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(20.0),),
                                color:Colors.grey.shade900,
                                ),
                                child: Container(
                                  width: data.size.width/100*200,
                                  child: Row(
                                    children: <Widget>[
                                      Text("\$ ${widget.item.price}",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18.0),),
                                       SizedBox(width: data.size.width/100*5,),
                                      Spacer(),
                                      RaisedButton(
                                        padding:  EdgeInsets.symmetric(vertical: data.size.width/100*1.5, horizontal: data.size.width/100*4),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                        onPressed: (){},
                                        color: Colors.orange,
                                        textColor: Colors.white,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Text('Add To Card',style: TextStyle(fontWeight: FontWeight.bold,fontSize: data.size.width/100*3),),
                                             SizedBox(width:data.size.width/100*3,),
                                            InkWell(
                                              child: Container(
                                                padding:  EdgeInsets.all(data.size.width/100*2),
                                                child: Icon(
                                                  Icons.add_shopping_cart,color: Colors.orange,size: data.size.width/100*4,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(10.0),
                                                ),
                                              ),
                                              onTap: (){
                                                print("hi");
                                                return showDialog<void>(
                                                  context: context,
                                                  barrierDismissible: true, // user must tap button!
                                                  builder: (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text('Enter THe Quantity below:'),
                                                      content: SingleChildScrollView(
                                                        child: ListBody(
                                                          children: <Widget>[
                                                            Text(user.email),
                                                            TextFormField(
                                                              validator: (val)=> int.parse(val)>=widget.item.quantity ? 'No enough quantity':null,
                                                              onChanged: (val) {
                                                                setState(() {
                                                                  _Quantity = int.parse(val);
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
                                                            print("hi");
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
                                                                  .collection('Cart')
                                                                  .document(user.email);

                                                              print("done2");
                                                              DocumentSnapshot doc = await favoriteList.get();
                                                              tags = doc.data['tags'];
                                                              setState(() {
                                                                Wishlist=tags;
                                                              });
                                                              if(tags.contains(widget.item.name)==true){
//                                                            await favoriteList.setData({
//                                                              'tags':FieldValue.arrayUnion([widget.item.name]),
//                                                              'quantity':FieldValue.arrayUnion([_Quantity]),
//                                                            });
                                                                print("Alert");


                                                               //AlertDialog(title: Text("you Already Add this Item"),content: Text("hi"),actions: <Widget>[FlatButton(child: Text("No"),),FlatButton(child: Text("Yes"),)],backgroundColor: Colors.blue,);
                                                               showDialog(context: context,builder:(_)=> AlertDialog(title: Text("you Already Add this Item"),content: Text("You Want To See Your List ?"),actions: <Widget>[FlatButton(child: Text("No"),onPressed:
                                                               (){Navigator.pop(context);Navigator.pop(context);},),FlatButton(child: Text("Yes"),onPressed: (){Navigator.pop(context);Navigator.pushReplacement(context, new MaterialPageRoute(
                                                                   builder: (
                                                                       BuildContext context) => new CardList()),);},)],backgroundColor: Colors.white,),barrierDismissible: false);
                                                              }else{
                                                                await favoriteList.updateData({
                                                                  'tags':FieldValue.arrayUnion([widget.item.name]),
                                                                  'quantity':FieldValue.arrayUnion([_Quantity]),
                                                                });
                                                                Navigator.pop(context);
                                                              }

                                                              Wishlist.forEach((element) => print(element));
                                                            }
                                                            _wishList();
//                                                        Navigator.pop(context);
//                                                        Navigator.pop(context);
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: data.size.width/100*1),
                                      RaisedButton(
                                        padding: EdgeInsets.symmetric(vertical:  data.size.width/100*1.5, horizontal: data.size.width/100*4),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                        onPressed:
                                        widget.item.quantity==0?null:() {
                                          return showDialog<void>(
                                            context: context,
                                            barrierDismissible: true, // user must tap button!
                                            builder: (BuildContext context) {
                                              return AlertDialog(

                                                title: Text('Enter The Quantity Below:'),
                                                content: SingleChildScrollView(
                                                  child: Form(
                                                    key: _formKey,
                                                    child: ListBody(
                                                      children: <Widget>[
                                                        Text(user.email),
                                                        TextFormField(
                                                          validator: (val)=> int.parse(val)>=widget.item.quantity ? 'Not enogh quantity ':null,
                                                          onChanged: (val) {
                                                            setState(() {
                                                              if(int.parse(val)>widget.item.quantity){

                                                              }
                                                              _Quantity = int.parse(val);
                                                            });
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                actions: <Widget>[
                                                  FlatButton(
                                                    child: Text('Submit'),
                                                    onPressed:  () {
                                                      if (_formKey.currentState.validate()) {
                                                        print("Validate");
                                                        // If the form is valid, display a Snackbar.
                                                        Scaffold.of(context1)
                                                            .showSnackBar(SnackBar(content: Text('Processing Data')));
                                                      }

                                                      if(widget.item.quantity<_Quantity) {


                                                      }
                                                       else{ Data.additem(
                                                            widget.item.name,
                                                            widget.item.image,
                                                            widget.item.description,
                                                            widget.item.price,
                                                            (widget.item.quantity -
                                                                _Quantity),
                                                            widget.item.type,
                                                            _Quantity);
                                                        Data.AddOrder(
                                                            widget.item.name,
                                                            DateTime.now(),
                                                            user.email,
                                                            _Quantity, widget.item
                                                            .price, snapshot
                                                            .data['Location']);
                                                      Scaffold.of(context1)
                                                          .showSnackBar(SnackBar(content: Text('Order sent')));
                                                        // Data.addBestSeller(widget.item.name, _Quantity, widget.item.image, widget.item.price, widget.item.quantity, widget.item.description, widget.item.type);
                                                        Navigator.pop(context);
                                                        Navigator.pop(context);
                                                      }
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        color: Colors.orange,
                                        textColor: Colors.white,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Text('Make Order',style: TextStyle(fontWeight: FontWeight.bold,fontSize:  data.size.width/100*3),),
                                             SizedBox(width: data.size.width/100*3,),
                                            Container(
                                              padding: EdgeInsets.all( data.size.width/100*2),
                                              child: Icon(
                                                Icons.shopping_cart,color: Colors.orange,size:  data.size.width/100*4,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(10.0),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                  child: Text("View Comments",style: TextStyle(fontSize: 20,fontStyle: FontStyle.italic),),
                                  onTap: (){
                        Navigator.push(context, new MaterialPageRoute(
                        builder: (
                        BuildContext context) => new CommentPage(item: widget.item,)),);
                        },),


                            ],
                          ) ,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}












