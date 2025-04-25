import 'package:flutter/material.dart';
import 'package:food_app/theme/colors.dart';
import 'package:food_app/utils/dimension.dart';

class CustomTextForm extends StatelessWidget {
  const CustomTextForm(
      {super.key, required this.controller, required this.placeholder, this.inputType});

  final String placeholder;
  final TextEditingController controller;
  final TextInputType? inputType;

  OutlineInputBorder borderStyle(BuildContext context) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: borderColor.withOpacity(0.5), width: 1),
      borderRadius: BorderRadius.circular(dimmension(10, context)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      textAlign: TextAlign.right,
      keyboardType: inputType,
      textAlignVertical: TextAlignVertical.center,
      textDirection: TextDirection.rtl,
      decoration: InputDecoration(
        alignLabelWithHint: true,
        hintText: placeholder,
        hintStyle: Theme.of(context).textTheme.displaySmall!.copyWith(fontWeight: FontWeight.w400),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: yellowColor, width: 1.0),
          borderRadius: BorderRadius.circular(dimmension(10, context)),
        ),
        enabledBorder: borderStyle(context),
      ),
    );
  }
}
