import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crewbrew/models/BestSeller.dart';
import 'package:crewbrew/models/Item.dart';
import 'package:crewbrew/models/user.dart';
import 'package:crewbrew/screens/User/CardList.dart';
import 'package:crewbrew/screens/User/RequestBox.dart';
import 'package:crewbrew/screens/User/Search.dart';
import 'package:crewbrew/screens/User/SellerPage.dart';
import 'package:crewbrew/screens/User/ItemListUser.dart';
import 'package:crewbrew/screens/User/WishList.dart';
import 'package:crewbrew/screens/home/Item_list.dart';
import 'package:crewbrew/services/auth.dart';
import 'package:crewbrew/services/database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rounded_floating_app_bar/rounded_floating_app_bar.dart';

class UserHome extends StatefulWidget {
  @override
  _UserHomeState createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> with TickerProviderStateMixin {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    return StreamProvider<List<Item>>.value(
        value: DataBaseService().items,
        child: Scaffold(

          body: NestedScrollView(
            headerSliverBuilder: (context, isInnerBoxScroll) {
              return [
                RoundedFloatingAppBar(
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    new Search()));
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.person_outline),
                      onPressed: ()async {
                        final FirebaseMessaging _fcm=FirebaseMessaging();
                        String fcmToken = await _fcm.getToken();
                        var tokens = Firestore.instance
                            .collection('User Role')
                            .document(user.email)
                            .collection('tokens')
                            .document(fcmToken);
                        tokens.delete();
                        _auth.SignOut();
                      },
                    ),
                  ],
                  iconTheme: IconThemeData(
                    color: Colors.black,
                  ),
                  textTheme: TextTheme(
                    title: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  floating: true,
                  snap: true,
                  title: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          "Toni Store",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: Colors.white,
                ),
              ];
            },
            body:ItemListUser(),
          ),
          drawer: GestureDetector(
            child: Drawer(
              child: ListView(
                children: <Widget>[
                  new UserAccountsDrawerHeader(
                    accountName: Text(user.uid),
                    accountEmail: Text(user.email),
                    currentAccountPicture: new CircleAvatar(
                      backgroundImage:
                          NetworkImage('https://picsum.photos/250?image=9'),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.home),
                    title: Text('Home'),
                    onTap: () {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (BuildContext context) =>
                            new UserHome()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.favorite_border),
                    title: Text('Wish List'),
                    onTap: () {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (BuildContext context) =>
                            new WishList()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.vertical_align_top),
                    title: Text('Best Seller'),
                    onTap: () {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (BuildContext context) =>
                                new SellerPage()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.shopping_cart),
                    title: Text('Cart'),
                    onTap: () {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (BuildContext context) =>
                            new CardList()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.playlist_add),
                    title: Text('Request Box'),
                    onTap: () {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (BuildContext context) =>
                                new RequestBox()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.info),
                    title: Text('About'),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
