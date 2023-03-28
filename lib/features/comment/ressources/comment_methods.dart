import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:opale/features/constant/ressources/storage_methods.dart';
import 'package:opale/models/comment_model.dart';
import 'package:uuid/uuid.dart';

class CommentMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadComment(
    String sid,
    String description,
    Uint8List file,
    String uid,
    String username,
    String profImage,
  ) async {
    String res = "Some error occurred";
    try {
      String photoUrl = 'no image';
      if (file.isNotEmpty) {
        photoUrl = await StorageMethods()
            .uploadImageToStorage('unComment', file, true);
      }
      String id = const Uuid().v1(); // creates unique id based on time
      CommentModel solution = CommentModel(
        description: description,
        uid: uid,
        dateStart: DateTime.now(),
        solutionid: sid,
        id: id,
        photoUrl: photoUrl,
        awards: [],
        like: [],
        signal: [],
        profImage: profImage,
        username: username,
      );
      _firestore
          .collection('solutions')
          .doc(sid)
          .collection('comments')
          .doc(id)
          .set(solution.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> modifyComment(
    String sid,
    String description,
    Uint8List file,
    String username,
    String profImage,
    String prevphoto,
    String id,
  ) async {
    String res = "Some error occurred";
    try {
      String photoUrl = prevphoto;
      if (file.isNotEmpty) {
        photoUrl = await StorageMethods()
            .uploadImageToStorage('unSolution', file, true);
      }
      _firestore
          .collection('solutions')
          .doc(sid)
          .collection('comments')
          .doc(id)
          .update({
        'description': description,
        'photoUrl': photoUrl,
        'profImage': profImage,
        'username': username,
      });
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> deleteComment(
    String sid,
    String cid,
  ) async {
    String res = "Some error occurred";
    try {
      _firestore
          .collection('solutions')
          .doc(sid)
          .collection('comments')
          .doc(cid)
          .delete();
      res = "deleted";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> signalComment(
    String sid,
    String cid,
    String uid,
  ) async {
    String res = "Some error occurred";
    try {
      _firestore
          .collection('solutions')
          .doc(sid)
          .collection('comments')
          .doc(cid)
          .update({
        'signal': FieldValue.arrayRemove([uid])
      });
      _firestore
          .collection('solutions')
          .doc(sid)
          .collection('comments')
          .doc(cid)
          .update({
        'signal': FieldValue.arrayUnion([uid])
      });
      res = "signaled";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> likeComment(
    String sid,
    String cid,
    String uid,
    List list,
  ) async {
    String res = "Some error occurred";
    try {
      if (list.contains(uid)) {
        _firestore
            .collection('solutions')
            .doc(sid)
            .collection('comments')
            .doc(cid)
            .update({
          'like': FieldValue.arrayRemove([uid])
        });
      } else {
        _firestore
            .collection('solutions')
            .doc(sid)
            .collection('comments')
            .doc(cid)
            .update({
          'like': FieldValue.arrayUnion([uid])
        });
      }
      res = "liked";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
