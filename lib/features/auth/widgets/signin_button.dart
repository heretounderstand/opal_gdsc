import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:opale/features/auth/ressources/auth_methods.dart';
import 'package:opale/features/constant/ressources/snackbar.dart';
import 'package:opale/features/constant/widgets/loader.dart';
import 'package:opale/terms/privacy_policy.dart';
import 'package:opale/terms/term.dart';
import 'package:opale/theme/assets.dart';
import 'package:opale/theme/pallete.dart';

class SignInButton extends StatefulWidget {
  const SignInButton({Key? key}) : super(key: key);

  @override
  State<SignInButton> createState() => _SignInButtonState();
}

class _SignInButtonState extends State<SignInButton> {
  bool agreed = false;
  bool isLoading = false;

  Future<void> signInWithGoogle() async {
    setState(() {
      isLoading = true;
    });
    String res = await AuthMethods().signInUser();
    if (res == "success") {
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      // show the error
      showSnackBar(context, res);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return agreed
        ? !isLoading
            ? Padding(
                padding: const EdgeInsets.all(18.0),
                child: ElevatedButton.icon(
                  onPressed: () => signInWithGoogle(),
                  icon: Image.asset(
                    Assets.googlePath,
                    width: 35,
                  ),
                  label: const Text(
                    'Continue with Google',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Pallete.greyColor,
                    minimumSize: Size(width * 0.5, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              )
            : const Loader()
        : Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  checkColor: Pallete.whiteColor,
                  activeColor: Pallete.pinkColor,
                  value: agreed,
                  onChanged: (bool? value) {
                    setState(() {
                      agreed = value!;
                    });
                  },
                ),
                Expanded(
                  child: RichText(
                    overflow: TextOverflow.clip,
                    textAlign: TextAlign.justify,
                    softWrap: true,
                    maxLines: 6,
                    textScaleFactor: 1,
                    text: TextSpan(
                      text: "I accept the ",
                      style: DefaultTextStyle.of(context).style.copyWith(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Macondo',
                          color: Pallete.whiteColor),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Terms of Use ',
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const Term(),
                                  ),
                                ),
                          style: const TextStyle(
                            color: Pallete.yellowColor,
                            fontSize: 17,
                          ),
                        ),
                        const TextSpan(
                            text:
                                'and understand that the processing of my personal data will be subject the '),
                        TextSpan(
                          text: 'Privacy Policy.',
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const Privacy(),
                                  ),
                                ),
                          style: const TextStyle(
                            color: Pallete.yellowColor,
                            fontSize: 17,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
