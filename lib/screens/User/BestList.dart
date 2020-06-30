import 'package:cached_network_image/cached_network_image.dart';
import 'package:crewbrew/models/BestSeller.dart';
import 'package:crewbrew/models/Item.dart';
import 'package:crewbrew/models/user.dart';
import 'package:crewbrew/screens/User/ItemDetails.dart';
import 'package:crewbrew/screens/User/SellerPage.dart';
import 'package:crewbrew/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class BestList extends StatelessWidget {
  final Item item;
  BestList({this.item});
  @override
  Widget build(BuildContext context) {
   // BestSeller bestSeller=BestSeller();
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0),
        child: ListTile(
          leading: CachedNetworkImage(
            imageUrl: item.image,
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          title: Text(item.name),
          subtitle: Text(' ${item.quantitySold} ordered'),

          trailing: Column(
            children: <Widget>[
              new Container(
                  child: new IconButton(icon: Icon(Icons.details),
                      onPressed: () => Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context)=>new ItemDetails(item: item,)),)
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}
