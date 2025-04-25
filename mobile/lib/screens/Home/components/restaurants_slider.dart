import 'package:flutter/material.dart';
import 'package:food_app/blocs/restaurants_bloc.dart';
import 'package:food_app/main.dart';
import 'package:food_app/models/restaurant.dart';
import 'package:food_app/screens/Home/components/restaurant_slider_item.dart';
import 'package:food_app/screens/Home/components/shimmer_restaurant_page.dart';
import 'package:food_app/services/account_service.dart';
import 'package:food_app/services/db.dart';
import 'package:food_app/theme/colors.dart';
import 'package:food_app/utils/dimension.dart';

class RestaurantsSlider extends StatefulWidget {
  const RestaurantsSlider({super.key, required this.bloc});

  final RestaurantBloc? bloc;

  @override
  State<RestaurantsSlider> createState() => _RestaurantsSliderState();
}

class _RestaurantsSliderState extends State<RestaurantsSlider> {
  final RestaurantBloc _restaurantBloc = RestaurantBloc();
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
    AccountService account = getAccountService();
    if (account.activeAddress != null) {
      widget.bloc?.getCloseRestaurants(account.activeAddress!);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AccountService accountService = getAccountService();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: ()async{
            DatabaseService db = DatabaseService();
            Map<String,dynamic>? account = await db.getAccount();
            print(account);
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: dimmension(20, context)),
            child: Text(
              "رستوران های نزدیک شما",
              style: Theme.of(context).textTheme.displayLarge,
            ),
          ),
        ),
        SizedBox(height: dimmension(20, context)),
        SizedBox(
          height: dimmension(350, context),
          width: MediaQuery.of(context).size.width,
          child: accountService.activeAddress != null
              ? StreamBuilder(
                  stream:widget.bloc?.subject.stream,
                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.error != null) {
                        if ((snapshot.data.restaurants as List).isEmpty) {
                          return _buildNoItem(context);
                        } else {
                          return _buildResSlider(snapshot.data.restaurants);
                        }
                      }
                      if ((snapshot.data.restaurants as List).isEmpty) {
                        return _buildNoItem(context);
                      } else {
                        return _buildResSlider(snapshot.data.restaurants);
                      }
                    } else if (snapshot.hasError) {
                      return _buildNoItem(context);
                    } else {
                      return const ShimmerRestaurantPage();
                    }
                  })
              : Center(
                  child: Text(
                    'ابتدا آدرس خود را وارد کنید!',
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                          color: lightTextColor,
                        ),
                  ),
                ),
        )
      ],
    );
  }

  PageView _buildResSlider(List<RestaurantModel> restaurants) {
    return PageView.builder(
      clipBehavior: Clip.none,
      itemCount: restaurants.length,
      reverse: true,
      controller: _pageController,
      itemBuilder: (context, index) => RestaurantSliderItem(
        current: _currentPageValue,
        index: index,
        restaurant: restaurants[index],
      ),
    );
  }

  Widget _buildNoItem(context, {String? error}) {
    return Center(
      child: Text(
        'رستورانی وجود ندارد! ',
        textAlign: TextAlign.center,
        textDirection: TextDirection.rtl,
        style: Theme.of(context).textTheme.displayMedium!.copyWith(
              color: lightTextColor,
            ),
      ),
    );
  }
}
