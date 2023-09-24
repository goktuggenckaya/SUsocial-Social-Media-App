import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs310group1/views/FeedView/comment_object.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class CommentsData {

  final String? uid;
  final String? post_id;
  final String? user_name;
  final String? owner_id;
  final dynamic date;
  CommentsData({ this.uid, this.post_id, this.user_name, this.owner_id, this.date});

  // collection reference
  final CollectionReference commentsCollection = FirebaseFirestore.instance.collection('comments');

  Future<void> addComment(comment) {
    // Call the user's CollectionReference to add a new user
    return commentsCollection
        .add({
      'user_id': uid, // John Doe
      'post_id': post_id, // Stokes and Sons
      'comment': comment, // 42
      'username': user_name,
      "date":date,
      "owner_id": owner_id
      //ADD USERNAME
    })
        .then((value) => print("Comment Added"))
        .catchError((error) => print("Failed to add comment: $error"));
  }

  List<Comment> _commentsListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc){
      return Comment(
          comment_id: doc.id ?? '',
          post_id: doc["post_id"] ?? '',
          comment: doc['comment'] ?? '',
          user_id: doc['user_id'] ?? '',
          username: doc['username'] ?? '',
          date:doc['date'] ?? '',
          owner_id: doc['owner_id'] ?? ''
        //ADD USERNAME
      );
    }).toList();
  }

  Stream<List<Comment>> get comments {
    return commentsCollection.snapshots().map(_commentsListFromSnapshot);
  }

}