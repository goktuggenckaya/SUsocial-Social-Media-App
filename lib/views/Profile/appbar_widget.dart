import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs310group1/services/auth.dart';
import 'package:cs310group1/utils/colors.dart';
import 'package:cs310group1/views/Profile/edit_profile_page.dart';
import 'package:cs310group1/views/login/deleteaccount.dart';
import 'package:cs310group1/views/login/login_with_authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//just a widget for the profile page's app bar
AppBar buildAppBar(BuildContext context,analytics,observer) {
  AuthService auth = AuthService();
  return AppBar(
    leading: IconButton(
      onPressed: () {
        auth.signOut();
      },
      icon: Icon(Icons.logout),
    ),
    backgroundColor: AppColors.W_appBarBackground,
    elevation: 10,
    actions: [
      TextButton(
          onPressed:
          () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DeleteScreen(analytics: analytics, observer: observer),
                ));
          },
          child: Text("Delete Account")
      ),
      TextButton(onPressed: () {
        dynamic userid = FirebaseAuth.instance.currentUser?.uid;
        FirebaseFirestore.instance.collection('users').doc(userid).update({'disabled': true });
        FirebaseFirestore.instance
            .collection('users')
            .get()
            .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            if (doc["following"].contains(userid)){
              dynamic fl = doc["following"];
              fl.remove(userid);
              FirebaseFirestore.instance.collection('users').doc(doc.id).update({'following': fl });
            }
            if (doc["followers"].contains(userid)){
              dynamic fl2 = doc["followers"];
              fl2..remove(userid);
              FirebaseFirestore.instance.collection('users').doc(doc.id).update({'followers': fl2 });
            }
            auth.signOut();
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginScreen(analytics: analytics, observer: observer),
                ));
          });
        });
      }, child: Text("Disable Account")),

    ],

  );




}