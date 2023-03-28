import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:opale/features/add_solution/widgets/form_map.dart';
import 'package:opale/features/add_solution/widgets/link_form.dart';
import 'package:opale/features/add_solution/widgets/pick_image.dart';
import 'package:opale/features/add_solution/widgets/text_field_input.dart';
import 'package:opale/features/constant/ressources/snackbar.dart';
import 'package:opale/theme/pallete.dart';

class ModifySolutionSreen extends StatefulWidget {
  final Map snap;
  const ModifySolutionSreen({Key? key, required this.snap}) : super(key: key);

  @override
  State<ModifySolutionSreen> createState() => _ModifySolutionSreenState();
}

class _ModifySolutionSreenState extends State<ModifySolutionSreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User currentUser;
  bool isMap = false;
  Uint8List? file;
  String link = "no link";
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  List position = [];
  List radius = [];
  List impact = [];

  @override
  void initState() {
    super.initState();
    currentUser = _auth.currentUser!;
    link = widget.snap['link'];
    _nameController.text = widget.snap['name'];
    _descriptionController.text = widget.snap['description'];
    position = widget.snap['center'];
    radius = widget.snap['radius'];
    impact = widget.snap['impact'];
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Color(widget.snap['color']),
        title: Text(
          isMap ? "Update info of your solution" : "Localise its new action",
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 24,
            fontFamily: 'OdibeeSans',
            color: Pallete.whiteColor,
          ),
        ),
      ),
      body: isMap
          ? FormMap(
              color: widget.snap['color'],
              exit: (bool value) {
                setState(() {
                  isMap = value;
                });
              },
              name: _nameController.text,
              description: _descriptionController.text,
              link: link,
              uid: currentUser.uid,
              file: file == null ? Uint8List.fromList([]) : file!,
              type: widget.snap['type'],
              logo: widget.snap['logo'],
              profImage: currentUser.photoURL!,
              typename: widget.snap['typename'],
              username: currentUser.displayName!,
              isMod: true,
              id: widget.snap['id'],
              photoUrl: widget.snap['photoUrl'],
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  PickImage(
                    photoUrl: widget.snap['logo'],
                    banner: (Uint8List value) {
                      setState(() {
                        file = value;
                      });
                    },
                    photo: widget.snap['photoUrl'],
                  ),
                  const SizedBox(
                    height: 64,
                  ),
                  Text(
                    widget.snap['typename'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      color: Color(widget.snap['color']),
                      fontFamily: 'OdibeeSans',
                    ),
                  ),
                  const SizedBox(
                    height: 36,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: TextFieldInput(
                      hintText: "Enter it's name",
                      textInputType: TextInputType.name,
                      textEditingController: _nameController,
                      icon: Icon(
                        Icons.person_rounded,
                        color: Color(widget.snap['color']),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 36,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: TextFieldInput(
                      hintText: 'Add a description',
                      textInputType: TextInputType.text,
                      textEditingController: _descriptionController,
                      icon: Icon(
                        Icons.book_rounded,
                        color: Color(widget.snap['color']),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 36,
                  ),
                  LinkForm(
                    link: (String value) {
                      setState(() {
                        link = value;
                      });
                    },
                    color: widget.snap['color'],
                    li: widget.snap['link'],
                  ),
                  const SizedBox(
                    height: 36,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_descriptionController.text.isNotEmpty &&
                          _nameController.text.isNotEmpty) {
                        setState(() {
                          isMap = true;
                        });
                      } else {
                        showSnackBar(context,
                            'Please fill the name and the description');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(widget.snap['color']),
                    ),
                    child: const Text(
                      "Next",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Pallete.whiteColor,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                ],
              ),
            ),
    );
  }
}
