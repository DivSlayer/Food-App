import 'package:flutter/material.dart';
import 'package:food_app/models/food.dart';
import 'package:food_app/theme/colors.dart';
import 'package:food_app/utils/dimension.dart';

class ListNavigator extends StatefulWidget {
  const ListNavigator({
    super.key,
    required this.navKey,
    this.onTap,
    this.currentNav = 0,
    required this.scrollPosition,
    required this.scrollWidth,
    required this.onBind,
    this.onTapDown,
    required this.cats,
  });

  final GlobalKey navKey;
  final Function(int)? onTap;
  final Function(double, double)? onTapDown;
  final int currentNav;
  final double scrollPosition; // New parameter
  final double scrollWidth;
  final Function(double) onBind;
  final Map<String, List<FoodModel>> cats;

  @override
  State<ListNavigator> createState() => _ListNavigatorState();
}

class _ListNavigatorState extends State<ListNavigator> {
  final List<double> itemWidths = [];
  final List<GlobalKey> itemKeys = [];

  @override
  void initState() {
    super.initState();
    // Create keys for each item
    for (var item in widget.cats.keys) {
      itemKeys.add(GlobalKey());
    }

    // Add a post-frame callback to measure widths
    WidgetsBinding.instance.addPostFrameCallback((_) {
      measureItemWidths();
    });
  }

  void measureItemWidths() {
    for (int i = 0; i < itemKeys.length; i++) {
      final renderBox = itemKeys[i].currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        setState(() {
          if (i == 0) {
            widget.onBind(renderBox.size.width - dimmension(50, context));
          }
          itemWidths.add(renderBox.size.width);
        });
      }
    }
  }

  double _getItemPosition(GlobalKey keyForItem) {
    final renderBox = keyForItem.currentContext?.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    // You can also get the position relative to the screen:
    final positionX = offset.dx;
    final positionY = offset.dy;
    // If you need the position relative to the ListView:
    final listViewOffset = context.findRenderObject()?.getTransformTo(null).getTranslation();
    final relativeX = positionX - listViewOffset!.x;
    final relativeY = positionY - listViewOffset.y;
    return relativeX;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      key: widget.navKey,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(
          width: size.width,
          height: dimmension(30, context),
          child: ListView.builder(
            reverse: true,
            scrollDirection: Axis.horizontal,
            itemCount: widget.cats.keys.length,
            itemBuilder: (context, index) {
              String key = widget.cats.keys.toList()[index];
              return GestureDetector(
                onTap: () {
                  if (widget.onTap != null) {
                    widget.onTap!(index);
                  }
                },
                onTapDown: (TapDownDetails details) {
                  RenderBox renderBox =
                      itemKeys[index].currentContext?.findRenderObject() as RenderBox;
                  double width = renderBox.size.width;
                  double position = index == 0
                      ? size.width - dimmension(20, context)
                      : _getItemPosition(itemKeys[index - 1]);
                  double scrollPosition = size.width - position;
                  if (index == 0) {
                    width = width - dimmension(50, context);
                  } else if (index != widget.cats.keys.length - 1) {
                    width = width - dimmension(30, context);
                  } else {
                    width = width - dimmension(20, context);
                  }
                  double scrollWidth = width;
                  if (widget.onTapDown != null) {
                    widget.onTapDown!(scrollWidth, scrollPosition);
                  }
                },
                child: Container(
                  key: itemKeys[index],
                  margin: EdgeInsets.only(
                    right: index == 0 ? dimmension(20, context) : 0,
                    left: index == widget.cats.keys.length - 1
                        ? dimmension(20, context)
                        : dimmension(30, context),
                  ),
                  child: Text(
                    key,
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(
          height: dimmension(20, context),
          width: size.width,
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                right: widget.scrollPosition,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  height: dimmension(5, context),
                  width: widget.scrollWidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(dimmension(20, context)),
                    color: yellowColor,
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
