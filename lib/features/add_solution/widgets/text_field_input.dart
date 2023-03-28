import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final String hintText;
  final TextInputType textInputType;
  final Icon icon;
  final bool isLabel;
  final String label;
  const TextFieldInput({
    Key? key,
    required this.textEditingController,
    this.isPass = false,
    required this.hintText,
    required this.textInputType,
    required this.icon,
    this.isLabel = false,
    this.label = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const inputBorder = InputBorder.none;

    return TextField(
      controller: textEditingController,
      decoration: isLabel
          ? InputDecoration(
              fillColor: Colors.white,
              icon: icon,
              hintText: hintText,
              border: inputBorder,
              focusedBorder: inputBorder,
              enabledBorder: inputBorder,
              filled: true,
              contentPadding: const EdgeInsets.all(8),
              labelText: label,
            )
          : InputDecoration(
              fillColor: Colors.white,
              icon: icon,
              hintText: hintText,
              border: inputBorder,
              focusedBorder: inputBorder,
              enabledBorder: inputBorder,
              filled: true,
              contentPadding: const EdgeInsets.all(8),
            ),
      keyboardType: textInputType,
      obscureText: isPass,
      maxLines: 5,
      minLines: 1,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    );
  }
}
