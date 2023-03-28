import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:opale/features/add_solution/modify_solution_screen.dart';
import 'package:opale/features/comment/comment_screen.dart';
import 'package:opale/features/constant/ressources/snackbar.dart';
import 'package:opale/features/feed/ressources/update_methods.dart';
import 'package:opale/features/feed/widgets/like_animation.dart';
import 'package:opale/features/profile/profile_screen.dart';
import 'package:opale/features/un_goal/un_goal_screen.dart';
import 'package:opale/theme/pallete.dart';
import 'package:url_launcher/url_launcher.dart';

class SolutionCard extends StatefulWidget {
  final Map snap;
  const SolutionCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<SolutionCard> createState() => _SolutionCardState();
}

class _SolutionCardState extends State<SolutionCard> {
  int commentLen = 0;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    fetchCommentLen();
  }

  fetchCommentLen() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('solutions')
          .doc(widget.snap['id'])
          .collection('comments')
          .get();
      commentLen = snap.docs.length;
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 10,
        ),
        decoration: const BoxDecoration(
          color: Pallete.whiteColor,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
                blurRadius: 4.0,
                blurStyle: BlurStyle.outer,
                offset: Offset(0, 5)),
          ],
        ),
        child: Column(
          children: [
            // HEADER SECTION OF THE POST
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 16,
              ).copyWith(right: 0),
              child: Row(
                children: <Widget>[
                  InkWell(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => UnGoalScreen(
                          id: widget.snap['type'],
                        ),
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 16,
                      backgroundImage: NetworkImage(
                        widget.snap['logo'],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 8,
                      ),
                      child: Text(
                        widget.snap['typename'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(widget.snap['color']),
                        ),
                      ),
                    ),
                  ),
                  widget.snap['uid'] == currentUser.uid
                      ? PopupMenuButton(
                          child: const Icon(Icons.more_vert_rounded),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 1,
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ModifySolutionSreen(
                                    snap: widget.snap,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.mode_edit_rounded,
                                    color: Color(widget.snap["color"]),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Text("Modify")
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 2,
                              onTap: () async {
                                String mess = await UpdateMethods()
                                    .stopSolution(widget.snap['id']);
                                showSnackBar(context, mess);
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.stop_rounded,
                                    color: Color(widget.snap["color"]),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Text("End")
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 3,
                              onTap: () async {
                                String mess = await UpdateMethods()
                                    .deleteSolution(widget.snap['id']);
                                showSnackBar(context, mess);
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.delete_rounded,
                                    color: Color(widget.snap["color"]),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Text("Delete")
                                ],
                              ),
                            ),
                          ],
                        )
                      : PopupMenuButton(
                          child: const Icon(Icons.more_vert_rounded),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 1,
                              onTap: () async {
                                String mess = await UpdateMethods()
                                    .signalSolution(
                                        widget.snap['id'], currentUser.uid);
                                showSnackBar(context, mess);
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.flag_rounded,
                                    color: Color(widget.snap["color"]),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Text("Signal")
                                ],
                              ),
                            ),
                          ],
                        ),
                ],
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            // IMAGE SECTION OF THE POST
            Stack(
              children: [
                Image.network(
                  widget.snap['photoUrl'],
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(
                              uid: widget.snap['uid'],
                            ),
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 16,
                          backgroundImage: NetworkImage(
                            widget.snap['profImage'],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 8,
                          ),
                          child: Text(
                            widget.snap['username'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Pallete.whiteColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            // LIKE, COMMENT SECTION OF THE POST
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(
                        top: 8,
                      ),
                      child: Text(
                        widget.snap['description'],
                        textAlign: TextAlign.justify,
                      )),
                  widget.snap['link'] == "no link"
                      ? Container()
                      : Container(
                          width: double.infinity,
                          padding: const EdgeInsets.only(
                            top: 8,
                          ),
                          child: InkWell(
                            onTap: () async {
                              await launchUrl(
                                widget.snap['link'],
                              );
                            },
                            child: const Text(
                              'Click here for more info',
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                color: Pallete.blueColor,
                              ),
                            ),
                          )),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      widget.snap['dateStart'] == widget.snap['dateEnd']
                          ? DateFormat.yMMMd()
                              .format(widget.snap['dateStart'].toDate())
                          : 'Ended the: ${DateFormat.yMMMd().format(widget.snap['dateEnd'].toDate())}',
                    ),
                  ),
                ],
              ),
            ),
            //DESCRIPTION AND NUMBER OF COMMENTS
            Row(
              children: <Widget>[
                LikeAnimation(
                  isAnimating: widget.snap['like'].contains(currentUser.uid),
                  smallLike: true,
                  child: IconButton(
                      icon: widget.snap['like'].contains(currentUser.uid)
                          ? Icon(
                              Icons.favorite_rounded,
                              color: Color(widget.snap['color']),
                            )
                          : const Icon(
                              Icons.favorite_border_rounded,
                            ),
                      onPressed: () => UpdateMethods().likeSolution(
                          widget.snap['id'],
                          currentUser.uid,
                          widget.snap['like'],
                          'like')),
                ),
                DefaultTextStyle(
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1!
                        .copyWith(fontWeight: FontWeight.w800),
                    child: Text(
                      '${widget.snap['like'].length}',
                      style: Theme.of(context).textTheme.bodyText1,
                    )),
                IconButton(
                  icon: const Icon(
                    Icons.comment_outlined,
                  ),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CommentScreen(
                        id: widget.snap['id'],
                        colors: widget.snap['color'],
                      ),
                    ),
                  ),
                ),
                DefaultTextStyle(
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1!
                        .copyWith(fontWeight: FontWeight.w800),
                    child: Text(
                      '$commentLen',
                      style: Theme.of(context).textTheme.bodyText1,
                    )),
                widget.snap['uid'] == currentUser.uid
                    ? Container()
                    : Expanded(
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                            child: LikeAnimation(
                              isAnimating:
                                  widget.snap['save'].contains(currentUser.uid),
                              smallLike: true,
                              child: IconButton(
                                  icon: widget.snap['saved']
                                          .contains(currentUser.uid)
                                      ? const Icon(
                                          Icons.bookmark_rounded,
                                          color: Pallete.greenColor,
                                        )
                                      : const Icon(
                                          Icons.bookmark_border_rounded,
                                        ),
                                  onPressed: () => UpdateMethods().likeSolution(
                                      widget.snap['id'],
                                      currentUser.uid,
                                      widget.snap['save'],
                                      'save')),
                            ),
                          ),
                        ),
                      )
              ],
            )
          ],
        ),
      ),
    );
  }
}
