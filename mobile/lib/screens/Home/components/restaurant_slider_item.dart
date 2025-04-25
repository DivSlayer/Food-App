import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_app/main.dart';
import 'package:food_app/models/address.dart';
import 'package:food_app/models/restaurant.dart';
import 'package:food_app/screens/Restaurant/restaurant_screen.dart';
import 'package:food_app/services/account_service.dart';
import 'package:food_app/theme/colors.dart';
import 'package:food_app/utils/dimension.dart';
import 'package:food_app/utils/funcs.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class RestaurantSliderItem extends StatefulWidget {
  const RestaurantSliderItem({
    super.key,
    required this.current,
    required this.index,
    required this.restaurant,
  });

  final RestaurantModel restaurant;
  final double current;
  final int index;

  @override
  State<RestaurantSliderItem> createState() => _RestaurantSliderItemState();
}

class _RestaurantSliderItemState extends State<RestaurantSliderItem> {
  String? distance;

  @override
  void initState() {
    super.initState();
    AccountService accountService = getAccountService();
    AddressModel address = accountService.activeAddress!;
    double newDis = double.infinity;
    AddressModel? selectedAddress;

    for (var resAddress in widget.restaurant.addresses) {
      double calDis = calculateDistance(
        firstCord: LatLng(double.parse(address.latitude), double.parse(address.longitude)),
        secondCord: LatLng(double.parse(resAddress.latitude), double.parse(resAddress.longitude)),
        stringed: false,
      );
      if (selectedAddress == null || calDis < newDis) {
        newDis = calDis;
        selectedAddress = resAddress;
      }
    }
    setState(() {
      distance = calculateDistance(
        firstCord: LatLng(double.parse(address.latitude), double.parse(address.longitude)),
        secondCord: LatLng(
            double.parse(selectedAddress!.latitude), double.parse(selectedAddress.longitude)),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    double opacity = 0.5;
    if (widget.index.toDouble() < widget.current) {
      opacity = 1 - ((widget.current - widget.index) / 2);
    } else if (widget.index.toDouble() == widget.current) {
      opacity = 1;
    } else if (widget.index.toDouble() > widget.current) {
      opacity = 1 - ((widget.index - widget.current) / 2);
    }
    double scale = 1;
    if (widget.index.toDouble() < widget.current) {
      scale = 1 - ((widget.current - widget.index) / 12);
    } else if (widget.index.toDouble() == widget.current) {
      scale = 1;
    } else if (widget.index.toDouble() > widget.current) {
      scale = 1 - ((widget.index - widget.current) / 12);
    }
    return AnimatedScale(
      duration: const Duration(microseconds: 300),
      scale: scale,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 0),
        opacity: opacity.toDouble(),
        child: GestureDetector(
          onTap: () => Get.toNamed('restaurant', arguments: {'uuid': widget.restaurant.uuid}),
          child: Container(
            width: (MediaQuery.of(context).size.width - dimmension(40, context)) / 2,
            height: dimmension(300, context),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(dimmension(15, context)),
              color: bgColor,
              boxShadow: [
                BoxShadow(
                    color: borderColor.withOpacity(0.5),
                    offset: const Offset(7, 7),
                    blurRadius: dimmension(5, context))
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildHeader(context),
                SizedBox(height: dimmension(50, context)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: dimmension(10, context)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: dimmension(30, context),
                            padding: EdgeInsets.symmetric(horizontal: dimmension(5, context)),
                            decoration: BoxDecoration(
                              color: lightBgColor,
                              borderRadius: BorderRadius.circular(dimmension(30, context)),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.star,
                                  color: yellowColor,
                                  size: dimmension(20, context),
                                ),
                                SizedBox(width: dimmension(3, context)),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '4.2',
                                        style: Theme.of(context).textTheme.displayMedium!.copyWith(
                                            fontFamily: 'Poppins', fontWeight: FontWeight.w600),
                                      ),
                                      TextSpan(
                                        text: ' (721)',
                                        style: Theme.of(context).textTheme.displaySmall!.copyWith(
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500,
                                              fontSize: dimmension(12, context),
                                            ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                widget.restaurant.name,
                                style: Theme.of(context).textTheme.displayLarge,
                              ),
                              SizedBox(height: dimmension(15, context)),
                              Text(
                                'غذای سنتی، کباب کوبیده',
                                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                                      color: lightTextColor,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: dimmension(20, context)),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'ارسال رایگان',
                                style: Theme.of(context).textTheme.displaySmall,
                              ),
                              SizedBox(width: dimmension(5, context)),
                              SvgPicture.asset(
                                'assets/icons/moped-solid.svg',
                                height: dimmension(17, context),
                                color: yellowColor,
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                distance ?? "",
                                textDirection: TextDirection.rtl,
                                style: Theme.of(context).textTheme.displaySmall,
                              ),
                              SizedBox(width: dimmension(5, context)),
                              Icon(
                                Icons.navigation_rounded,
                                color: yellowColor,
                                size: dimmension(20, context),
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SizedBox _buildHeader(BuildContext context) {
    return SizedBox(
      height: dimmension(170, context),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: dimmension(170, context),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(dimmension(15, context)).copyWith(
                bottomLeft: Radius.zero,
                bottomRight: Radius.zero,
              ),
              image: const DecorationImage(
                image: AssetImage('assets/images/food_pic.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: dimmension(-30, context),
            right: dimmension(20, context),
            child: Container(
              height: dimmension(60, context),
              width: dimmension(60, context),
              padding: EdgeInsets.all(dimmension(10, context)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(dimmension(5, context)),
                color: lightBgColor,
                boxShadow: [
                  BoxShadow(
                      color: borderColor.withOpacity(0.5),
                      offset: const Offset(3, 12),
                      blurRadius: dimmension(5, context))
                ],
              ),
              child: Image.asset("assets/images/res_logo.png"),
            ),
          ),
        ],
      ),
    );
  }
}
