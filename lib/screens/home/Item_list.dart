import 'package:crewbrew/models/Item.dart';
import 'package:crewbrew/screens/home/item_tile.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';


class ItemList extends StatefulWidget {
  @override
  _ItemListState createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  @override
  Widget build(BuildContext context) {
    //access the brews data from provider
    final item=Provider.of<List<Item>>(context);
    // print(brews.documents);
    //print out all the documents(data) in the brews collection
    try {
      return ListView.builder(

          itemCount: item.length,
          itemBuilder: (context, index) {
            return ItemTile(item: item[index]);
          }

      );
    }catch(e){
      print('Not Items Found');
    }
    return Container(width: 0.0,height: 0.0,);
  }
}
