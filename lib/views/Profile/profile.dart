import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs310group1/model/users.dart';
import 'package:cs310group1/utils/user_preferences.dart';
import 'package:cs310group1/views/FeedView/post_object.dart';
import 'package:cs310group1/views/FeedView/post_tile.dart';
import 'package:cs310group1/views/Profile/appbar_widget.dart';
import 'package:cs310group1/views/Profile/edit_profile_page.dart';
import 'package:cs310group1/views/Profile/numbers_widget.dart';
import 'package:cs310group1/views/Profile/profile_widget.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ProfilePage extends StatefulWidget {

  static const routeName = "/profile";
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;


  const ProfilePage({Key? key, required this.analytics, required this.observer}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  @override
  void initState() {
    super.initState();
  }

  //update dialog

  Future<void> showAlertDialog(String user_id,String field) async {
    TextEditingController nameController = TextEditingController();
    return showDialog(
        context: context,
        builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Enter new " + field, textAlign: TextAlign.center,),
              content: Container(
                  height: 150,
                  child: Column(
                    children:[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      OutlineButton(onPressed:() {
                        print(nameController.text);
                        FirebaseFirestore.instance.collection('users').doc(user_id).update({field: nameController.text});
                      }, child:Text("Save"))
                    ]
                  ),
              )
            );
        });
  }

  Future<void> showprofilepicture(image_path) async{
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              contentPadding: EdgeInsets.all(0) ,
              content: Image(
                  image: NetworkImage(image_path),
                  height: 400,
                  width:  300,
              )
          );
        });
  }
  @override
  Widget build(BuildContext context) {
    final user = UserPreferences.myUser; //temporary, not needed when we fetch from firestore
    dynamic userid = "";
    if(FirebaseAuth.instance.currentUser != null){
      userid = FirebaseAuth.instance.currentUser?.uid;
    };
    return Scaffold(
      appBar:  buildAppBar(context,widget.analytics,widget.observer),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          Container(
            child: StreamBuilder(
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
                            imagePath: streamSnapshot.data?.docs[index]['image_path'] ?? "AASDGH", //default profile page, static, not from firestore
                            onClicked: ()  {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditProfilePic(userid: userid)
                                  ));
                            },
                            onClicked2 : () {
                              showprofilepicture(streamSnapshot.data?.docs[index]['image_path'] );
                            }
                          ):
                          Container(),
                        )
                );
              },
            ),
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
                        buildName(streamSnapshot.data?.docs[index]['username'], streamSnapshot.data?.docs[index]['email'],userid):
                        Container(),
                      )
              );
            },
          ),
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
                        NumbersWidget(
                            uid: userid, follower_count_int :streamSnapshot.data?.docs[index]['followers'].length, following_count_int : streamSnapshot.data?.docs[index]['following'].length,
                            pendingfollowers_count_int : streamSnapshot.data?.docs[index]['pendingfollowers'].length, private:streamSnapshot.data?.docs[index]['private'],
                          analytics: widget.analytics, observer: widget.observer
                        ):
                        Container(),
                      )
              );
            },
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              dynamic userid = FirebaseAuth.instance.currentUser?.uid;
              return ListView.builder(
                  shrinkWrap: true ,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: streamSnapshot.data != null ? streamSnapshot.data?.docs.length: 0,
                  itemBuilder: (ctx, index) =>
                      Container(
                        child: (streamSnapshot.data != null && streamSnapshot.data?.docs[index].id == userid)?

                        Container(child: (streamSnapshot.data?.docs[index]["private"] == true ) ?
                        TextButton(onPressed: () {FirebaseFirestore.instance.collection('users').doc(userid).update({'private': false });}, child: Text("Make the account unprivate")):
                        TextButton(onPressed: () {FirebaseFirestore.instance.collection('users').doc(userid).update({'private': true });}, child: Text("Make the account private"))):
                        Container(),
                      )
              );
            },
          ),
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
            buildAbout(streamSnapshot.data?.docs[index]['about'],userid):
          Container(),
          )
          );
          },
          ),
          const SizedBox(height: 24),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('posts')
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              return ListView.builder(
                  shrinkWrap: true ,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: streamSnapshot.data != null ? streamSnapshot.data?.docs.length: 0,
                  itemBuilder: (ctx, index) =>
                      Container(
                        child: (streamSnapshot.data != null && streamSnapshot.data?.docs[index]["user_id"] == userid || streamSnapshot.data?.docs[index]["reshared_by"] == userid  )?
                        PostTile(post_item: Post(streamSnapshot.data?.docs[index].id ?? '', streamSnapshot.data?.docs[index]["like_id"] ?? [], streamSnapshot.data?.docs[index]['image_link'] ?? '', streamSnapshot.data?.docs[index]['comments'] ?? [], streamSnapshot.data?.docs[index]['user_id'] ?? '', streamSnapshot.data?.docs[index]['caption'] ?? '' , streamSnapshot.data?.docs[index]['date'] ?? '', streamSnapshot.data?.docs[index]['reshared_by'] ?? '' ), analytics: widget.analytics, observer:widget.observer):
                        Container(),
                      )
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildName(username,e_mail,userid) => Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            username,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24 ),
          ),
          IconButton(onPressed: () {showAlertDialog(userid, "username");}, icon: Icon(Icons.edit))
        ],
      ),
      const SizedBox(height: 4),
      Text(
          e_mail,
          style: TextStyle(color: Colors.grey )
      )
    ],
  );

  Widget buildAbout(String about2, String userid) => Container(
    padding: EdgeInsets.symmetric(horizontal: 48),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ABOUT',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text(
              about2,
              style: TextStyle(fontSize: 16, height: 1.4),
            ),
            IconButton(onPressed: () {showAlertDialog(userid, "about");}, icon: Icon(Icons.edit))
          ],
        ),
      ],
    ),
  );



}
