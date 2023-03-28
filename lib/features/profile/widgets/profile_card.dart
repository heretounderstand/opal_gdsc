import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:opale/features/constant/ressources/snackbar.dart';
import 'package:opale/features/constant/widgets/error.dart';
import 'package:opale/features/constant/widgets/map_display.dart';
import 'package:opale/features/profile/ressources/user_methods.dart';
import 'package:opale/features/un_goal/un_goal_screen.dart';
import 'package:opale/theme/pallete.dart';

class ProfileCard extends StatefulWidget {
  final Map snap;
  final bool isMap;
  const ProfileCard({Key? key, required this.snap, required this.isMap})
      : super(key: key);

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List solLen = [];
  int numLike = 0;
  int bestLike = 0;
  int colNum = 0;
  List logo = [];
  List ids = [];
  bool isMap = false;

  @override
  void initState() {
    super.initState();
    fetchSolutionLen();
  }

  fetchSolutionLen() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('solutions')
          .where('uid', isEqualTo: widget.snap['uid'])
          .get();
      solLen = snap.docs;
      for (var element in solLen) {
        numLike == numLike + element['like'].length;
        if (!logo.contains(element['logo'])) {
          logo.add(element['logo']);
          ids.add(element['type']);
        }
        if (bestLike < element['like'].length) {
          bestLike = element['like'].length;
          colNum = element['color'];
        }
      }
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    User currentUser = _auth.currentUser!;
    return widget.isMap
        ? solLen.isEmpty
            ? const ErrorMessage(mess: 'Empty')
            : MapDisplay(snap: solLen)
        : Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 72,
                  backgroundImage: NetworkImage(widget.snap['photoUrl']),
                ),
                const SizedBox(
                  height: 36,
                ),
                Center(
                  child: Text(
                    widget.snap['username'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontFamily: 'Macondo',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                const Divider(),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      widget.snap['followers'].length < 100
                          ? Icons.person_rounded
                          : widget.snap['followers'].length < 10000
                              ? Icons.group_rounded
                              : Icons.groups_rounded,
                      color: colNum == 0 ? Pallete.purpleColor : Color(colNum),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 8,
                        ),
                        child: Text(
                          'Followers :  ${widget.snap['followers'].length}',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Macondo',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 50,
                    ),
                    widget.snap['uid'] == currentUser.uid
                        ? Icon(
                            widget.snap['following'].length < 100
                                ? Icons.person_rounded
                                : widget.snap['following'].length < 10000
                                    ? Icons.group_rounded
                                    : Icons.groups_rounded,
                            color: colNum == 0
                                ? Pallete.purpleColor
                                : Color(colNum),
                          )
                        : Container(),
                    widget.snap['uid'] == currentUser.uid
                        ? Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 8,
                              ),
                              child: Text(
                                'Following :  ${widget.snap['following'].length}',
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Macondo',
                                ),
                              ),
                            ),
                          )
                        : Container(),
                    widget.snap['uid'] == currentUser.uid
                        ? Container()
                        : ElevatedButton(
                            onPressed: () async {
                              String mess = await UserMethods().followUser(
                                  widget.snap['uid'],
                                  currentUser.uid,
                                  widget.snap['followers']);
                              showSnackBar(context, mess);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colNum == 0
                                  ? Pallete.purpleColor
                                  : Color(colNum),
                            ),
                            child: Text(
                              widget.snap['followers'].contains(currentUser.uid)
                                  ? "Unfollow"
                                  : 'Follow',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Pallete.whiteColor,
                              ),
                            ),
                          ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                const Divider(),
                const SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 8,
                  ),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                            text: 'Number of proposed solutions :',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Pallete.blackColor,
                            )),
                        TextSpan(
                            text: '  ${solLen.length}',
                            style: const TextStyle(
                              color: Pallete.blackColor,
                            )),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 8,
                  ),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                            text: 'Number of likes :',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Pallete.blackColor,
                            )),
                        TextSpan(
                            text: '  $numLike',
                            style: const TextStyle(
                              color: Pallete.blackColor,
                            )),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 8,
                  ),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                            text: 'Maximum number of likes for one solution :',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Pallete.blackColor,
                            )),
                        TextSpan(
                            text: '  $bestLike',
                            style: const TextStyle(
                              color: Pallete.blackColor,
                            )),
                      ],
                    ),
                  ),
                ),
                logo.isEmpty
                    ? Container()
                    : Expanded(
                        flex: 2,
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            crossAxisCount: 3,
                          ),
                          itemCount: logo.length,
                          itemBuilder: (BuildContext ctx, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => UnGoalScreen(
                                      id: ids[index],
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.transparent,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8.0))),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image(
                                    image: NetworkImage(logo[index]),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      )
              ],
            ),
          );
  }
}
