import 'package:flutter/material.dart';
import 'package:opale/theme/assets.dart';
import 'package:opale/theme/pallete.dart';

class ErrorMessage extends StatelessWidget {
  final String mess;
  const ErrorMessage({Key? key, required this.mess}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Image.asset(
            Assets.errorPath,
            height: 200,
          ),
        ),
        const SizedBox(
          height: 36,
        ),
        Center(
          child: Text(
            mess,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Pallete.blueColor,
            ),
          ),
        ),
      ],
    );
  }
}
