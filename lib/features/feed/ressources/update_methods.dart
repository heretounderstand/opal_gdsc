import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> deleteSolution(
    String id,
  ) async {
    String res = "Some error occurred";
    try {
      _firestore.collection('solutions').doc(id).delete();
      res = "deleted";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> stopSolution(
    String id,
  ) async {
    String res = "Some error occurred";
    try {
      _firestore
          .collection('solutions')
          .doc(id)
          .update({'dateEnd': DateTime.now()});
      res = "solution ended";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> signalSolution(
    String id,
    String uid,
  ) async {
    String res = "Some error occurred";
    try {
      _firestore.collection('solutions').doc(id).update({
        'signal': FieldValue.arrayRemove([uid])
      });
      _firestore.collection('solutions').doc(id).update({
        'signal': FieldValue.arrayUnion([uid])
      });
      res = "signaled";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> likeSolution(
    String id,
    String uid,
    List list,
    String type,
  ) async {
    String res = "Some error occurred";
    try {
      if (list.contains(uid)) {
        _firestore.collection('solutions').doc(id).update({
          type: FieldValue.arrayRemove([uid])
        });
      } else {
        _firestore.collection('solutions').doc(id).update({
          type: FieldValue.arrayUnion([uid])
        });
      }
      res = "${type}ed";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
