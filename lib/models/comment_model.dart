import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String id;
  final String solutionid;
  final String photoUrl;
  final String uid;
  final String profImage;
  final String username;
  final String description;
  final DateTime dateStart;
  final List like;
  final List signal;
  final List awards;

  const CommentModel({
    required this.uid,
    required this.id,
    required this.photoUrl,
    required this.description,
    required this.dateStart,
    required this.solutionid,
    required this.awards,
    required this.like,
    required this.signal,
    required this.profImage,
    required this.username,
  });

  static CommentModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return CommentModel(
      photoUrl: snapshot["photoUrl"],
      solutionid: snapshot["solutionid"],
      dateStart: snapshot["dateStart"],
      description: snapshot["description"],
      id: snapshot["id"],
      uid: snapshot["uid"],
      like: snapshot["like"],
      signal: snapshot["signal"],
      awards: snapshot["awards"],
      profImage: snapshot['profImage'],
      username: snapshot['username'],
    );
  }

  Map<String, dynamic> toJson() => {
        "solutionid": solutionid,
        "uid": uid,
        "id": id,
        "photoUrl": photoUrl,
        "dateStart": dateStart,
        "description": description,
        "awards": awards,
        "like": like,
        "signal": signal,
        'username': username,
        'profImage': profImage,
      };
}
