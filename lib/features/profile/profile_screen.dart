import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:opale/features/constant/widgets/error.dart';
import 'package:opale/features/constant/widgets/loader.dart';
import 'package:opale/features/constant/widgets/map_display.dart';
import 'package:opale/features/profile/widgets/profile_card.dart';
import 'package:opale/theme/pallete.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isMap = false;
  bool isSave = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: isSave
          ? FirebaseFirestore.instance
              .collection('solutions')
              .where('save', arrayContains: widget.uid)
              .snapshots()
          : FirebaseFirestore.instance
              .collection('users')
              .where('uid', isEqualTo: widget.uid)
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
              return Scaffold(
                appBar: AppBar(
                    centerTitle: false,
                    backgroundColor: Pallete.purpleColor,
                    title: Text(
                      snapshot.data!.docs.first['username'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontFamily: 'OdibeeSans',
                        color: Pallete.whiteColor,
                      ),
                    ),
                    actions: [
                      IconButton(
                        onPressed: () {
                          if (isMap) {
                            setState(() {
                              isMap = false;
                            });
                          } else {
                            setState(() {
                              isMap = true;
                            });
                          }
                        },
                        icon: Icon(
                          isMap ? Icons.map_rounded : Icons.person_rounded,
                          color: Pallete.whiteColor,
                        ),
                      ),
                      isMap
                          ? IconButton(
                              onPressed: () {
                                if (isSave) {
                                  setState(() {
                                    isMap = false;
                                  });
                                } else {
                                  setState(() {
                                    isSave = true;
                                  });
                                }
                              },
                              icon: Icon(
                                isSave
                                    ? Icons.bookmark_rounded
                                    : Icons.bookmark_outline_rounded,
                                color: Pallete.whiteColor,
                              ),
                            )
                          : Container()
                    ]),
                body: isSave
                    ? MapDisplay(snap: snapshot.data!.docs)
                    : ProfileCard(
                        snap: snapshot.data!.docs.first.data(), isMap: isMap),
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
