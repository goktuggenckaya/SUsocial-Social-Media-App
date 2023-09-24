import 'package:cs310group1/views/Profile/following.dart';
import 'package:cs310group1/views/Profile/pending_followers.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';

import 'followers.dart';


class NumbersWidget extends StatelessWidget {
  final String uid;
  var follower_count_int;
  var following_count_int;
  var pendingfollowers_count_int;
  var private;
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  NumbersWidget ({ Key? key, required this.uid, required this.follower_count_int , required this.following_count_int, required this.pendingfollowers_count_int, required this.private,  required this.analytics, required this.observer  }): super(key: key);
  @override
  Widget build(BuildContext context) => IntrinsicHeight(

    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        buildButton(context, following_count_int.toString(), 'Following', uid),
        buildDivider(),
        buildButton(context, follower_count_int.toString(), 'Followers', uid),
        buildDivider(),
        private == true ? buildButton(context, pendingfollowers_count_int.toString(), 'Pending Followers', uid) : Container(),
      ],
    ),
  );
  Widget buildDivider() => Container(
    height: 24,
    child: VerticalDivider(),
  );

  Widget buildButton(BuildContext context, String value, String text, uid) =>
      MaterialButton(
        padding: EdgeInsets.symmetric(vertical:4),
        onPressed: (){
          print(value);
          if(value != "0" && text == "Following"){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FollowingPage(uid: uid, analytics: analytics, observer: observer),
              )
            );
          }
          else if(value != "0" && text == "Followers") {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FollowersPage(uid: uid, analytics: analytics, observer: observer),
                )
            );
          }
          else if(value != "0" && text == "Pending Followers") {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PendingFollowersPage(uid: uid, analytics: analytics, observer: observer),
                )
            );
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize. min,
          children: <Widget>[
            Text(
              value,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24 )
            ),
            SizedBox(height: 2),
            Text(
                text,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12 )
            ),
          ],
        ),
      );
}
