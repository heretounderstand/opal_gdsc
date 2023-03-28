import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:opale/features/add_solution/widgets/form_map.dart';
import 'package:opale/features/add_solution/widgets/link_form.dart';
import 'package:opale/features/add_solution/widgets/pick_image.dart';
import 'package:opale/features/add_solution/widgets/select_goal.dart';
import 'package:opale/features/add_solution/widgets/text_field_input.dart';
import 'package:opale/features/constant/ressources/snackbar.dart';
import 'package:opale/theme/pallete.dart';

class AddSolutionScreen extends StatefulWidget {
  const AddSolutionScreen({Key? key}) : super(key: key);

  @override
  State<AddSolutionScreen> createState() => _AddSolutionScreenState();
}

class _AddSolutionScreenState extends State<AddSolutionScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User currentUser;
  bool isMap = false;
  Uint8List? file;
  String link = "no link";
  List goal = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  List position = [];
  List radius = [];
  List impact = [];

  @override
  void initState() {
    super.initState();
    currentUser = _auth.currentUser!;
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
        backgroundColor: goal.isEmpty ? Pallete.purpleColor : Color(goal[3]),
        title: Text(
          goal.isEmpty
              ? "Choose the target goal"
              : !isMap
                  ? "Add info about your solution"
                  : "Localise its action",
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
              color: goal[3],
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
              type: goal[0],
              logo: goal[2],
              profImage: currentUser.photoURL!,
              typename: goal[1],
              username: currentUser.displayName!,
            )
          : goal.isEmpty
              ? SelectGoal(
                  check: (List<dynamic> value) {
                    setState(() {
                      goal = value;
                    });
                  },
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      PickImage(
                        photoUrl: goal[2],
                        banner: (Uint8List value) {
                          setState(() {
                            file = value;
                          });
                        },
                      ),
                      const SizedBox(
                        height: 64,
                      ),
                      Text(
                        goal[1],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          color: Color(goal[3]),
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
                            color: Color(goal[3]),
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
                            color: Color(goal[3]),
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
                        color: goal[3],
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
                          backgroundColor: Color(goal[3]),
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
