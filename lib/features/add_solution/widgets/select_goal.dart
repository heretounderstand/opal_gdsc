import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:opale/features/constant/ressources/snackbar.dart';
import 'package:opale/features/constant/widgets/loader.dart';
import 'package:opale/theme/pallete.dart';

class SelectGoal extends StatefulWidget {
  final ValueChanged<List> check;
  const SelectGoal({Key? key, required this.check}) : super(key: key);

  @override
  State<SelectGoal> createState() => _SelectGoalState();
}

class _SelectGoalState extends State<SelectGoal> {
  int type = 0;
  bool isLoading = true;
  late List solData;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var snap = await FirebaseFirestore.instance
          .collection('unGoals')
          .orderBy('rank')
          .get();
      solData = snap.docs;
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

  Widget switchType(int page) => InkWell(
        onTap: () {
          setState(() {
            type = page;
          });
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Color(solData[page]['color']),
              border: Border.all(
                color: Colors.transparent,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(8.0))),
          child: page == type
              ? const Icon(
                  Icons.check_rounded,
                  color: Pallete.whiteColor,
                  size: 48,
                )
              : Image.network(
                  solData[page]['logo'],
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Loader()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 36,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    solData[type]['name'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: Color(solData[type]['color']),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'OdibeeSans'),
                  ),
                  const SizedBox(
                    width: 24,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        setState(() {
                          widget.check([
                            solData[type]['id'],
                            solData[type]['name'],
                            solData[type]['logo'],
                            solData[type]['color']
                          ]);
                        });
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(solData[type]['color']),
                    ),
                    child: const Text(
                      "Next",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Pallete.whiteColor,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 72,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        crossAxisCount: 3,
                      ),
                      itemCount: solData.length,
                      itemBuilder: (BuildContext ctx, index) {
                        return switchType(index);
                      }),
                ),
              ),
            ],
          );
  }
}
