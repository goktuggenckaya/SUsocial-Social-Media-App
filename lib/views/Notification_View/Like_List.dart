import 'package:cs310group1/views/FeedView/comment_object.dart';
import 'package:flutter/material.dart';
import 'package:cs310group1/utils/colors.dart';
import 'package:cs310group1/utils/dimensions.dart';
import 'package:cs310group1/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:cs310group1/views/Notification_View/Notification_View.dart';
import 'package:cs310group1/views/Notification_View/Notification_Card.dart';
import 'package:cs310group1/views/FeedView/post_object.dart';
import 'package:cs310group1/views/Notification_View/Like_Card.dart';
import 'package:firebase_auth/firebase_auth.dart';




class LikeList extends StatefulWidget {
  @override
  _LikeListState createState() => _LikeListState();
}

class _LikeListState extends State<LikeList> {
  final user = FirebaseAuth.instance.currentUser?.uid;
  @override
  Widget build(BuildContext context) {
    final posts = Provider.of<List<Post>?>(context);
    for(var i = 0; i <posts!.length; i++){
      if(user == posts[i].user_id) {
        var likes = posts[i].like_id;
        return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: likes?.length,
            itemBuilder: (context, index) {
              return LikeCard(like_id: likes?[index]);
            }
          //separatorBuilder: (BuildContext context, int index) => const Divider(),
        );
      }
      else {
        return SizedBox(height: 1);
      }
    }
    return SizedBox(height: 1);
  }
}