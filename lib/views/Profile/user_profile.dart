import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs310group1/views/FeedView/post_object.dart';
import 'package:cs310group1/views/FeedView/post_tile.dart';
import 'package:cs310group1/views/Profile/profile.dart';
import 'package:cs310group1/views/Profile/profile_widget.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'appbar_widget2.dart';
import 'numbers_widget_nonprofile.dart';

class UserProfilePage extends StatefulWidget {
  dynamic user_id;
  dynamic private;
  dynamic followerlist;
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  UserProfilePage({ Key? key, required this.user_id, required this.private,required this.followerlist,  required this.analytics, required this.observer }): super(key: key);
  static const routeName = "/userProfile";
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  @override
  void initState() {
    super.initState();
  }


  follow(currentuser,docid,followingid, pendingfollowers)async{
    if(widget.private == true){
      if(pendingfollowers == null){
        pendingfollowers = [currentuser];
      }
      else{
        pendingfollowers.add(currentuser);
      }
      FirebaseFirestore.instance.collection('users').doc(docid).update(
          {'pendingfollowers': pendingfollowers});
    }
    else {
      if (followingid == null) {
        followingid = [currentuser];
      }
      else {
        followingid.add(currentuser);
      }
      FirebaseFirestore.instance.collection('users').doc(docid).update(
          {'followers': followingid});

      FirebaseFirestore.instance
          .collection('users')
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          if (doc.id == currentuser) {
            dynamic followinglist = doc["following"];
            if (followinglist == null) {
              followinglist = [docid];
            }
            else {
              followinglist.add(docid);
            }
            FirebaseFirestore.instance.collection('users')
                .doc(currentuser)
                .update({'following': followinglist});
          }
        });
      });
    }
  }

  unfollow(currentuser,docid,followingid)async{
    followingid.remove(currentuser);
    FirebaseFirestore.instance.collection('users').doc(docid).update({'followers': followingid});

    FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (doc.id == currentuser){
          dynamic followinglist= doc["following"];
          if(followinglist != null){
            followinglist.remove(docid);
          }
          FirebaseFirestore.instance.collection('users').doc(currentuser).update({'following': followinglist});
          setState(() {
            widget.followerlist.remove(currentuser);
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var userid = widget.user_id;
    print(widget.followerlist);
    dynamic currentuserid = "";
    if(FirebaseAuth.instance.currentUser != null){
      currentuserid = FirebaseAuth.instance.currentUser?.uid;
    }
    if(currentuserid == widget.user_id){
      return ProfilePage(analytics: widget.analytics, observer: widget.observer);
    }
    return Scaffold(
      appBar:  buildAppBar2(context,widget.analytics, widget.observer, widget.user_id),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          SizedBox(height: 39),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              return ListView.builder(
                  shrinkWrap: true ,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: streamSnapshot.data != null ? streamSnapshot.data?.docs.length: 0,
                  itemBuilder: (ctx, index) =>
                      Container(
                        child: (streamSnapshot.data != null && streamSnapshot.data?.docs[index].id == userid)?
                        ProfileWidget(
                          imagePath: streamSnapshot.data?.docs[index]['image_path'] ?? "", //default profile page, static, not from firestore
                          onClicked: ()  {},
                          onClicked2: ()  {},
                        ):
                        Container(),
                      )
              );
            },
          ) ,
          const SizedBox(height: 24),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              return ListView.builder(
                  shrinkWrap: true ,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: streamSnapshot.data != null ? streamSnapshot.data?.docs.length: 0,
                  itemBuilder: (ctx, index) =>
                      Container(
                        child: (streamSnapshot.data != null && streamSnapshot.data?.docs[index].id == userid)?
                        buildName(streamSnapshot.data?.docs[index]['username'], streamSnapshot.data?.docs[index]['email']):
                        Container(),
                      )
              );
            },
          ),
          const SizedBox(height: 10),
          currentuserid== userid?
          Container():
          followWidget(currentuserid),
          const SizedBox(height: 10),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              return ListView.builder(
                  shrinkWrap: true ,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: streamSnapshot.data != null ? streamSnapshot.data?.docs.length: 0,
                  itemBuilder: (ctx, index) =>
                      Container(
                        child: (streamSnapshot.data != null && streamSnapshot.data?.docs[index].id == userid)?
                        NumbersWidgetNonProfile(uid: userid, follower_count_int :streamSnapshot.data?.docs[index]['followers'].length, following_count_int : streamSnapshot.data?.docs[index]['following'].length,
                        analytics: widget.analytics, observer: widget.observer):
                        Container(),
                      )
              );
            },
          ),
          const SizedBox(height: 10),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              return ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true ,
                  itemCount: streamSnapshot.data != null ? streamSnapshot.data?.docs.length: 0,
                  itemBuilder: (ctx, index) =>
                      Container(
                        child: (streamSnapshot.data != null && streamSnapshot.data?.docs[index].id == userid)?
                        buildAbout(streamSnapshot.data?.docs[index]['about']):
                        Container(),
                      )
              );
            },
          ),
          const SizedBox(height: 40),
          widget.private == false || (widget.private == true && widget.followerlist.contains(currentuserid)) ?
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('posts')
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              return ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true ,
                  itemCount: streamSnapshot.data != null ? streamSnapshot.data?.docs.length: 0,
                  itemBuilder: (ctx, index) =>
                      Container(
                        child: (streamSnapshot.data != null && streamSnapshot.data?.docs[index]["user_id"] == userid)?
                        PostTile(post_item: Post(streamSnapshot.data?.docs[index].id ?? '', streamSnapshot.data?.docs[index]["like_id"] ?? [], streamSnapshot.data?.docs[index]['image_link'] ?? '', streamSnapshot.data?.docs[index]['comments'] ?? [], streamSnapshot.data?.docs[index]['user_id'] ?? '', streamSnapshot.data?.docs[index]['caption'] ?? '', streamSnapshot.data?.docs[index]['date'] ?? '', streamSnapshot.data?.docs[index]['reshared_by'] ?? ''),analytics: widget.analytics, observer:widget.observer):
                        Container(),
                      )
              );
            },
          ):
              Column(
                children: [
                  Divider(color:Colors.black),
                  SizedBox(height:20),
                  Center(
                    child: Text("PRIVATE PROFILE", style:TextStyle(fontSize: 18, color: Colors.black54))
                  ),
                  SizedBox(height:10),
                  Center(
                    child:Icon(Icons.lock, size:40),
                  )
                ],
              ),
        ],
      ),
    );
  }

  Widget buildName(username,e_mail) => Column(
    children: [
      Text(
        username,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24 ),
      ),
      const SizedBox(height: 4),
      Text(
          e_mail,
          style: TextStyle(color: Colors.grey )
      )
    ],
  );

  Widget followWidget(currentuser) => Column(
    children: [
        StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          return ListView.builder(
          shrinkWrap: true ,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.only(top: 10),
          itemCount: streamSnapshot.data != null ? streamSnapshot.data?.docs.length : 0,
          itemBuilder: (ctx, index) =>
          Container(
          child: (streamSnapshot.data != null && streamSnapshot.data?.docs[index].id == widget.user_id)?
          Container(
            child:(streamSnapshot.data?.docs[index]["followers"].contains(currentuser))?
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(left:100.0, right: 100.0),
                  child: ElevatedButton(
                    child: Text("UNFOLLOW"),
                    onPressed: () {unfollow(currentuser,streamSnapshot.data?.docs[index].id, streamSnapshot.data?.docs[index]["followers"]);},
              ),
                )):
              Container(
                child: (streamSnapshot.data?.docs[index]["pendingfollowers"].contains(currentuser))?
                Padding(
                  padding: const EdgeInsets.only(left:100.0, right: 100.0),
                  child: ElevatedButton(
                  child: Text("REQUEST PENDING"),
                  onPressed:null,
                ),
                ) :
                Padding(
                  padding: const EdgeInsets.only(left:100.0, right: 100.0),
                  child: ElevatedButton(
                    child: Text("FOLLOW"),
                    onPressed: () {follow(currentuser,streamSnapshot.data?.docs[index].id, streamSnapshot.data?.docs[index]["followers"], streamSnapshot.data?.docs[index]["pendingfollowers"]  );},
                  ),
                ),
              )
          ):
          Container(),
          )
          );
        },
        ),
      ],
  );


  Widget buildAbout(about2) => Container(
    padding: EdgeInsets.symmetric(horizontal: 48),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ABOUT',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Text(
          about2,
          style: TextStyle(fontSize: 16, height: 1.4),
        ),
      ],
    ),
  );



}
