import 'dart:io';

class ADMobService {
String  getAdMobAppId(){
  if(Platform.isIOS){
    return 'ca-app-pub-5999841258141003~5706768111';
  }else if(Platform.isAndroid){
    return 'ca-app-pub-5999841258141003~8293403007';
  }
  return null;
}
String getBannerId(){
  if(Platform.isIOS){
    return 'ca-app-pub-5999841258141003/4848982010';
  }else if(Platform.isAndroid){
    return 'ca-app-pub-5999841258141003/6023490552';
  }
  return null;
}
String getInterId(){
  if(Platform.isIOS){
    return 'ca-app-pub-5999841258141003/3717795379';
  }else if(Platform.isAndroid){
    return 'ca-app-pub-5999841258141003/7665365971';
  }
  return null;
}
}