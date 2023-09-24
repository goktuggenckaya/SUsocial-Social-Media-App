import 'package:cs310group1/services/user_database.dart';
import 'package:cs310group1/views/FeedView/user_object.dart';
import 'package:cs310group1/views/Profile/following_list.dart';
import 'package:cs310group1/views/Profile/numbers_widget.dart';
import 'package:cs310group1/views/searchExplore/users_list.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FollowingPage extends StatefulWidget {
  final String uid;
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  const FollowingPage({
    Key? key,
    required this.uid,
    required this.analytics,
    required this.observer
  }) : super(key: key);

  @override
  _FollowingPageState createState() => _FollowingPageState();
}

class _FollowingPageState extends State<FollowingPage> {

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Users>?>.value(
      catchError:(BuildContext context, e) { print("Error: $e"); return ; }, // VIDEODA YOK EKLE
      value: UsersData(widget.uid).users,
      initialData: null,
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('Following'),
          ),
        body: FollowingList(uid: widget.uid, observer: widget.observer, analytics: widget.analytics),
      ),
    );
  }
}
