import 'package:cloud_firestore/cloud_firestore.dart';

class SolutionModel {
  final String id;
  final String photoUrl;
  final String uid;
  final String profImage;
  final String username;
  final String logo;
  final String typename;
  final String name;
  final String description;
  final String type;
  final String link;
  final DateTime dateStart;
  final DateTime dateEnd;
  final List impact;
  final List radius;
  final List center;
  final List like;
  final List save;
  final List signal;
  final List awards;
  final int color;

  const SolutionModel({
    required this.uid,
    required this.id,
    required this.name,
    required this.photoUrl,
    required this.description,
    required this.type,
    required this.link,
    required this.dateStart,
    required this.dateEnd,
    required this.impact,
    required this.radius,
    required this.center,
    required this.awards,
    required this.like,
    required this.save,
    required this.signal,
    required this.color,
    required this.logo,
    required this.profImage,
    required this.typename,
    required this.username,
  });

  static SolutionModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return SolutionModel(
      photoUrl: snapshot["photoUrl"],
      center: snapshot["center"],
      dateEnd: snapshot["dateEnd"],
      dateStart: snapshot["dateStart"],
      description: snapshot["description"],
      id: snapshot["id"],
      uid: snapshot["uid"],
      name: snapshot["name"],
      radius: snapshot["radius"],
      impact: snapshot["impact"],
      type: snapshot["type"],
      link: snapshot["link"],
      like: snapshot["like"],
      save: snapshot["save"],
      signal: snapshot["signal"],
      awards: snapshot["awards"],
      color: snapshot['color'],
      logo: snapshot['logo'],
      profImage: snapshot['profImage'],
      typename: snapshot['typemane'],
      username: snapshot['username'],
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "uid": uid,
        "id": id,
        "center": center,
        "link": link,
        "photoUrl": photoUrl,
        "dateEnd": dateEnd,
        "dateStart": dateStart,
        "description": description,
        "radius": radius,
        "type": type,
        "impact": impact,
        "awards": awards,
        "like": like,
        "save": save,
        "signal": signal,
        'color': color,
        'username': username,
        'typename': typename,
        'logo': logo,
        'profImage': profImage,
      };
}
