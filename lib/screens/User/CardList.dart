import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crewbrew/models/Item.dart';
import 'package:crewbrew/screens/User/ItemDetails.dart';
import 'package:crewbrew/screens/User/WishList.dart';
import 'package:crewbrew/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:status_alert/status_alert.dart';

class CardList extends StatefulWidget {
  @override
  _CardListState createState() => _CardListState();
}

class _CardListState extends State<CardList> {
  DataBaseService Data = DataBaseService();
  Item item = Item();
  List cardList = [];
  List cardPrice = [];
  int total=0;
  int priceTotal=0;
  List price;
  var tags;
  _cardList() async {
    print("cardList");
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    var favoriteList = Firestore.instance
        .collection('User Role')
        .document(user.email)
        .collection('Cart')
        .document(user.email);

    print("done2");
    DocumentSnapshot doc = await favoriteList.get();
    tags = doc.data['tags'];
    price = doc.data['quantity'];
    setState(() {
      cardList = tags;
      cardPrice = price;
    });

total=0;
setState(() {
  for(int i=0;i<cardPrice.length;i++){
    total=total+cardPrice[i];

  }
});



    print("hi"+total.toString());
    cardPrice.forEach((element) => print(element));
  }

  searchByName(String searchField) {
    return Firestore.instance
        .collection('Store Items')
        .where('name', isEqualTo: searchField)
        .getDocuments();
  }

  getItem(String single) async {
    print("ggg");
    await searchByName(single).then((QuerySnapshot docs) {
      setState(() {
        item.quantity = docs.documents[0].data['quantity'];
        item.name = docs.documents[0].data['name'];
        item.image = docs.documents[0].data['image'];
        item.price = docs.documents[0].data['price'];
        item.searchKey = docs.documents[0].data['searchKey'];
        item.quantitySold = docs.documents[0].data['quantitySold'];
        item.description = docs.documents[0].data['description'];
        item.type = docs.documents[0].data['type'];
        //price=docs.documents[0].data['price'];
        print("hege" + docs.documents[0].data['name']);
        print("hege" + docs.documents[0].data['price'].toString());
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cardList();
  }
@override
  void setState(fn) {
    // TODO: implement setState
    super.setState(fn);
  }
  @override
  Widget build(BuildContext context) {
    bool alldone=true;
    int updateqty=0;
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart List"),

      ),
      body: Center(
        child: ListView.builder(
          itemCount: (cardList.length),
          itemBuilder: (BuildContext context, int index) {
            // getItem(cardList[index]);
            return new ListTile(
              title: Text(cardList[index].toString()),
              trailing:Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new Container(
                      child: new IconButton(icon: Icon(Icons.edit),
                          onPressed:(){
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
                                              updateqty = int.parse(val);
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text('Submit'),
                                      onPressed: ()async {
                                        FirebaseUser user = await FirebaseAuth.instance.currentUser();
                                        var card = Firestore.instance
                                            .collection('User Role')
                                            .document(user.email).collection('Cart').document(user.email);
                                        await card.updateData({
                                          'tags':FieldValue.arrayRemove([cardList[index]]),
                                          'quantity':FieldValue.arrayRemove([cardPrice[index]]),
                                        });
                                        await card.updateData({
                                          'tags':FieldValue.arrayUnion([cardList[index]]),
                                          'quantity':FieldValue.arrayUnion([updateqty]),
                                        });

                                        Navigator.of(context).pop();
                                       setState(() {
                                         _cardList();
                                       });
                                      },
                                    ),
                                  ],
                                );
                              },
                            );

                          })
                  ),
                  Container(
                    child: IconButton(icon: Icon(Icons.delete_sweep),onPressed: ()async{
                      FirebaseUser user = await FirebaseAuth.instance.currentUser();
                      var card = Firestore.instance
                          .collection('User Role')
                          .document(user.email).collection('Cart').document(user.email);
                      await card.updateData({
                        'tags':FieldValue.arrayRemove([cardList[index]]),
                        'quantity':FieldValue.arrayRemove([cardPrice[index]]),
                      });
                      setState(() {

                        _cardList();



                      });

                    },),
                  )
                ],
              ),
              subtitle: Text(cardPrice[index].toString()) ?? "null",
              onTap: () async {
                await getItem(cardList[index]);
                //print(item.price);
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (BuildContext context) => new ItemDetails(
                            item: item,
                          )),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async{
          print("before stream");


          print("in Stream");
          for(int i=0;i<cardList.length;i++) {
            FirebaseUser user = await FirebaseAuth.instance.currentUser();
            var favoriteList = Firestore.instance
                .collection('User Role')
                .document(user.email);

            print("done2");
            String loca;
            DocumentSnapshot doc = await favoriteList.get();
            loca = doc.data['Location'];
           await getItem(cardList[i]);
           print(price[i]);
           print(item.name);
           if(item.quantity>=price[i]) {
             await Data.additem(
                 item.name,
                 item.image,
                 item.description,
                 item.price,
                 (item.quantity - price[i]),
                 item.type,
                 price[i]);
             await Data.AddOrder(
                 item.name, DateTime.now(), user.email,
                 price[i], item.price, loca);
             // Data.addBestSeller(widget.item.name, _Quantity, widget.item.image, widget.item.price, widget.item.quantity, widget.item.description, widget.item.type);
             print("final");
             var card = Firestore.instance
                 .collection('User Role')
                 .document(user.email).collection('Cart').document(user.email);
             await card.updateData({
               'tags': FieldValue.arrayRemove([cardList[i]]),
               'quantity': FieldValue.arrayRemove([cardPrice[i]]),
             });
           }else{
             alldone=false;
             showDialog(context: context,
             builder: (_)=>AlertDialog(title: Text("${item.name} cannot be ordered"),
             content: Text("we not have more than ${item.quantity} item of this product \n please wait till we have this amount "),
             actions: <Widget>[
               FlatButton(child:Text("OK"),onPressed: (){
                 setState(() {
                   _cardList();
                 });
                 Navigator.of(context).pop();
               },),
             ],),);

           }
          }
          if(alldone) {
            setState(() {
              cardList = [];
              cardPrice = [];
              total = 0;
            });
            StatusAlert.show(
              context,
              duration: Duration(seconds: 2),
              title: 'All Done',
              subtitle: 'Success',
              configuration: IconConfiguration(icon: Icons.done),
            );
          }
        },
        label: Text('Approve\nTotal:$total'),
        icon: Icon(Icons.thumb_up),
        backgroundColor: Colors.pink,
      ),
    );
  }
}
