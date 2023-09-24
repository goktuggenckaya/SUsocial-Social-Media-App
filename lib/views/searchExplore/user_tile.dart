import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs310group1/views/FeedView/user_object.dart';
import 'package:cs310group1/views/Profile/user_profile.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:cs310group1/views/searchExplore/user_object.dart';

class UserTile extends StatefulWidget {
  Users? user_item;
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  UserTile({
    Key? key,
    required this.user_item,
    required this.analytics,
    required this.observer
  }) : super(key: key);

  @override
  _UserTileState createState() => _UserTileState();
}

class _UserTileState extends State<UserTile> {
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
                                      builder: (context) => UserProfilePage(user_id: streamSnapshot.data?.docs[index].id, private: streamSnapshot.data?.docs[index]["private"], followerlist: streamSnapshot.data?.docs[index]["followers"] , analytics: widget.analytics, observer: widget.observer),
                                    ))
                              },
                            ),
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