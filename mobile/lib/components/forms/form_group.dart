import 'package:flutter/material.dart';
import 'package:food_app/theme/colors.dart';
import 'package:food_app/utils/dimension.dart';

class FormGroup extends StatefulWidget {
  const FormGroup({
    super.key,
    this.label,
    required this.input,
    this.error,
    this.helpText,
    this.helpWidget,
    this.helpColor,
  });

  final Widget input;
  final String? label;
  final String? error;
  final String? helpText;
  final Widget? helpWidget;
  final Color? helpColor;

  @override
  State<FormGroup> createState() => _FormGroupState();
}

class _FormGroupState extends State<FormGroup> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        widget.label != null
            ? Container(
                margin: EdgeInsets.only(bottom: dimmension(15, context)),
                padding: EdgeInsets.only(right: dimmension(5, context)),
                child: Text(
                  widget.label!,
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      color: lightTextColor,
                      fontWeight: FontWeight.w500,
                      fontSize: dimmension(15, context)),
                ),
              )
            : Container(),
        widget.input,
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: widget.helpText == null ? 0 : dimmension(20, context),
          padding: widget.helpText == null
              ? EdgeInsets.zero
              : EdgeInsets.only(right: dimmension(5, context)),
          margin: widget.helpText == null
              ? EdgeInsets.zero
              : EdgeInsets.only(top: dimmension(5, context)),
          child: Text(
            widget.helpText ?? '',
            textDirection: TextDirection.rtl,
            style: TextStyle(
              color: lightTextColor,
              fontSize: dimmension(12, context),
            ),
          ),
        ),
        widget.helpWidget ?? Container(),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: widget.error == null ? 0 : dimmension(20, context),
          margin:
              widget.error == null ? EdgeInsets.zero : EdgeInsets.only(top: dimmension(5, context)),
          padding: widget.error == null
              ? EdgeInsets.zero
              : EdgeInsets.only(right: dimmension(5, context)),
          child: Text(
            widget.error ?? '',
            textDirection: TextDirection.rtl,
            style: TextStyle(
              color: redColor,
              fontSize: dimmension(12, context),
            ),
          ),
        ),
      ],
    );
  }
}
