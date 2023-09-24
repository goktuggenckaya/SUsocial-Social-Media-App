import 'package:cs310group1/views/login/login_with_authentication.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:cs310group1/utils/colors.dart';
import 'package:cs310group1/utils/dimensions.dart';
import 'package:cs310group1/utils/styles.dart';
import 'package:provider/provider.dart';
import 'package:cs310group1/services/post_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs310group1/views/FeedView/posts_list.dart';
import 'package:cs310group1/views/FeedView/post_object.dart';
import 'package:cs310group1/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';


class FeedPage extends StatefulWidget {
  static const routeName = "/feedview";
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  const FeedPage({Key? key, required this.analytics, required this.observer}) : super(key: key);
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage>{
  AuthService auth=AuthService();
  @override
  Widget build(BuildContext context){
    return StreamProvider<List<Post>?>.value(
      catchError:(BuildContext context, e) { print("Error: $e"); return ; }, // VIDEODA YOK EKLE
      value: PostsData().posts,
      initialData: null,
      child: Scaffold(
        backgroundColor: const Color(0xDBCDB9),
        body:PostsList(observer:widget.observer, analytics: widget.analytics,),
        appBar: AppBar(
          centerTitle: true,
          title: Text('SuSocial'),
          backgroundColor: AppColors.W_appBarBackground,
          leading: IconButton(
            onPressed: () {
              auth.signOut();
            },
            icon: Icon(Icons.logout),
          ),

        ),
      ),
    );
  }
}
