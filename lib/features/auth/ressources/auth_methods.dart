import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:opale/models/user_model.dart';
import 'package:opale/theme/assets.dart';

class AuthMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // get user details
  Future<UserModel> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return UserModel.fromSnap(documentSnapshot);
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await _auth.signInWithCredential(credential);
  }

  // Signing Up User

  Future<String> signUpUser() async {
    String res = "Some error Occurred";
    User currentUser = _auth.currentUser!;

    DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(currentUser.uid).get();

    if (!documentSnapshot.exists) {
      try {
        String photoUrl = Assets.avatarDefault;
        UserModel user = UserModel(
          username: currentUser.displayName == null
              ? 'No name'
              : currentUser.displayName!,
          uid: currentUser.uid,
          photoUrl:
              currentUser.photoURL == null ? photoUrl : currentUser.photoURL!,
          dateSign: DateTime.now(),
          awards: [],
          point: 0,
          followers: [],
          following: [],
        );

        // adding user in our database
        await _firestore
            .collection("users")
            .doc(currentUser.uid)
            .set(user.toJson());

        res = "success";
      } catch (err) {
        return err.toString();
      }
    } else {
      try {
        if (documentSnapshot['username'] != currentUser.displayName) {
          await _firestore
              .collection("users")
              .doc(currentUser.uid)
              .update({'username': currentUser.displayName});
        }
        if (documentSnapshot['photoUrl'] != currentUser.photoURL) {
          await _firestore
              .collection("users")
              .doc(currentUser.uid)
              .update({'photoUrl': currentUser.photoURL});
        }
      } catch (err) {
        return err.toString();
      }
    }
    return res;
  }

  // logging in user
  Future<String> signInUser() async {
    String res = "Some error Occurred";
    try {
      // logging in user with email and password
      await signInWithGoogle();
      res = await signUpUser();
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
