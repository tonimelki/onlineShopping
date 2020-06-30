import 'package:crewbrew/models/Item.dart';
import 'package:crewbrew/models/Reviews.dart';
import 'package:crewbrew/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class Review extends StatelessWidget {
  final Item item;
  final Reviews reviews;
  Review({this.reviews,this.item});
  @override
  Widget build(BuildContext context) {
    final user=Provider.of<User>(context);
   if(item.name==reviews.itemName) {
     return Padding(
       padding: EdgeInsets.only(top: 8.0),
       child: Card(
         margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0),
         child: ListTile(
           title: Text(reviews.username),
           subtitle: Text('${reviews.rating}\n${reviews.date}'),
           trailing: Column(
             children: <Widget>[
               new Container(
                   child: new IconButton(icon: Icon(Icons.details),
                       onPressed: () =>
                           Navigator.push(context, new MaterialPageRoute(
                               builder: (
                                   BuildContext context) => new Review()),)
                   )
               )
             ],
           ),
         ),
       ),
     );
   }else
     {return Container(width: 0.0,height: 0.0,);}
  }
}
