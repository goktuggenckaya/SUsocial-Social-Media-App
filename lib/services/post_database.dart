import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs310group1/views/FeedView/post_object.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PostsData {

  final String? uid = FirebaseAuth.instance.currentUser?.uid;
  PostsData();

  // collection reference
  final CollectionReference postsCollection = FirebaseFirestore.instance.collection('posts');

  Future<void> addPost(comments,image_link,like_id,caption,date,reshared_by) {
    // Call the user's CollectionReference to add a new user
    return postsCollection
        .add({
      'user_id': uid, // John Doe
      'comments': comments, // Stokes and Sons
      'image_link': image_link, // 42
      'like_id' : like_id,
      'caption' : caption,
      'date':date,
      'reshared_by':reshared_by,
    })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> resharePost(post_user_id,comments,image_link,like_id,caption,date) {
    // Call the user's CollectionReference to add a new user
    return postsCollection
        .add({
      'user_id': post_user_id, // John Doe
      'comments': comments, // Stokes and Sons
      'image_link': image_link, // 42
      'like_id' : like_id,
      'caption' : caption,
      'date':date,
      'reshared_by': uid,
    })
        .then((value) => print("Reshare post Added"))
        .catchError((error) => print("Failed to add reshared post: $error"));
  }


  // brew list from snapshot
  List<Post> _postListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc){
      return Post(doc.id ?? '', doc["like_id"] ?? [], doc['image_link'] ?? '', doc['comments'] ?? [] ,doc['user_id'] ?? '',doc['caption'] ?? '',doc['date'] ?? '', doc['reshared_by'] ?? ''
      );
    }).toList();
  }

  Stream<List<Post>> get posts {
    return postsCollection.snapshots().map(_postListFromSnapshot);
  }

}
