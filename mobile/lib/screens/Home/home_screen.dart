import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_app/components/custom_input.dart';
import 'package:food_app/main.dart';
import 'package:food_app/screens/Home/components/banner_widget.dart';
import 'package:food_app/screens/Home/components/bottom_navigation.dart';
import 'package:food_app/screens/Home/components/restaurants_slider.dart';
import 'package:food_app/screens/Home/pages/favorite_page.dart';
import 'package:food_app/screens/Home/pages/home_page.dart';
import 'package:food_app/screens/Home/pages/order_page.dart';
import 'package:food_app/screens/Home/pages/profile_page.dart';
import 'package:food_app/services/transaction_service.dart';
import 'package:food_app/theme/colors.dart';
import 'package:food_app/utils/dimension.dart';
import 'package:get/get.dart';
import 'components/categories_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> pages = [
    const HomePage(),
    const OrderPage(),
    const FavoritePage(),
    const ProfilePage(),
  ];
  int currentNav = 0;
@override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        toolbarHeight: 0,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: pages[currentNav],
          ),
          BottomNavigation(
            onTap: (int index) {
              setState(() {
                currentNav = index;
              });
            },
          ),
        ],
      ),
    );
  }
}
