import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs310group1/model/report_object.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReportsData {

  final String? uid = FirebaseAuth.instance.currentUser?.uid;
  ReportsData();

  // collection reference
  final CollectionReference reportsCollection = FirebaseFirestore.instance.collection('reports');

  Future<void> addReport(reported_user_id,reported_post_id,reason) {
    // Call the user's CollectionReference to add a new user
    return reportsCollection
        .add({
      'reported_by': uid, // John Doe
      'reported_user_id': reported_user_id, // Stokes and Sons
      'reported_post_id': reported_post_id, // 42
      'reason' : reason,
    })
        .then((value) => print("Report Added"))
        .catchError((error) => print("Failed to add report: $error"));
  }

  // brew list from snapshot
  List<Report> _reportListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc){
      return Report(doc.id ?? '', doc["reported_by"] ?? "", doc['reported_post_id'] ?? '', doc['reported_user_id'] ?? "" ,doc['reason'] ?? ''
      );
    }).toList();
  }

  Stream<List<Report>> get reports {
    return reportsCollection.snapshots().map(_reportListFromSnapshot);
  }

}