import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:opale/features/constant/widgets/loader.dart';
import 'package:opale/features/un_goal/un_goal_screen.dart';
import 'package:opale/theme/pallete.dart';

class AllGoalScreen extends StatefulWidget {
  const AllGoalScreen({Key? key}) : super(key: key);

  @override
  State<AllGoalScreen> createState() => _AllGoalScreenState();
}

class _AllGoalScreenState extends State<AllGoalScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Pallete.purpleColor,
        title: Form(
          child: TextFormField(
            controller: searchController,
            style: const TextStyle(color: Pallete.whiteColor),
            decoration: const InputDecoration(
              labelText: 'Search a UN goal...',
              labelStyle: TextStyle(
                color: Pallete.whiteColor,
              ),
              icon: Icon(
                Icons.search_rounded,
                color: Pallete.redColor,
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 24,
          ),
          const Text(
            'Learn about the 17 UN goals',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontFamily: 'OdibeeSans',
              color: Pallete.redColor,
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          Expanded(
            flex: 8,
            child: FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection("unGoals")
                  .where(
                    "name",
                    isGreaterThanOrEqualTo: searchController.text,
                  )
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Loader();
                }
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      crossAxisCount: 3,
                    ),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext ctx, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => UnGoalScreen(
                                id: (snapshot.data! as dynamic).docs[index]
                                    ['id'],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color((snapshot.data! as dynamic)
                                  .docs[index]['color']),
                              border: Border.all(
                                color: Colors.transparent,
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8.0))),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image(
                              image: NetworkImage((snapshot.data! as dynamic)
                                  .docs[index]['logo']),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
