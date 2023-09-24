import 'package:cs310group1/services/user_database.dart';
import 'package:cs310group1/views/FeedView/user_object.dart';
import 'package:cs310group1/views/Profile/pending_folowers_list.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PendingFollowersPage extends StatefulWidget {
  final String uid;
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  const PendingFollowersPage({
    Key? key,
    required this.uid,
    required this.analytics,
    required this.observer
  }) : super(key: key);

  @override
  _PendingFollowersPageState createState() => _PendingFollowersPageState();
}

class _PendingFollowersPageState extends State<PendingFollowersPage> {

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Users>?>.value(
      catchError:(BuildContext context, e) { print("Error: $e"); return ; }, // VIDEODA YOK EKLE
      value: UsersData(widget.uid).users,
      initialData: null,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Pending Followers'),
        ),
        body: PendingFollowersList(uid: widget.uid, observer: widget.observer, analytics: widget.analytics),
      ),
    );
  }
}