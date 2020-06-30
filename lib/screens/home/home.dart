


import 'package:crewbrew/models/Item.dart';
import 'package:crewbrew/models/user.dart';
import 'package:crewbrew/screens/User/RequestBox.dart';
import 'package:crewbrew/screens/User/Search.dart';
import 'package:crewbrew/screens/User/SellerPage.dart';
import 'package:crewbrew/screens/home/AddItem.dart';
import 'package:crewbrew/screens/home/OrdersList.dart';
import 'package:crewbrew/screens/home/OutStock.dart';
import 'package:crewbrew/screens/home/RequestList.dart';
import 'package:crewbrew/screens/home/UpDate.dart';
import 'package:crewbrew/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:crewbrew/services/database.dart';
import 'package:provider/provider.dart';
import 'package:crewbrew/screens/home/Item_list.dart';
class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user=Provider.of<User>(context);
    void _AddItemPanel(){
      showModalBottomSheet(context: context, builder: (context){
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 60.0),
          child:AddItem(),
        );
      });
    }
    //instance of auth for use the method in the class
    final AuthService _auth=AuthService();

    //this is to get the data value from brews method in auth using the class data base provider
    return StreamProvider<List<Item>>.value(
      value: DataBaseService().items,
      child: Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          title: Text('My Store'),
          backgroundColor: Colors.brown[400],
          elevation: 0.0,
          actions: <Widget>[
           IconButton(onPressed:(){
              Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context)=>new Search()),);
            }, icon:Icon(Icons.search),
            ),
            FlatButton.icon( onPressed: () => Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context)=>new AddItem()),),
                icon: Icon(Icons.add),
                label: Text('Add Item')),
            FlatButton.icon(onPressed:()async{
              await _auth.SignOut();
            },

                icon:Icon(Icons.person),
                label: Text('log out')),


          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              new UserAccountsDrawerHeader(
                accountName: Text(user.uid) ,
                accountEmail: Text(user.email),
                currentAccountPicture: new CircleAvatar(
                  backgroundImage: NetworkImage('https://picsum.photos/250?image=9'),
                ),
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text('Home'),
                onTap: (){Home();},
              ),
              ListTile(
                leading: Icon(Icons.vertical_align_top),
                title: Text('Best Seller'),
                onTap: (){Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context)=>new SellerPage()),);},
              ),
              ListTile(
                leading: Icon(Icons.shopping_basket),
                title: Text('Orders List'),
                onTap: (){Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context)=>new OrdersList()),);},
              ),
              ListTile(
                leading: Icon(Icons.playlist_add),
                title: Text('Request Box'),
                onTap: (){Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context)=>new RequestList()),);},
              ),
              ListTile(
                leading: Icon(Icons.store),
                title: Text('OutStock'),
                onTap: (){Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context)=>new OutStock()),);},
              ),
              ListTile(
                leading: Icon(Icons.info),
                title: Text('About'),
                onTap: (){},
              ),
            ],
          ),
        ),
        body: ItemList(),
      ),
    );
  }
}
