import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_app/main.dart';
import 'package:food_app/models/nav_model.dart';
import 'package:food_app/services/db.dart';
import 'package:food_app/services/favorite_service.dart';
import 'package:food_app/services/order_service.dart';
import 'package:food_app/theme/colors.dart';
import 'package:food_app/utils/dimension.dart';
import 'package:provider/provider.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key, required this.onTap});

  final Function(int) onTap;

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  final DatabaseService _databaseService = DatabaseService();
  final OrderService _orderService = getOrderService();
  final FavoriteService _favoriteService = getFavoriteService();
  int orderCount = 0;
  int favCount = 0;

  List<NavModel> navs = [];
  int currentNav = 0;

  initiate() async {
    await _orderService.loadOrders();
    await _favoriteService.getFoods();
  }

  @override
  void initState() {
    super.initState();
    initiate();
    setState(() {
      navs = [
        NavModel(title: 'خانه', icon: "assets/icons/home-regular.svg"),
        NavModel(
          title: 'سبد خرید',
          icon: "assets/icons/shopping-cart-regular.svg",
          hasNotif: true,
          notifCount: orderCount,
        ),
        NavModel(
          title: 'علاقمندی ها',
          icon: "assets/icons/heart-regular.svg",
          hasNotif: true,
          notifCount: favCount,
        ),
        NavModel(title: 'پروفایل', icon: "assets/icons/user-regular.svg"),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    final OrderService orderService = Provider.of<OrderService>(context);
    final FavoriteService favoriteService = Provider.of<FavoriteService>(context);
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: dimmension(80, context),
        decoration: BoxDecoration(color: bgColor, boxShadow: [
          BoxShadow(
            color: borderColor.withOpacity(0.5),
            offset: const Offset(0, -5),
            blurRadius: dimmension(10, context),
          )
        ]),
        child: Container(
          margin: EdgeInsets.only(top: dimmension(15, context)),
          padding: EdgeInsets.symmetric(horizontal: dimmension(30, context)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              navs.length,
              (index) => InkWell(
                onTap: () {
                  setState(() {
                    currentNav = index;
                  });
                  widget.onTap(index);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: dimmension(24, context),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          SvgPicture.asset(
                            navs[index].icon,
                            height: dimmension(20, context),
                            color: index == currentNav ? yellowColor : lightTextColor,
                          ),
                          navs[index].hasNotif
                              ? Positioned(
                                  right: dimmension(-5, context),
                                  top: dimmension(-5, context),
                                  child: Container(
                                    width: dimmension(15, context),
                                    height: dimmension(15, context),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: yellowColor,
                                        border: Border.all(
                                          width: 1,
                                          color: bgColor,
                                        )),
                                    child: Text(
                                      index == 1
                                          ? orderService.orders.length.toString()
                                          : favoriteService.favoriteList.length.toString(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        color: Colors.white,
                                        fontSize: dimmension(10, context),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                    SizedBox(height: dimmension(10, context)),
                    Text(
                      navs[index].title,
                      style: Theme.of(context).textTheme.displayMedium!.copyWith(
                            color: index == currentNav ? yellowColor : lightTextColor,
                            fontSize: dimmension(12, context),
                            fontWeight: FontWeight.w400,
                          ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
