import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:opale/features/constant/ressources/snackbar.dart';
import 'package:opale/features/constant/widgets/loader.dart';
import 'package:opale/theme/pallete.dart';
import 'package:url_launcher/url_launcher.dart';

class UnGoalScreen extends StatefulWidget {
  final String id;
  final Map snap;
  const UnGoalScreen({Key? key, required this.id, this.snap = const {}})
      : super(key: key);

  @override
  State<UnGoalScreen> createState() => _UnGoalScreenState();
}

class _UnGoalScreenState extends State<UnGoalScreen> {
  Map solData = {};
  bool isLoading = false;
  bool _isLoading = false;
  List li = [];

  @override
  void initState() {
    super.initState();
    if (widget.snap.isEmpty) {
      getData();
    } else {
      solData = widget.snap;
    }
    getProject();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var snap = await FirebaseFirestore.instance
          .collection('unGoals')
          .where('id', isEqualTo: widget.id)
          .get();
      solData = snap.docs.first.data();
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  getProject() async {
    setState(() {
      _isLoading = true;
    });
    if (solData['projects'].isNotEmpty) {
      try {
        for (var element in solData['projects']) {
          var snap = await FirebaseFirestore.instance
              .collection('unProjects')
              .where('id', isEqualTo: element)
              .get();
          li.add(snap.docs.first.data());
        }
      } catch (e) {
        showSnackBar(
          context,
          e.toString(),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  List<Widget> liPro() {
    if (_isLoading) {
      return [const Loader()];
    } else {
      if (li.isEmpty) {
        return [const Text('None listed')];
      } else {
        List<Widget> l = [];
        for (var element in li) {
          l.add(
            InkWell(
              onTap: () async {
                await launchUrl(
                  element['link'],
                );
              },
              child: Text(
                element['name'],
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  color: Pallete.blueColor,
                ),
              ),
            ),
          );
        }
        return l;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Loader()
        : Scaffold(
            appBar: AppBar(
              centerTitle: false,
              backgroundColor: Color(solData['color']),
              title: Text(
                solData['name'],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontFamily: 'OdibeeSans',
                  color: Pallete.whiteColor,
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                      Flexible(
                        flex: 2,
                        child: Container(),
                      ),
                      Center(
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 72,
                          backgroundImage: NetworkImage(solData['logo']),
                        ),
                      ),
                      const SizedBox(
                        height: 36,
                      ),
                      Center(
                        child: Text(
                          solData['description'],
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: InkWell(
                              onTap: () async {
                                await launchUrl(
                                  solData["wim"],
                                );
                              },
                              child: const Text(
                                'Why it matters',
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  color: Pallete.blueColor,
                                ),
                              ),
                            ),
                          ),
                          const Text('|'),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () async {
                                await launchUrl(
                                  solData["info"],
                                );
                              },
                              child: const Text(
                                'Infographic',
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  color: Pallete.blueColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      InkWell(
                        onTap: () async {
                          await launchUrl(
                            solData["targets"],
                          );
                        },
                        child: const Text(
                          'The United Nation targets for this goal',
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            color: Pallete.blueColor,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      const Text('EXEMPLE PROJECTS:'),
                    ] +
                    liPro() +
                    [
                      Flexible(
                        flex: 2,
                        child: Container(),
                      ),
                    ],
              ),
            ),
          );
  }
}
