import 'package:flutter/material.dart';
import 'package:opale/features/auth/widgets/signin_button.dart';
import 'package:opale/theme/assets.dart';
import 'package:opale/theme/pallete.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Pallete.redColor,
              Pallete.pinkColor,
              Pallete.blueColor,
              Pallete.purpleColor,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              flex: 3,
              child: Container(),
            ),
            const Text(
              "Opale",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 64,
                fontFamily: 'Lobster',
                color: Pallete.whiteColor,
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            Container(
                height: 150,
                margin: const EdgeInsets.all(16.0),
                decoration: const BoxDecoration(
                    color: Colors.transparent,
                    image: DecorationImage(
                      image: AssetImage(Assets.logoPath),
                    ),
                    shape: BoxShape.circle)),
            const Text(
              "Everyone can make a difference",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                color: Pallete.whiteColor,
                fontFamily: 'OdibeeSans',
              ),
            ),
            const SizedBox(
              height: 48,
            ),
            const SignInButton(),
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
