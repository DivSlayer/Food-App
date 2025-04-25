import 'package:flutter/material.dart';
import 'package:food_app/blocs/restaurants_bloc.dart';
import 'package:food_app/models/restaurant.dart';
import 'package:food_app/screens/Restaurant/components/header_widget.dart';
import 'package:food_app/screens/Restaurant/components/list_navigator.dart';
import 'package:food_app/screens/Restaurant/components/food_switcher_list.dart';
import 'package:food_app/theme/colors.dart';
import 'package:food_app/utils/dimension.dart';
import 'package:food_app/utils/loading_widget.dart';
import 'package:get/get.dart';

class RestaurantScreen extends StatefulWidget {
  const RestaurantScreen({super.key});

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey navigatorKey1 = GlobalKey();
  final GlobalKey navigatorKey2 = GlobalKey();
  final RestaurantBloc _bloc = RestaurantBloc();
  final Map<String, dynamic> arguments = Get.arguments;

  double topOffset = 0;
  double _scrollOffset = 0;
  List<Widget> pages = [];
  int currentNav = 0;
  double scrollPosition = 20;
  double scrollWidth = 20;

  (double, double) _getItemPosition(GlobalKey keyForItem) {
    final renderBox = keyForItem.currentContext?.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    // You can also get the position relative to the screen:
    final positionX = offset.dx;
    final positionY = offset.dy;
    // If you need the position relative to the ListView:
    final listViewOffset = context.findRenderObject()?.getTransformTo(null).getTranslation();
    final relativeX = positionX - listViewOffset!.x;
    final relativeY = positionY - listViewOffset.y;
    return (relativeX, relativeY);
  }

  @override
  void initState() {
    super.initState();
    _bloc.getSingleRestaurants(arguments['uuid']).then((res) {
      if (res.restaurants.isNotEmpty) {
        RestaurantModel restaurant = res.restaurants[0];
        for (var cat in restaurant.cats?.keys ?? []) {
          setState(() {
            pages.add(FoodSwitcherList(
              foods: restaurant.cats?[cat] ?? [],
            ));
          });
        }
      }
    });

    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    });
  }

  void changeNav(int index) {
    setState(() {
      _scrollOffset = 0;
      currentNav = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: StreamBuilder(
          stream: _bloc.subject.stream,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.error != null) {
                if ((snapshot.data.restaurants as List).isEmpty) {
                  return _buildNoItem(context);
                } else {
                  return _buildContent(snapshot.data.restaurants[0]);
                }
              }
              if ((snapshot.data.restaurants as List).isEmpty) {
                return _buildNoItem(context);
              } else {
                return _buildContent(snapshot.data.restaurants[0]);
              }
            } else if (snapshot.hasError) {
              return _buildNoItem(context);
            } else {
              return _buildLoadingPage();
            }
          },
        ),
      ),
    );
  }

  Widget _buildContent(RestaurantModel restaurant) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var (xOffset, yOffset) = _getItemPosition(navigatorKey1);
      setState(() {
        topOffset = yOffset;
      });
    });

    return Stack(
      clipBehavior: Clip.none,
      children: [
        SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              HeaderWidget(restaurant: restaurant),
              SizedBox(height: dimmension(30, context)),
              Opacity(
                opacity: _scrollOffset >= dimmension(430, context) ? 0 : 1,
                child: ListNavigator(
                  navKey: navigatorKey1,
                  onTap: (index) => changeNav(index),
                  scrollPosition: scrollPosition,
                  scrollWidth: scrollWidth,
                  onBind: (double width) {
                    setState(() {
                      scrollWidth = width;
                    });
                  },
                  onTapDown: (double width, double position) {
                    setState(() {
                      scrollWidth = width;
                      scrollPosition = position;
                    });
                  },
                  cats: restaurant.cats!,
                ),
              ),
              SizedBox(height: dimmension(20, context)),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: pages[currentNav],
              )
            ],
          ),
        ),
        _scrollOffset >= dimmension(430, context)
            ? Positioned(
                top: 0,
                child: Container(
                  color: bgColor,
                  height: dimmension(100, context),
                  child: Container(
                    margin: EdgeInsets.only(top: dimmension(50, context)),
                    child: ListNavigator(
                      navKey: navigatorKey2,
                      onTap: (index) => changeNav(index),
                      scrollPosition: scrollPosition,
                      scrollWidth: scrollWidth,
                      onBind: (double width) {
                        setState(() {
                          scrollWidth = width;
                        });
                      },
                      onTapDown: (double width, double position) {
                        setState(() {
                          scrollWidth = width;
                          scrollPosition = position;
                        });
                      },
                      cats: restaurant.cats!,
                    ),
                  ),
                ),
              )
            : Container(),
      ],
    );
  }

  Widget _buildNoItem(context) {
    return Center(
      child: Text(
        'رستورانی وجود ندارد!',
        textAlign: TextAlign.center,
        textDirection: TextDirection.rtl,
        style: Theme.of(context).textTheme.displayMedium!.copyWith(
              color: lightTextColor,
            ),
      ),
    );
  }

  Widget _buildLoadingPage() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: LoadingWidget(
              loadColor: yellowColor,
              size: dimmension(40, context),
            ),
          ),
        ],
      ),
    );
  }
}
