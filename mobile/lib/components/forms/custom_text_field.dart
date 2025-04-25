import 'package:flutter/material.dart';
import 'package:food_app/theme/colors.dart';
import 'package:food_app/utils/dimension.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    this.placeholder,
    this.prefixIcon,
    this.textAlign,
    this.keyboardType,
    this.obscureText = false,
    this.enableSuggestions = false,
    this.autocorrect = false,
    this.controller,
    required this.onChange,
    this.bgColor,
    this.collapsed = false,
    this.onSubmitted,
    this.textDirection,
    this.activeBorderColor,
    this.deactiveBorderColor,
  });

  final String? placeholder;
  final Widget? prefixIcon;
  final TextAlign? textAlign;
  final TextInputType? keyboardType;
  final bool obscureText, enableSuggestions, autocorrect;
  final TextEditingController? controller;
  final VoidCallback onChange;
  final Color? bgColor, activeBorderColor, deactiveBorderColor;
  final bool collapsed;
  final void Function(String)? onSubmitted;
  final TextDirection? textDirection;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.bgColor ?? lightBgColor,
        borderRadius: BorderRadius.circular(dimmension(15, context)),
      ),
      child: TextField(
        onSubmitted: (String value) {
          if (widget.onSubmitted != null) {
            widget.onSubmitted!(value);
          }
        },
        controller: widget.controller,
        textAlign: widget.textAlign ?? TextAlign.center,
        textAlignVertical: TextAlignVertical.center,
        maxLines: widget.collapsed ? 4 : 1,
        cursorColor: textColor,
        keyboardType: widget.keyboardType ?? TextInputType.text,
        obscureText: widget.obscureText,
        enableSuggestions: widget.enableSuggestions,
        autocorrect: widget.autocorrect,
        textDirection: widget.textDirection,
        onChanged: (value) {
          widget.onChange();
        },
        style: Theme.of(context).textTheme.displayMedium,
        decoration: InputDecoration(
          border: borderDesign(),
          focusedBorder: activeBorder(),
          disabledBorder: borderDesign(),
          enabledBorder: borderDesign(),
          hintText: widget.placeholder ?? '',
          isCollapsed: widget.collapsed,
          // filled: true,
          hintStyle: Theme.of(context).textTheme.displaySmall,
          contentPadding: EdgeInsets.symmetric(
            vertical: dimmension(20, context),
            horizontal: dimmension(20, context),
          ),
          prefixIcon: widget.prefixIcon,
          hintTextDirection: widget.textDirection,
        ),
      ),
    );
  }

  OutlineInputBorder borderDesign() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(dimmension(15, context)),
      borderSide: BorderSide(
        width: 1,
        color: widget.deactiveBorderColor ?? lightBgColor,
      ),
    );
  }

  OutlineInputBorder activeBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(dimmension(15, context)),
      borderSide: BorderSide(
        width: 1,
        color: widget.activeBorderColor ?? yellowColor,
      ),
    );
  }
}
