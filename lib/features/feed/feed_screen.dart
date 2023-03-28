import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:opale/features/constant/widgets/error.dart';
import 'package:opale/features/constant/widgets/loader.dart';
import 'package:opale/features/feed/widgets/solution_card.dart';

class FeedScreen extends StatelessWidget {
  final String goal;
  const FeedScreen({Key? key, required this.goal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: goal.isEmpty
          ? FirebaseFirestore.instance.collection('solutions').snapshots()
          : FirebaseFirestore.instance
              .collection('solutions')
              .where('type', isEqualTo: goal)
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
                itemBuilder: (ctx, index) => SolutionCard(
                  snap: snapshot.data!.docs[index].data(),
                ),
              );
            }
          } else if (snapshot.hasError) {
            return ErrorMessage(mess: '${snapshot.error}');
          }
        }
        return ErrorMessage(mess: '${snapshot.error}');
      },
    );
  }
}
