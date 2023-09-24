import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs310group1/views/FeedView/post_object.dart';
import 'package:cs310group1/model/user_object.dart';


//whole file  is not necessary when we fetch user data from firestore, did it just for trying purposes


class Userz {
  final String id;
  final String username;
  final String imagePath;
  final String name;
  final String email;
  final String about;

  const Userz ({
    required this.id,
    required this.username,
    required this.imagePath,
    required this.name,
    required this.email,
    required this.about,
  });

  factory Userz.fromDocument(DocumentSnapshot doc) {
    return Userz(
      id: doc['id'],
      username: doc['username'],
      email: doc['email'],
      imagePath: doc['photoUrl'],
      name: doc['displayName'],
      about: doc['bio'],
    );
  }
}

/*
class UsersData {


  // collection reference
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

  // brew list from snapshot
  List<Userss> _usersListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc){
      return Userss(
          user_id: doc.id ?? '',
          about: doc["about"] ?? '',
          email: doc['email'] ?? '',
          image_path: doc['image_path'] ?? '',
          name: doc['name'] ?? '',
          username: doc['username'] ?? ''
      );
    }).toList();
  }

  Stream<List<Userss>> get users {
    return usersCollection.snapshots().map(_usersListFromSnapshot);
  }

}
*/
