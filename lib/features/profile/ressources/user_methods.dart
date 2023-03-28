import 'package:cloud_firestore/cloud_firestore.dart';

class UserMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> followUser(
    String id,
    String uid,
    List list,
  ) async {
    String res = "Some error occurred";
    try {
      if (list.contains(uid)) {
        _firestore.collection('users').doc(id).update({
          'followers': FieldValue.arrayRemove([uid])
        });
        _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([id])
        });
      } else {
        _firestore.collection('users').doc(id).update({
          'followers': FieldValue.arrayUnion([uid])
        });
        _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([id])
        });
      }
      res = "followed";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
