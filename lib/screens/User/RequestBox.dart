import 'package:crewbrew/models/Request.dart';
import 'package:crewbrew/models/user.dart';
import 'package:crewbrew/services/admob-service.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class RequestBox extends StatefulWidget {
  @override
  _RequestBoxState createState() => _RequestBoxState();
}
final ams=ADMobService();
String testDevice = '08E478475FD7CB2086482A00AE3863BB';
class _RequestBoxState extends State<RequestBox> {
  static MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
  // testDevices: testDevice != null ? <String>[testDevice] : null,
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    childDirected: true,
    nonPersonalizedAds: true,
  );
  InterstitialAd _interstitialAd;
  InterstitialAd myInterstitial = InterstitialAd(
    // Replace the testAdUnitId with an ad unit id from the AdMob dash.
    // https://developers.google.com/admob/android/test-ads
    // https://developers.google.com/admob/ios/test-ads
    adUnitId: ams.getInterId(),
    targetingInfo: targetingInfo,
    listener: (MobileAdEvent event) {
      print("InterstitialAd event is $event");
    },
  );
  bool _loaded = false;
  int _goldCoins;
  RewardedVideoAd rewardedVideoAd=RewardedVideoAd.instance;
  @override
  void initState() {
    super.initState();
    // TODO: implement setState

//    FirebaseAdMob.instance.initialize(appId: ams.getAdMobAppId());
//    myInterstitial
//      ..load()
//      ..show(
//        anchorType: AnchorType.bottom,
//        anchorOffset: 0.0,
//        horizontalCenterOffset: 0.0,
//      );
//    RewardedVideoAd.instance
//        .load(adUnitId: 'ca-app-pub-5999841258141003/7960663847', targetingInfo: targetingInfo)
//        .catchError((e) => print("error in loading 1st time"))
//        .then((v) => setState(() => _loaded = v));
//    RewardedVideoAd.instance.listener = (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
//      if (event == RewardedVideoAdEvent.closed) {
//        RewardedVideoAd.instance
//            .load(adUnitId: 'ca-app-pub-5999841258141003/7960663847', targetingInfo: targetingInfo)
//            .catchError((e) => print("error in loading again"))
//            .then((v) => setState(() => _loaded = v));
//      }
//    };

  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _interstitialAd.dispose();
  }
  Request requestBox=Request();
  String request;
  int quantity;
  @override
  Widget build(BuildContext context) {

    final user=Provider.of<User>(context);
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              height: 200,

//              decoration: BoxDecoration(
//                image: DecorationImage(
//                  image: AssetImage(''),
//                  fit: BoxFit.fill,
//                )
//              ),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    child: Container(
                      margin: EdgeInsets.only(top:10),
                      child: Center(
                        child: Text("Request Box",style: TextStyle(color: Colors.white,fontSize: 40,fontWeight: FontWeight.bold  ),),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(143, 148, 251, 3),
                          blurRadius: 20.0,
                          offset: Offset(0,10),
                        )
                      ]
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(color: Colors.grey[100]))
                          ),
                          child: TextFormField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Please Enter your Request or feedback here",
                              hintStyle: TextStyle(color: Colors.grey[400])
                            ),
                            onChanged: (val){
                              setState(() {
                                request=val;
                              });
                            },
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: Colors.grey[100]))
                          ),
                          child: TextFormField(
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Enter the quantity",
                                hintStyle: TextStyle(color: Colors.grey[400])
                            ),
                            onChanged: (val){
                              setState(() {
                                quantity=int.parse(val)??0;
                              });
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 30,),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        colors: [
                          Color.fromRGBO(143, 148, 251, 1),
                          Color.fromRGBO(143, 148, 251, 6)
                        ]
                      )
                    ),
                    child: RaisedButton.icon(
                      icon: Icon(Icons.rate_review),
                        label: Text("Submit"),
                        color: Color.fromRGBO(143, 148, 251, 1),
                        onPressed: (){
                        requestBox.addRequest(user.email, quantity, request);
                        Navigator.pop(context);
                        }

                    )
                  ),
                  IconButton(
                    icon: Icon(Icons.check),
                    onPressed: ()async{
                      await RewardedVideoAd.instance.show().catchError((e) => print("error in showing ad: ${e.toString()}"));
                      setState(() => _loaded = false);
                    },
                  ),

                ],
              ),
            )

          ],
        ),
      ),
    );
  }
}
