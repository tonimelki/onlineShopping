import 'package:crewbrew/models/BestSeller.dart';
import 'package:crewbrew/models/Item.dart';
import 'package:crewbrew/screens/User/BestList.dart';
import 'package:crewbrew/screens/User/Order.dart';
import 'package:crewbrew/screens/home/item_tile.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
class TopItems extends StatefulWidget {
  @override
  _TopItemsState createState() => _TopItemsState();
}

class _TopItemsState extends State<TopItems> {
  @override
  Widget build(BuildContext context) {
    final item=Provider.of<List<Item>>(context);
    //print(brews.documents);
    //print out all the documents(data) in the brews collection
    try {
      return ListView.builder(

          itemCount: item.length,
          itemBuilder: (context, index) {
            return BestList(item: item[index]);
          }

      );
    }catch(e){
      print('Not Items Found');
    }
    return Container(width: 0.0,height: 0.0,);
  }
}


