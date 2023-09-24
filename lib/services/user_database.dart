import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs310group1/views/FeedView/post_object.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cs310group1/views/searchExplore/user_object.dart';
import 'package:cs310group1/views/FeedView/user_object.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class UsersData {

  final String? uid = FirebaseAuth.instance.currentUser?.uid;
  final String? userid;
  UsersData(this.userid);

  // collection reference
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

  Future<void> addUser(about,email,followers,following,image_path,name,username,pendingfollowers,private, disabled) {
    // Call the user's CollectionReference to add a new user
    return usersCollection.doc(userid).set({
      'about': about, // John Doe
      'email': email, // Stokes and Sons
      'followers': followers, // 42
      'following' : following,
      'image_path' : image_path,
      'name':name,
      'username':username,
      'pendingfollowers':pendingfollowers,
      'private': private,
      'disabled': disabled,
    })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  // brew list from snapshot
  List<Users> _userListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc){
      return Users(doc.id??'',doc["about"]??"",doc["email"]??"",doc["followers"]??[],doc["following"]??[],doc["image_path"]??"",doc["name"]??"",doc["username"]??""
          ,doc["pendingfollowers"]??"", doc["private"]??false, doc["disabled"]??false);

    }).toList();
  }

  Stream<List<Users>> get users {
    return usersCollection.snapshots().map(_userListFromSnapshot);
  }

}