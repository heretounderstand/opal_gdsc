import 'package:flutter/material.dart';
import 'package:opale/theme/pallete.dart';

class Loader extends StatelessWidget {
  const Loader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: Pallete.pinkColor,
      ),
    );
  }
}
