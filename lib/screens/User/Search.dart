import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crewbrew/models/Item.dart';
import 'package:crewbrew/screens/User/ItemDetails.dart';
import 'package:crewbrew/screens/User/SearchService.dart';
import 'package:crewbrew/screens/User/SellerPage.dart';
import 'package:crewbrew/services/database.dart';
import 'package:flutter/material.dart';
class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {

  Item item;
  var queryResultSet = [];
  var tempSearchStore = [];

  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }

    var capitalizedValue =
        value.substring(0, 1).toUpperCase() + value.substring(1);

    if (queryResultSet.length == 0 && value.length == 1) {
      SearchService().searchByName(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.documents.length; ++i) {
          queryResultSet.add(docs.documents[i].data);
          setState(() {
            tempSearchStore.add(queryResultSet[i]);
          });
        }
      });
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if (element['name'].toLowerCase().contains(value.toLowerCase()) ==  true) {
          if (element['name'].toLowerCase().indexOf(value.toLowerCase()) ==0) {
            setState(() {
              tempSearchStore.add(element);
            });
          }
        }

      });
    }
    if (tempSearchStore.length == 0 && value.length > 1) {
      setState(() {});
    }
  }
  
  @override
  Widget build(BuildContext context) {

    return new Scaffold(
        body: ListView(children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              onChanged: (val) {
                initiateSearch(val);
              },
              decoration: InputDecoration(
                  prefixIcon: IconButton(
                    color: Colors.black,
                    icon: Icon(Icons.arrow_back),
                    iconSize: 20.0,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  contentPadding: EdgeInsets.only(left: 25.0),
                  hintText: 'Search by name',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0))),
            ),
          ),
          SizedBox(height: 10.0),
          GridView.count(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              crossAxisCount: 2,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0,
              primary: false,
              shrinkWrap: true,
              children: tempSearchStore.map((element) {
                return buildResultCard(element,context);
              }).toList())
        ]));
  }
}

Widget buildResultCard(data,BuildContext context) {
  var item=Item();
item.quantity=data['quantity'];
item.name=data['name'];
item.image=data['image'];
item.price=data['price'];
item.searchKey=data['searchKey'];
item.quantitySold=data['quantitySold'];
item.description=data['description'];
item.type=data['type'];
print(data['name']);
//DataBaseService().toItemFromSnapshot(data);
      return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          elevation: 2.0,
          child: Container(
              child: Center(
                  child: InkWell(
                    child: Column(

                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top:20.0,left: 10),
                          child: CachedNetworkImage(
                            fit: BoxFit.fitWidth,
                            imageUrl: item.image,
                            placeholder: (context, url) => CircularProgressIndicator(),
                            errorWidget: (context, url, error) => Icon(Icons.error),
                          ),
                        ),
                        SizedBox(height: 10,),
                        Text(item.name??'not found',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                        ),
                      ),
                      ],
                    ),
                    onTap: (){
                      Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context)=>new ItemDetails(item: item,)),);



                    },
                  )
              )
          )
      );
    }



