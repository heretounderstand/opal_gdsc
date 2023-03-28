import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:opale/features/comment/add_comment_screen.dart';
import 'package:opale/features/comment/ressources/comment_methods.dart';
import 'package:opale/features/constant/ressources/snackbar.dart';
import 'package:opale/features/feed/widgets/like_animation.dart';
import 'package:opale/features/profile/profile_screen.dart';
import 'package:opale/theme/pallete.dart';

class CommentCard extends StatefulWidget {
  final Map snap;
  final int colors;
  const CommentCard({Key? key, required this.snap, required this.colors})
      : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    User currentUser = _auth.currentUser!;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
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
                  backgroundImage: NetworkImage(
                    widget.snap['profImage'],
                  ),
                  radius: 18,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text: widget.snap['username'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Pallete.blackColor,
                                )),
                            TextSpan(
                                text: ' ${widget.snap['description']}',
                                style: const TextStyle(
                                  color: Pallete.blackColor,
                                )),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          DateFormat.yMMMd().format(
                            widget.snap['dateStart'].toDate(),
                          ),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    DefaultTextStyle(
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1!
                            .copyWith(fontWeight: FontWeight.w800),
                        child: Text(
                          '${widget.snap['like'].length}',
                          style: Theme.of(context).textTheme.bodyText1,
                        )),
                    LikeAnimation(
                      isAnimating:
                          widget.snap['like'].contains(currentUser.uid),
                      smallLike: true,
                      child: IconButton(
                        icon: widget.snap['like'].contains(currentUser.uid)
                            ? Icon(
                                Icons.favorite_rounded,
                                color: Color(widget.colors),
                              )
                            : const Icon(
                                Icons.favorite_border_rounded,
                              ),
                        onPressed: () => CommentMethods().likeComment(
                          widget.snap['solutionid'],
                          widget.snap['id'],
                          currentUser.uid,
                          widget.snap['like'],
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
                                    builder: (context) => AddCommentScreen(
                                      colors: widget.colors,
                                      sid: widget.snap['solutionid'],
                                      uid: widget.snap['uid'],
                                      profImage: widget.snap['profImage'],
                                      username: widget.snap['username'],
                                      cid: widget.snap['id'],
                                      photoUrl: widget.snap['photoUrl'],
                                      isMod: true,
                                      description: widget.snap['description'],
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.mode_edit_rounded,
                                      color: Color(widget.colors),
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
                                  String mess = await CommentMethods()
                                      .deleteComment(widget.snap['solutionid'],
                                          widget.snap['id']);
                                  showSnackBar(context, mess);
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.delete_rounded,
                                      color: Color(widget.colors),
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
                                  String mess = await CommentMethods()
                                      .signalComment(widget.snap['solutionid'],
                                          widget.snap['id'], currentUser.uid);
                                  showSnackBar(context, mess);
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.flag_rounded,
                                      color: Color(widget.colors),
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
            ],
          ),
          widget.snap['photoUrl'] == 'no image'
              ? Container()
              : SizedBox(
                  height: 200,
                  child: Image.network(
                    widget.snap['photoUrl'],
                    fit: BoxFit.cover,
                  ),
                ),
        ],
      ),
    );
  }
}
