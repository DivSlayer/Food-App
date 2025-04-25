import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_app/theme/colors.dart';
import 'package:food_app/utils/dimension.dart';

class NumberCounter extends StatefulWidget {
  const NumberCounter({
    super.key,
    required this.currentNumbers,
    required this.onAdd,
    required this.onMinus,
  });

  final int currentNumbers;
  final Function() onAdd;
  final Function() onMinus;

  @override
  State<NumberCounter> createState() => _NumberCounterState();
}

class _NumberCounterState extends State<NumberCounter> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            widget.currentNumbers != 0
                ? IconButton(
                    icon: Icon(
                      CupertinoIcons.minus_circle,
                      color: lightTextColor,
                      size: dimmension(25, context),
                    ),
                    onPressed: () {
                      widget.onMinus();
                    },
                    padding: EdgeInsets.zero,
                  )
                : Container(),
            widget.currentNumbers != 0
                ? Container(
                    margin: EdgeInsets.only(
                      left: widget.currentNumbers == 0 ? 0 : dimmension(0, context),
                    ),
                    child: Text(
                      "${widget.currentNumbers}",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displayMedium!.copyWith(
                            fontFamily: 'Poppins',
                          ),
                    ),
                  )
                : Container(),
            Container(
              margin: EdgeInsets.only(
                left: widget.currentNumbers == 0 ? 0 : dimmension(0, context),
              ),
              child: IconButton(
                icon: Icon(
                  Icons.add_circle_rounded,
                  color: yellowColor,
                  size: dimmension(25, context),
                ),
                onPressed: () {
                  widget.onAdd();
                },
                padding: EdgeInsets.zero,
              ),
            ),
          ],
        )
      ],
    );
  }
}
