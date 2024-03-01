import 'package:flutter/material.dart';

class InputTextWidget extends StatelessWidget {
  const InputTextWidget({
    super.key,
    required this.textEditingController,
    this.iconData,
    this.assetsRef,
    required this.textString,
    required this.isObscure,
  });

  final TextEditingController textEditingController;
  final IconData? iconData;
  final String? assetsRef;
  final String textString;
  final bool isObscure;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
