import 'package:cs310group1/views/FeedView/user_object.dart';
import 'package:cs310group1/views/searchExplore/user_object.dart';
import 'package:cs310group1/views/searchExplore/user_tile.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cs310group1/services/user_database.dart';

class UsersList extends StatefulWidget {
  final String query;
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  const UsersList({
    Key? key,
    required this.query,
    required this.analytics,
    required this.observer
  }) : super(key: key);

  @override
  _UsersListState createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {

  @override
  Widget build(BuildContext context) {
    final users = Provider.of<List<Users>?>(context);
    String queryString = widget.query;

    if(users?.length == null) {
      return Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Sorry, we could not find the user ($queryString) you are searching:('),
            ],
          )
      );
    }
    else {
      return ListView.builder(
        itemCount: users?.length,
        itemBuilder: (context, index) {
          String? username = users?[index].username;
          String? name = users?[index].name;
          if(name!.toLowerCase().contains(widget.query.toLowerCase()) || username!.toLowerCase().contains(widget.query.toLowerCase())) {
            return UserTile(user_item: users![index], analytics: widget.analytics, observer: widget.observer);
          }
          else {
            return SizedBox(height: 1);
          }
        },
      );
    }
  }
}