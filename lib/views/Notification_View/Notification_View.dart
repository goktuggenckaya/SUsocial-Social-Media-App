// ignore: file_names
// ignore_for_file: file_names

import 'package:cs310group1/services/auth.dart';
import 'package:cs310group1/services/user_database.dart';
import 'package:cs310group1/views/FeedView/comment_object.dart';
import 'package:cs310group1/views/FeedView/user_object.dart';
import 'package:cs310group1/views/Notification_View/Like_List.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cs310group1/utils/colors.dart';
import 'package:cs310group1/utils/dimensions.dart';
import 'package:cs310group1/utils/styles.dart';
import 'package:cs310group1/services/comment_database.dart';
import 'package:provider/provider.dart';
import 'Notification_List.dart';
import 'package:cs310group1/services/post_database.dart';
import 'package:cs310group1/views/FeedView/post_object.dart';



class NotificationView extends StatefulWidget {
  static const routeName = "/notification_view";
  @override
  _NotificationViewState createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView>{
  final _formKey = GlobalKey<FormState>();



  AuthService auth=AuthService();
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Notifications"),
        backgroundColor: AppColors.W_appBarBackground,
        leading: IconButton(
          onPressed: () {
            auth.signOut();
          },
          icon: Icon(Icons.logout),
        ),
      ),
      backgroundColor: const Color(0xdbcdb9),
      body: MultiProvider(
        providers: [
          StreamProvider<List<Comment>?>.value(
              catchError: (BuildContext context, e) {
                print("Error: $e");
              }, // VIDEODA YOK EKLE
              value: CommentsData().comments,
              initialData: null,
              child: NotifList()
          ),
          StreamProvider<List<Post>?>.value(
            catchError: (BuildContext context, e) {
              print("Error: $e");
            }, // VIDEODA YOK EKLE
            value: PostsData().posts,
            initialData: null,
            child: LikeList(),
          ),
          StreamProvider<List<Users>?>.value(
            catchError: (BuildContext context, e) {
              print("Error: $e");
            }, // VIDEODA YOK EKLE
            value: UsersData(FirebaseAuth.instance.currentUser?.uid).users,
            initialData: null,
            child: LikeList(),
          )
        ],
        child: Scaffold(
          body: NotifList()
        ),
      )
      /*Column(
        children:[
          StreamProvider<List<Comment>?>.value(
            catchError: (BuildContext context, e) {
              print("Error: $e");
            }, // VIDEODA YOK EKLE
            value: CommentsData().comments,
            initialData: null,
            child: NotifList(),
          ),
          StreamProvider<List<Post>?>.value(
            catchError: (BuildContext context, e) {
              print("Error: $e");
            }, // VIDEODA YOK EKLE
            value: PostsData().posts,
            initialData: null,
            child: LikeList(),
          )
        ]
      ),*/
    );
  }

}


/*Widget build(BuildContext context){
  return StreamProvider<List<Comment>?>.value(
    catchError:(BuildContext context, e) { print("Error: $e"); return ; }, // VIDEODA YOK EKLE
    value: CommentsData().comments,
    initialData: null,
    child: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Notifications"),
        backgroundColor: AppColors.W_appBarBackground,
      ),
      backgroundColor: const Color(0xdbcdb9),
      body:
      NotifList(),
    ),
  );
}*/