import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:opale/features/comment/add_comment_screen.dart';
import 'package:opale/features/comment/widgets/comment_card.dart';
import 'package:opale/features/constant/widgets/error.dart';
import 'package:opale/features/constant/widgets/loader.dart';
import 'package:opale/theme/pallete.dart';

class CommentScreen extends StatelessWidget {
  final String id;
  final int colors;
  const CommentScreen({Key? key, required this.id, required this.colors})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User currentUser = auth.currentUser!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(colors),
        centerTitle: false,
        title: const Text(
          "Comments",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontFamily: 'OdibeeSans',
            color: Pallete.whiteColor,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('solutions')
            .doc(id)
            .collection('comments')
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              if (snapshot.data!.docs.isEmpty) {
                return const ErrorMessage(mess: 'Empty');
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (ctx, index) => CommentCard(
                    snap: snapshot.data!.docs[index].data(),
                    colors: colors,
                  ),
                );
              }
            } else if (snapshot.hasError) {
              return ErrorMessage(mess: '${snapshot.error}');
            }
          }
          return ErrorMessage(mess: '${snapshot.error}');
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AddCommentScreen(
              colors: colors,
              profImage: currentUser.photoURL!,
              sid: id,
              uid: currentUser.uid,
              username: currentUser.displayName!,
            ),
          ),
        ),
        label: const Text(
          'Add a comment',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        icon: const Icon(
          Icons.add_circle_rounded,
          color: Colors.white,
        ),
        backgroundColor: Color(colors),
      ),
    );
  }
}
