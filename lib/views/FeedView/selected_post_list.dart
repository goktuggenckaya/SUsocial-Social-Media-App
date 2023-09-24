//import 'package:cs310group1/model/user_object.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cs310group1/views/FeedView/post_object.dart';
import 'package:cs310group1/widgets/search_app_bar.dart';
import 'package:cs310group1/views/FeedView/post_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:cs310group1/model/users.dart';

class SelectedPostsList extends StatefulWidget {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  final String query;

  const SelectedPostsList({
    Key? key,
    required this.query,
    required this.analytics, required this.observer
  }) : super(key: key);

  @override
  _SelectedPostsListState createState() => _SelectedPostsListState();
}

class _SelectedPostsListState extends State<SelectedPostsList> {
  @override
  Widget build(BuildContext context){
    final posts = Provider.of<List<Post>?>(context);

    //USER ID YE GORE TAKIP EDİLENLERIN POSTLARINI AYIKLA
    //posts?.forEach((post) {
      //print(post.post_id);
      //print(post.user_id);
      //print('debug');
    //});
/*
    print('users length:');
    print(users?.length);

    users?.forEach((user) {
      print(user.username);
    });
*/
    if(posts?.length == null) {
      return Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('Sorry, we could not find a match to your interest :('),
          ],
        )
      );
    }
    else {
      return ListView.builder(
        itemCount: posts?.length,
        itemBuilder: (context, index) {
          /*String? username = '';
          users?.forEach((user) {
          print('post user id');
          print(posts?[index].user_id);
          print('user id');
          print(user.user_id);
          if(posts?[index].user_id == user.user_id){
            username = user.username;
            print(username);
          }
        });*/
          String? caption = posts?[index].caption;
          if(caption!.toLowerCase().contains(widget.query.toLowerCase())  /*posts?[index].caption == SearchAppBar.query*/ /* || username == SearchAppBar.query*/) {
            return PostTile(post_item: posts![index], analytics: widget.analytics, observer: widget.observer );
          }
          else {
            return SizedBox(height: 1);
          }
        },
      );
    }

    return Container(
    );
  }
}