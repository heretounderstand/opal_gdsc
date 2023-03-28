import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String photoUrl;
  final String username;
  final DateTime dateSign;
  final List<String> awards;
  final int point;
  final List following;
  final List followers;

  const UserModel({
    required this.username,
    required this.uid,
    required this.photoUrl,
    required this.dateSign,
    required this.awards,
    required this.point,
    required this.followers,
    required this.following,
  });

  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserModel(
      username: snapshot["username"],
      uid: snapshot["uid"],
      photoUrl: snapshot["photoUrl"],
      dateSign: snapshot["dateSign"],
      awards: snapshot["awards"],
      point: snapshot["point"],
      followers: snapshot["followers"],
      following: snapshot["following"],
    );
  }

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "photoUrl": photoUrl,
        "dateSign": dateSign,
        "awards": awards,
        "point": point,
        "followers": followers,
        "following": following,
      };
}
