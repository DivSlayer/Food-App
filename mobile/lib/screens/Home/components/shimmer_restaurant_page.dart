import 'package:flutter/material.dart';
import 'package:food_app/screens/Home/components/shimmer_restaurant_item.dart';

class ShimmerRestaurantPage extends StatefulWidget {
  const ShimmerRestaurantPage({super.key});

  @override
  State<ShimmerRestaurantPage> createState() => _ShimmerRestaurantPageState();
}

class _ShimmerRestaurantPageState extends State<ShimmerRestaurantPage> {
  final PageController _pageController = PageController(
    viewportFraction: 0.90,
    initialPage: 0,
  );
  var _currentPageValue = 0.0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPageValue = _pageController.page!;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      clipBehavior: Clip.none,
      itemCount: 5,
      reverse: true,
      controller: _pageController,
      itemBuilder: (context, index) => ShimmerRestaurantItem(
        current: _currentPageValue,
        index: index,
      ),
    );
  }
}
