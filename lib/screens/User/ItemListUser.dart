import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:crewbrew/models/BestSeller.dart';
import 'package:crewbrew/models/Item.dart';
import 'package:crewbrew/screens/User/BestList.dart';
import 'package:crewbrew/screens/User/CardList.dart';
import 'package:crewbrew/screens/User/ItemDetails.dart';
import 'package:crewbrew/screens/User/Order.dart';
import 'package:crewbrew/screens/User/RequestBox.dart';
import 'package:crewbrew/screens/User/SellerPage.dart';
import 'package:crewbrew/screens/User/TopItems.dart';
import 'package:crewbrew/screens/User/WishList.dart';
import 'package:crewbrew/screens/User/userHome.dart';
import 'package:crewbrew/screens/home/item_tile.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:provider/provider.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:crewbrew/services/admob-service.dart';
import 'dart:io';
final ams=ADMobService();
String testDevice = '08E478475FD7CB2086482A00AE3863BB';
class ItemListUser extends StatefulWidget {
  @override
  _ItemListUserState createState() => _ItemListUserState();
}

class _ItemListUserState extends State<ItemListUser> with TickerProviderStateMixin{

  AnimationController controller;
  static MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
//    testDevices: testDevice != null ? <String>[testDevice] : null,
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    childDirected: true,
    nonPersonalizedAds: true,
  );
  BannerAd _bannerAd;
  BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: ams.getBannerId(),
      size: AdSize.smartBanner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("BannerAd event $event");
      },
    );
  }


  @override
  void initState() {
    // TODO: implement setState

    FirebaseAdMob.instance.initialize(appId: ams.getAdMobAppId());
//    _bannerAd = createBannerAd()..load()..show(
//      anchorOffset: 0.0,
//      // Positions the banner ad 10 pixels from the center of the screen to the right
//      horizontalCenterOffset: 0.0,
//      // Banner Position
//      anchorType: AnchorType.bottom,);
    controller=AnimationController(vsync: this,duration:Duration(seconds: 4));
    //Admob.initialize(ams.getAdMobAppId());
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller?.dispose();
    _bannerAd.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final data=MediaQuery.of(context);
    final item=Provider.of<List<Item>>(context);
    // print(brews.documents);
    //print out all the documents(data) in the brews collection
    try {
      return Center(
        child: Column(
          children: <Widget>[
            Container(
              child: Column(
                children:<Widget>[
                  CarouselSlider(
                  height: 200.0,
                  autoPlay: true,
                  items: item.map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: BoxDecoration(
                                color: Colors.amber
                            ),
                            child:InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) => ItemDetails(
                                      item: i,
                                    )));
                              },
                              child: CachedNetworkImage(
                                imageUrl: i.image,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                placeholder: (context, url) => CircularProgressIndicator(),
                                errorWidget: (context, url, error) => Icon(Icons.error),
                              ),
                            ),
                        );
                      },
                    );
                  }).toList(),
                ),
                 Container(
                   height:60,
                   width: 500,
                   color: Colors.white70,
                   child:Row(
                     textDirection: TextDirection.ltr,
                     crossAxisAlignment:CrossAxisAlignment.start ,
                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                     mainAxisSize: MainAxisSize.min,
                     children: <Widget>[
                       Container(
                         child:
                         InkWell(
                           child: Column(children:<Widget>[
                             Icon(Icons.credit_card,size: 48,color: Colors.blueAccent,),
                             Text('Cart List',style: TextStyle(fontSize: 10),),

                           ]),
                           onTap: (){
                             controller.forward();
                             Navigator.of(context).push(
                                 MaterialPageRoute(builder: (context) => CardList()));
                           },
                         ),
                       ),
                       Container(
                         child:
                         InkWell(
                           child: Column(children:<Widget>[
                             Icon(Icons.favorite,size: 48,color: Colors.blueAccent,),
                             Text('Wish List',style: TextStyle(fontSize: 10),),

                           ]),
                           onTap: (){
                             controller.forward();
                             Navigator.of(context).push(

                                 MaterialPageRoute(builder: (context) => WishList()));
                           },
                         ),
                       ),
                       Container(
                         child:
                         InkWell(
                           child: Column(children:<Widget>[
                             Icon(Icons.trending_up,size: 48,color: Colors.blueAccent,),
                             Text('Best Seller',style: TextStyle(fontSize: 10),),

                           ]),
                           onTap: (){
                             Navigator.of(context).push(
                                 MaterialPageRoute(builder: (context) => SellerPage()));
                           },
                         ),
                       ),
                       Container(
                         child:
                         InkWell(
                           child: Column(children:<Widget>[
                             Icon(Icons.laptop_windows,size: 48,color: Colors.blueAccent,),
                             Text('Request',style: TextStyle(fontSize: 10),),

                           ]),
                           onTap: (){
                             Navigator.of(context).push(
                                 MaterialPageRoute(builder: (context) => RequestBox()));
                           },
                         ),
                       ),
                     ],
                   ),
                 ),

               ]
              )
            ),
//            Container(
//              width: MediaQuery.of(context).size.width,
//              child: AdmobBanner(
//                adUnitId: ams.getBannerId(),
//                adSize: AdmobBannerSize.FULL_BANNER,
//              ),
//            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(data.size.height/100*1),
                child: GridView.count(
                  crossAxisCount: 2,
                  children: List.generate(item.length, (index) {
                    return Order(item: item[index],);
                  }),
                ),
              ),
            )
    ],
        ),
      );
    }catch(e){
      print('No Items Found');
    }
    return Container(width: 0.0,height: 0.0,);
  }
  }

