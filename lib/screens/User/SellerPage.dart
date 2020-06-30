
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crewbrew/models/BestSeller.dart';
import 'package:crewbrew/models/Item.dart';
import 'package:crewbrew/screens/User/ItemDetails.dart';
import 'package:crewbrew/screens/User/TopItems.dart';
import 'package:crewbrew/services/database.dart';
import 'package:crewbrew/shared/constant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crewbrew/shared/constant.dart';
import 'package:crewbrew/screens/User/TopItems.dart';
class SellerPage extends StatefulWidget {
  @override
  _SellerPageState createState() => _SellerPageState();
}

class _SellerPageState extends State<SellerPage> {
  bool flag=false;
  var top1;
  var top2;
  var top3;
  BestSeller bestSeller=BestSeller();
  @override
  Widget build(BuildContext context) {
    return  StreamProvider<List<Item>>.value(
      value: DataBaseService().bestSold,
       child: Scaffold(
         appBar: AppBar(
           title: Text("best Items in the Store"),
         ),
         body: TopItems(),
       ),
    );
  }
}



