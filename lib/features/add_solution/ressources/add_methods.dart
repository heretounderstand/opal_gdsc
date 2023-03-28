import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:opale/features/constant/ressources/storage_methods.dart';
import 'package:opale/models/solution_model.dart';
import 'package:opale/theme/assets.dart';
import 'package:uuid/uuid.dart';

class AddMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadSolution(
    String name,
    String description,
    String link,
    Uint8List file,
    String uid,
    List impact,
    List position,
    List radia,
    String type,
    int color,
    String username,
    String profImage,
    String typename,
    String logo,
  ) async {
    String res = "Some error occurred";
    try {
      String photoUrl = Assets.bannerDefault;
      if (file.isNotEmpty) {
        photoUrl = await StorageMethods()
            .uploadImageToStorage('unSolution', file, true);
      }
      String id = const Uuid().v1(); // creates unique id based on time
      SolutionModel solution = SolutionModel(
        description: description,
        uid: uid,
        type: type,
        dateStart: DateTime.now(),
        center: position,
        dateEnd: DateTime.now(),
        id: id,
        impact: impact,
        link: link,
        name: name,
        photoUrl: photoUrl,
        radius: radia,
        awards: [],
        like: [],
        save: [],
        signal: [],
        color: color,
        logo: logo,
        profImage: profImage,
        typename: typename,
        username: username,
      );
      _firestore.collection('solutions').doc(id).set(solution.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> modifySolution(
    String name,
    String description,
    String link,
    Uint8List file,
    List impact,
    List position,
    List radia,
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
      _firestore.collection('solutions').doc(id).update({
        'description': description,
        'center': position,
        'impact': impact,
        'link': link,
        'name': name,
        'photoUrl': photoUrl,
        'radius': radia,
        'profImage': profImage,
        'username': username,
      });
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
