import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs310group1/views/FeedView/user_object.dart';
import 'package:cs310group1/views/Profile/user_profile.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cs310group1/views/searchExplore/user_object.dart';

class PendingUserTile extends StatefulWidget {
  Users? user_item;
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  PendingUserTile({
    Key? key,
    required this.user_item,
    required this.analytics,
    required this.observer
  }) : super(key: key);

  @override
  _PendingUserTileState createState() => _PendingUserTileState();
}

class _PendingUserTileState extends State<PendingUserTile> {

  Future accept() async{
    dynamic userid = FirebaseAuth.instance.currentUser?.uid;
    if(userid != null){
      if(widget.user_item!.following == null){
        widget.user_item!.following = [userid];
      }
      else{
        widget.user_item!.following!.add(userid);
      }
      FirebaseFirestore.instance.collection('users').doc(widget.user_item!.user_id).update({'following': widget.user_item!.following});

      FirebaseFirestore.instance
          .collection('users')
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          if (doc.id == userid){
            dynamic followerlist= doc["followers"];
            if(followerlist != null){
              followerlist.add(widget.user_item!.user_id);
            }
            else {
              followerlist = [widget.user_item!.user_id];
            }
            FirebaseFirestore.instance.collection('users').doc(userid).update({'followers': followerlist});
            dynamic pendingfollowerlist= doc["pendingfollowers"];
            if(pendingfollowerlist != null){
              pendingfollowerlist.remove(widget.user_item!.user_id);
            }
            FirebaseFirestore.instance.collection('users').doc(userid).update({'pendingfollowers': pendingfollowerlist});
          }
        });
      });
    }
  }

  Future decline() async{
    dynamic userid = FirebaseAuth.instance.currentUser?.uid;
    if(userid != null){

      FirebaseFirestore.instance
          .collection('users')
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          if (doc.id == userid){
            dynamic pendingfollowerlist= doc["pendingfollowers"];
            if(pendingfollowerlist != null){
              pendingfollowerlist.remove(widget.user_item!.user_id);
            }
            FirebaseFirestore.instance.collection('users').doc(userid).update({'pendingfollowers': pendingfollowerlist});
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: ListTile(
        title: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            return ListView.builder(
                shrinkWrap: true ,
                padding: EdgeInsets.fromLTRB(0.0, 3.0, 10.0, 0.0),
                itemCount: streamSnapshot.data != null ? streamSnapshot.data?.docs.length : 0,
                itemBuilder: (ctx, index) =>
                    Container(

                        child: (streamSnapshot.data != null && streamSnapshot.data?.docs[index].id == widget.user_item!.user_id)?
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  child: Text(
                                    streamSnapshot.data?.docs[index]['username'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  onTap: () => {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => UserProfilePage(user_id: streamSnapshot.data?.docs[index].id, private: streamSnapshot.data?.docs[index]["private"], followerlist: streamSnapshot.data?.docs[index]["followers"],  analytics: widget.analytics, observer: widget.observer),
                                        ))
                                  },
                                ),
                              ],
                            ),
                            Spacer(),
                            ElevatedButton(onPressed:accept, child: Text("Accept") ),
                            SizedBox(width:10),
                            ElevatedButton(onPressed:decline, child: Text("Decline"))
                          ],
                        ):
                        Container()
                    )
            );
          },
        ),
        leading: Column(
            children: [
              Container(
                margin:EdgeInsets.fromLTRB(5.0, 6.0, 0.0, 0.0),
                width: 50.0,
                height: 50.0,
                child:StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                    return ListView.builder(
                        shrinkWrap: true ,
                        itemCount: streamSnapshot.data != null ? streamSnapshot.data?.docs.length: 0,
                        itemBuilder: (ctx, index) =>
                            Container(

                                child: (streamSnapshot.data != null && streamSnapshot.data?.docs[index].id == widget.user_item!.user_id)?
                                CircleAvatar(backgroundImage: NetworkImage(streamSnapshot.data?.docs[index]['image_path'] ?? " "),
                                    radius:25.0):
                                Container()
                            )
                    );
                  },
                ) ,

              ),
            ]),
      ),
    );
  }
}