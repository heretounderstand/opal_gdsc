import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:opale/features/add_solution/ressources/pick_image.dart';
import 'package:opale/features/add_solution/widgets/text_field_input.dart';
import 'package:opale/features/comment/comment_screen.dart';
import 'package:opale/features/comment/ressources/comment_methods.dart';
import 'package:opale/features/constant/ressources/snackbar.dart';
import 'package:opale/features/constant/widgets/loader.dart';
import 'package:opale/theme/pallete.dart';

class AddCommentScreen extends StatefulWidget {
  final int colors;
  final String sid;
  final String uid;
  final String username;
  final String profImage;
  final bool isMod;
  final String cid;
  final String photoUrl;
  final String description;
  const AddCommentScreen({
    Key? key,
    required this.colors,
    required this.sid,
    required this.uid,
    required this.username,
    required this.profImage,
    this.cid = '',
    this.isMod = false,
    this.photoUrl = '',
    this.description = '',
  }) : super(key: key);

  @override
  State<AddCommentScreen> createState() => _AddCommentScreenState();
}

class _AddCommentScreenState extends State<AddCommentScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  Uint8List image = Uint8List.fromList([]);
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _descriptionController.text = widget.description;
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  void addComment() async {
    // set loading to true
    setState(() {
      _isLoading = true;
    });
    // signup user using our authmethodds
    String res = 'error';
    if (!widget.isMod) {
      res = await CommentMethods().uploadComment(
        widget.sid,
        _descriptionController.text,
        image,
        widget.uid,
        widget.username,
        widget.profImage,
      );
    } else {
      res = await CommentMethods().modifyComment(
        widget.sid,
        _descriptionController.text,
        image,
        widget.username,
        widget.profImage,
        widget.photoUrl,
        widget.cid,
      );
    }
    // if string returned is sucess, user has been created
    if (res == "success") {
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => CommentScreen(
            id: widget.sid,
            colors: widget.colors,
          ),
        ),
      );
      // navigate to the home screen
    } else {
      setState(() {
        _isLoading = false;
      });
      // show the error
      showSnackBar(context, res);
    }
  }

  changeImage(BuildContext parentContext) {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          children: <Widget>[
            SizedBox(
              height: 400,
              child: Image.memory(
                image,
                fit: BoxFit.contain,
              ),
            ),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Change'),
                onPressed: () {
                  Navigator.pop(context);
                  selectImage(parentContext);
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Delete'),
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    image = Uint8List.fromList([]);
                  });
                }),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  Future<void> selectImage(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Choose an image'),
          children: <Widget>[
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.pop(context);
                  Uint8List fyle = await pickImage(ImageSource.camera);
                  image = fyle;
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List fyle = await pickImage(ImageSource.gallery);
                  image = fyle;
                }),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  Widget buildImage(BuildContext parentContext) => InkWell(
        onTap: () {
          selectImage(parentContext);
        },
        child: SizedBox(
          width: MediaQuery.of(parentContext).size.width * 0.75,
          height: MediaQuery.of(parentContext).size.height * 0.25,
          child: DottedBorder(
            dashPattern: const [4, 5],
            strokeWidth: 2,
            borderType: BorderType.RRect,
            radius: const Radius.circular(8.0),
            padding: const EdgeInsets.all(8.0),
            child: const Center(
              child: Icon(
                Icons.add_a_photo_rounded,
                size: 36,
              ),
            ),
          ),
        ),
      );

  Widget buildSetMod(BuildContext parentContext) => InkWell(
        onTap: () {
          selectImage(parentContext);
        },
        child: Container(
          width: MediaQuery.of(parentContext).size.width * 0.75,
          height: MediaQuery.of(parentContext).size.height * 0.25,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
          ),
          child: Image.network(
            widget.photoUrl,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
      );

  Widget buildSet(BuildContext parentContext) => InkWell(
        onTap: () {
          changeImage(parentContext);
        },
        child: Container(
          width: MediaQuery.of(parentContext).size.width * 0.75,
          height: MediaQuery.of(parentContext).size.height * 0.25,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
          ),
          child: Image.memory(
            image,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(widget.colors),
        centerTitle: false,
        title: Text(
          widget.isMod ? "Add your comment" : "Add a comment",
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 24,
            fontFamily: 'OdibeeSans',
            color: Pallete.whiteColor,
          ),
        ),
      ),
      body: _isLoading
          ? const Loader()
          : Padding(
              padding: const EdgeInsets.all(18),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 24),
                    TextFieldInput(
                        textEditingController: _descriptionController,
                        hintText: 'Share your thoughts',
                        textInputType: TextInputType.multiline,
                        icon: Icon(
                          Icons.book_rounded,
                          color: Color(widget.colors),
                        )),
                    const SizedBox(height: 24),
                    Text(
                      "Add an Image",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        fontFamily: 'OdibeeSans',
                        color: Color(widget.colors),
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    image.isNotEmpty
                        ? buildSet(context)
                        : widget.isMod
                            ? buildSetMod(context)
                            : buildImage(context),
                    const SizedBox(
                      height: 24,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_descriptionController.text.isNotEmpty) {
                          addComment();
                        } else {
                          showSnackBar(context, 'Please fill the text field');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(widget.colors),
                      ),
                      child: const Text(
                        "Next",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Pallete.whiteColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
