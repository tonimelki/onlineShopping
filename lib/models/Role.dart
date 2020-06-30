import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crewbrew/models/user.dart';
import 'package:provider/provider.dart';

class Role{
  final String userId;
  String email;
  String role;
  String location;
  Role({this.role,this.location,this.userId,this.email});

  final CollectionReference RoleCollection =Firestore.instance.collection('Role');
  List<Role> _roleFromSnapshot(QuerySnapshot snapshot){
    //we return a list from all the document we have using the snapshot we receive then we convert it to map of lists and put it in the class Brew to use it
    return snapshot.documents.map((doc){
      return Role(
        email: doc.data['email']??'',
        role: doc.data['role'] ?? '',
        location: doc.data['location'] ?? '',
      );
    }).toList();
  }

  Stream<List<Role>> get info{
    //we convert the snapshot we have to map and run the method to convert it to list
    return RoleCollection.where('email',isEqualTo: email).snapshots().map(_roleFromSnapshot);
  }



}