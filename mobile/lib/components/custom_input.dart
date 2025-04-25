import 'package:flutter/material.dart';
import 'package:food_app/theme/colors.dart';
import 'package:food_app/utils/dimension.dart';

class CustomInput extends StatelessWidget {
  const CustomInput(
      {super.key, this.suffixIcon, this.prefixIcon, required this.placeholder, this.onSubmitted});

  final Widget? suffixIcon, prefixIcon;
  final String placeholder;
  final Function(String)? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      color: bgColor,
      child: TextField(
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(dimmension(10, context)), // Rounded border
            borderSide: const BorderSide(
              color: borderColor, // Border color
              width: 1.0, // Thin border line
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: borderColor, // Border color when enabled
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: yellowColor, // Border color when focused
              width: 1.5, // Slightly thicker border on focus
            ),
          ),
          hintText: placeholder,
          hintStyle: Theme.of(context).textTheme.displaySmall,
        ),
        onSubmitted: (value) {
          if (onSubmitted != null) {
            onSubmitted!(value);
          }
        },
      ),
    );
  }
}
