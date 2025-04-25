import 'package:flutter/material.dart';
import 'package:food_app/theme/colors.dart';
import 'package:food_app/utils/dimension.dart';

class RatingWidget extends StatelessWidget {
  final double rating;
  final ValueChanged<double> onRatingChanged;

  const RatingWidget({super.key, required this.rating, required this.onRatingChanged});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery
          .of(context)
          .size
          .width * 0.5,
      child: GestureDetector(
        onPanUpdate: (details) {
          RenderBox box = context.findRenderObject() as RenderBox;
          var localPosition = box.globalToLocal(details.globalPosition);
          var newRating = (localPosition.dx / box.size.width) * 5;
          newRating = (newRating * 2).round() / 2; // Round to nearest 0.5
          if (newRating > 5) newRating = 5;
          if (newRating < 0) newRating = 0;
          onRatingChanged(newRating);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(5, (index) {
            IconData icon;
            if (index + 1 <= rating) {
              icon = Icons.star_rounded;
            } else if (index + 0.5 <= rating) {
              icon = Icons.star_half_rounded;
            } else {
              icon = Icons.star_border_rounded;
            }
            return GestureDetector(
              onTap: () {
                onRatingChanged(index + 1);
              },
              child: Icon(
                icon,
                color: yellowColor,
                size: dimmension(40, context),
              ),
            );
          }),
        ),
      ),
    );
  }
}
