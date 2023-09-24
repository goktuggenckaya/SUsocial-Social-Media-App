import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cs310group1/views/FeedView/post_object.dart';
import 'package:cs310group1/views/FeedView/post_tile.dart';
import 'package:cs310group1/views/FeedView/post_object.dart';

class PostsList extends StatefulWidget {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  const PostsList({Key? key, required this.analytics, required this.observer}) : super(key: key);
  @override
  _PostsListState createState() => _PostsListState();
}

class _PostsListState extends State<PostsList> {
  @override
  Widget build(BuildContext context){
    final posts = Provider.of<List<Post>?>(context);
    //USER ID YE GORE TAKIP EDİLENLERIN POSTLARINI AYIKLA


    if(posts !=null){
    posts.forEach((post) {
    });

    dynamic userid = FirebaseAuth.instance.currentUser?.uid;

    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('users').doc(userid).snapshots(),
      builder: (context, snapshot) {
        return ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            if(snapshot.hasData) {
              var userDocument = snapshot.data as DocumentSnapshot;
              dynamic followinglist;
              userDocument != null
                  ? followinglist = userDocument["following"]
                  : followinglist = [];
              if (posts.length != 0 && followinglist != null &&
                  (followinglist.contains(posts[index].user_id) || followinglist.contains(posts[index].reshared_by) || userid == posts[index].user_id )) {
                return PostTile(post_item: posts[index],
                    analytics: widget.analytics,
                    observer: widget.observer);
              }

              else {
                Post post_item = Post("",[],"",[],"","","","");
                return PostTile(post_item: post_item,analytics: widget.analytics, observer:widget.observer);
              }

            }
            else{
              Post post_item = Post("",[],"",[],"","","","");
              return PostTile(post_item: post_item,analytics: widget.analytics, observer:widget.observer);
              }
            }
        );
      }
    );
    }

    return Container(
    );
  }
}