import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs310group1/views/FeedView/user_object.dart';
import 'package:cs310group1/views/Profile/pending_followers_user_tile.dart';
import 'package:cs310group1/views/searchExplore/user_object.dart';
import 'package:cs310group1/views/searchExplore/user_tile.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cs310group1/services/user_database.dart';

class PendingFollowersList extends StatefulWidget {
  final String uid;
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  const PendingFollowersList({
    Key? key,
    required this.uid,
    required this.analytics,
    required this.observer
  }) : super(key: key);

  @override
  _PendingFollowersListState createState() => _PendingFollowersListState();
}

class _PendingFollowersListState extends State<PendingFollowersList> {

  @override
  Widget build(BuildContext context){
    final users = Provider.of<List<Users>?>(context);

    dynamic userid = widget.uid;

    bool match(int index, List<dynamic> followingList) {
      for(int i = 0; i < followingList.length; i++) {
        if(followingList[i] == users![index].user_id) {
          return true;
        }
      }
      return false;
    }

    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').doc(userid).snapshots(),
        builder: (context, snapshot) {
          return ListView.builder(
              itemCount: users!.length,
              itemBuilder: (context, index) {
                if(snapshot.hasData) {
                  var userDocument = snapshot.data as DocumentSnapshot;
                  List<dynamic> followinglist;
                  userDocument != null
                      ? followinglist = userDocument["pendingfollowers"]
                      : followinglist = [];
                  if (match(index, followinglist)) {
                    return PendingUserTile(user_item: users[index],
                        analytics: widget.analytics,
                        observer: widget.observer);
                  }

                  else {
                    return SizedBox(height: 0,);
                  }

                }
                else{
                  return SizedBox(height: 0,);
                }
              }
          );
        }
    );
  }
}