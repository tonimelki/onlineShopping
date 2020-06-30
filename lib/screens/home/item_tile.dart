import 'package:cached_network_image/cached_network_image.dart';
import 'package:crewbrew/screens/home/UpDate.dart';
import 'package:flutter/material.dart';
import 'package:crewbrew/models/Item.dart';
import 'package:crewbrew/services/database.dart';
class ItemTile extends StatelessWidget {
  final Item item;
  ItemTile({this.item});
  @override
  Widget build(BuildContext context) {
    DataBaseService Data=DataBaseService();
    int quantity;
    void _UpdateItem(){
      showModalBottomSheet(context: context, builder: (context){
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 60.0),
          child: Column(
            children: <Widget>[
              Text("Please Enter The New Quantity"),
              TextFormField(
                initialValue: (item.quantity).toString(),
                onChanged: (val)=>quantity=int.parse(val),
              ),
              IconButton(
                icon: Icon(Icons.update),
                onPressed: (){
                  Data.additem(item.name, item.image,item.description, item.price,(quantity),item.type,0);
                },
              )
            ],
          ),
        );
      });
    }
    return Padding(
      padding:EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0),
        child: ListTile(
          leading:CachedNetworkImage(
            imageUrl: item.image,
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          title: Text(item.name),
          subtitle: Text(' ${item.price}"dollars" ${item.quantity} Left'),

          trailing:Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Container(
                child: new IconButton(icon: Icon(Icons.delete),
                    onPressed:()=>Data.deleteData(item.name))
            ),
            Container(
              child: IconButton(icon: Icon(Icons.edit),
                onPressed: (){
                  _UpdateItem();
                },
              ),
            )
          ],
        ),
        ),
      ),
    );
  }
}
