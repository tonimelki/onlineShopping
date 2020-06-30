import 'package:crewbrew/models/Role.dart';
import 'package:crewbrew/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:crewbrew/models/user.dart';
class AuthService{

//give instance  access to all sign in method
  final FirebaseAuth _auth=FirebaseAuth.instance;
// sign in anon
// get the uid
  User _userFromDataBaseUser(FirebaseUser user){
    return user !=null?User(uid: user.uid,email: user.email):null;
  }
  //this is to stream(send) data when user change the auth (login/out) and turn it to map for my user class by call the method(return data or null)
  Stream<User>get user{
return _auth.onAuthStateChanged.map(_userFromDataBaseUser);
//_auth.onAuthStateChanged.map(FireBaseUser user)=>(_userFromDataBaseUser(user));
  }

  //get the user who login anon and turn it to our user in my class
Future SignInAnon() async{
  try{
  AuthResult result=  await _auth.signInAnonymously();
  FirebaseUser user=result.user;
  return _userFromDataBaseUser(user);

  }catch(e){
print(e.toString());
return null;
  }

}
Future SignOut()async{
    try{
      //this method i database return null to notify the Stream to logout
      return await _auth.signOut();
    }catch(e){
print(e.toString());
return null;
    }
}
//register with email and password
Future registerWithEmailAndPassword(String email,String password,String location)async{
    try{
      AuthResult result=await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user=result.user;
    DataBaseService().addRole(user.uid, "user",location,user.email);
    DataBaseService().addToken();
    DataBaseService().addFavorite();
    DataBaseService().addCart();
      //create a data for the user with this specific id who get it when registered
//await DataBaseService(uid: user.uid).additem('0', 'new crew member', 1);
      //to make him a user in the app and directly let him in
      return _userFromDataBaseUser(user);

    }catch(e){
print(e.toString());
return null;
    }
}

  Future signInWithEmailAndPassword(String email,String password)async{
    try{
      AuthResult result=await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user=result.user;
      return _userFromDataBaseUser(user);

    }catch(e){
      print(e.toString());
      return null;
    }
  }
}