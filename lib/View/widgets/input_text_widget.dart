import 'package:flutter/material.dart';

import '../../constant/validator.dart';

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
    return TextFormField(
      validator: (value) => MyValidators.displayLinkValidator(value),
      controller: textEditingController,
      decoration: InputDecoration(
        labelText: textString,
        prefixIcon: iconData != null
            ? Icon(iconData)
            : Padding(
                padding: const EdgeInsets.all(8),
                child: Image.asset(
                  assetsRef!,
                  width: 10,
                ),
              ),
        labelStyle: const TextStyle(
          fontSize: 18,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(
            color: Colors.grey,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(
            color: Colors.grey,
          ),
        ),
      ),
      obscureText: isObscure,
    );
  }
}
