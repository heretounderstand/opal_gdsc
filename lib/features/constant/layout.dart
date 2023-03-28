import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:opale/features/add_solution/add_solution_screen.dart';
import 'package:opale/features/auth/ressources/auth_methods.dart';
import 'package:opale/features/auth/ressources/user_provider.dart';
import 'package:opale/features/constant/ressources/snackbar.dart';
import 'package:opale/features/constant/widgets/loader.dart';
import 'package:opale/features/feed/feed_screen.dart';
import 'package:opale/features/feed/map_screen.dart';
import 'package:opale/features/profile/profile_screen.dart';
import 'package:opale/features/un_goal/all_goal_screen.dart';
import 'package:opale/features/un_goal/un_goal_screen.dart';
import 'package:opale/terms/privacy_policy.dart';
import 'package:opale/terms/term.dart';
import 'package:opale/theme/assets.dart';
import 'package:opale/theme/pallete.dart';
import 'package:provider/provider.dart';

class Layout extends StatefulWidget {
  const Layout({Key? key}) : super(key: key);

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User currentUser;
  late PageController pageController;
  int _page = 0;
  int goal = 17;
  bool isLoading = false;
  List solData = [];

  List<PopupMenuItem> goalList() {
    List<PopupMenuItem> lis = [];
    for (int i = 0; i < 18; i++) {
      lis.add(PopupMenuItem(
          value: i,
          onTap: () {
            setState(() {
              goal = i;
            });
          },
          child: goalButton(i)));
    }
    return lis;
  }

  Widget goalButton(int num) => Row(
        children: [
          InkWell(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => num == 17
                    ? const AllGoalScreen()
                    : UnGoalScreen(
                        id: solData[num]['id'],
                      ),
              ),
            ),
            child: CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(
                num == 17 ? Assets.bannerDefault : solData[num]['logo'],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 8,
            ),
            child: Text(
              num == 17 ? 'All' : solData[num]['name'],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'OdibeeSans',
                color: num == 17
                    ? Pallete.blackColor
                    : Color(solData[num]['color']),
              ),
            ),
          ),
        ],
      );

  @override
  void initState() {
    super.initState();
    addData();
    getData();
    pageController = PageController();
    currentUser = _auth.currentUser!;
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
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

  addData() async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    await userProvider.refreshUser();
  }

  signOut() async {
    await AuthMethods().signOut();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    //Animating Page
    setState(() {
      isLoading = true;
      pageController.animateToPage(page,
          duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            goal != 17 ? Color(solData[goal]['color']) : Pallete.purpleColor,
        centerTitle: false,
        title: Row(
          children: [
            const Text(
              "Opale",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'Lobster',
                  color: Pallete.whiteColor),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => goal == 17
                            ? const AllGoalScreen()
                            : UnGoalScreen(
                                id: solData[goal]['id'],
                                snap: solData[goal],
                              ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 8,
                      ),
                      child: Text(
                        goal == 17 ? 'All' : solData[goal]['name'],
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'OdibeeSans',
                            fontSize: 14,
                            color: Pallete.whiteColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => goalList(),
            icon: const Icon(
              Icons.more_vert_rounded,
              color: Pallete.whiteColor,
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Loader()
          : PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: pageController,
              onPageChanged: onPageChanged,
              children: [
                FeedScreen(
                  goal: goal == 17 ? '' : solData[goal]['id'],
                ),
                MapScreen(
                  goal: goal == 17 ? '' : solData[goal]['id'],
                ),
              ],
            ),
      drawer: Drawer(
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: ElevatedButton(
                  onPressed: () => signOut(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: goal == 17
                        ? Pallete.purpleColor
                        : Color(solData[goal]['color']),
                  ),
                  child: const Text(
                    "Sign out",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Pallete.whiteColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              InkWell(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(uid: currentUser.uid),
                  ),
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 36,
                  backgroundImage: NetworkImage(currentUser.photoURL!),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              Text(
                currentUser.displayName!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Macondo',
                ),
              ),
              const SizedBox(
                height: 34,
              ),
              Flexible(flex: 2, child: Container()),
              const Divider(),
              const SizedBox(
                height: 18,
              ),
              InkWell(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const Privacy(),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.policy_rounded,
                      color: goal == 17
                          ? Pallete.purpleColor
                          : Color(solData[goal]['color']),
                    ),
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 8,
                        ),
                        child: Text(
                          'Privacy Policy',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Macondo',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              const Divider(),
              const SizedBox(
                height: 18,
              ),
              InkWell(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const Term(),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.my_library_books_rounded,
                      color: goal == 17
                          ? Pallete.purpleColor
                          : Color(solData[goal]['color']),
                    ),
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 8,
                        ),
                        child: Text(
                          'Terms of use',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Macondo',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              const Divider(),
              const SizedBox(
                height: 18,
              ),
              FloatingActionButton.extended(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AddSolutionScreen(),
                  ),
                ),
                label: const Text(
                  'Add your solution',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                icon: const Icon(
                  Icons.add_circle_rounded,
                  color: Colors.white,
                ),
                backgroundColor: goal == 17
                    ? Pallete.purpleColor
                    : Color(solData[goal]['color']),
              ),
              Flexible(flex: 1, child: Container()),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor:
            goal != 17 ? Color(solData[goal]['color']) : Pallete.purpleColor,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_rounded,
              color: (_page == 0) ? Pallete.whiteColor : Colors.grey,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.map_rounded,
              color: (_page == 1) ? Pallete.whiteColor : Colors.grey,
            ),
          ),
        ],
        onTap: navigationTapped,
        currentIndex: _page,
      ),
    );
  }
}
