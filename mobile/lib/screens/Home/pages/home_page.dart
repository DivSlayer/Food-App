import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_app/blocs/category_list_bloc.dart';
import 'package:food_app/blocs/restaurants_bloc.dart';
import 'package:food_app/components/custom_input.dart';
import 'package:food_app/main.dart';
import 'package:food_app/refresh_indicators/checkmark_indicator.dart';
import 'package:food_app/screens/Home/components/banner_widget.dart';
import 'package:food_app/screens/Home/components/categories_widget.dart';
import 'package:food_app/screens/Home/components/restaurants_slider.dart';
import 'package:food_app/screens/Search/search_screen.dart';
import 'package:food_app/services/account_service.dart';
import 'package:food_app/services/favorite_service.dart';
import 'package:food_app/services/order_service.dart';
import 'package:food_app/services/transaction_service.dart';
import 'package:food_app/theme/colors.dart';
import 'package:food_app/utils/dimension.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TransactionService _transactionService;
  bool haveAdd = false;
  CategoryListBloc? _categoryListBloc;
  RestaurantBloc? _restaurantBloc = RestaurantBloc();

  getTransactions() async {
    await _transactionService.getTransactions();
  }

  @override
  void initState() {
    super.initState();
    _transactionService = Provider.of<TransactionService>(context, listen: false);
    getTransactions();
  }

  Future<void> onRefresh() async {
    AccountService account = getAccountService();
    OrderService orderService = getOrderService();
    TransactionService transactionService = getTransactionService();
    AccountService accountService = getAccountService();
    FavoriteService favoriteService = getFavoriteService();

    setState(() {
      _restaurantBloc = null;
      _categoryListBloc = null;
    });
    setState(() {
      _restaurantBloc = RestaurantBloc();
      _categoryListBloc = CategoryListBloc();
      _restaurantBloc!.getCloseRestaurants(account.activeAddress!);
    });

    _categoryListBloc!.getCategories().then((res) {});
    accountService.updateDetails();
    orderService.loadOrders();
    transactionService.getTransactions();
    favoriteService.getFoods();
    return Future.delayed(const Duration(milliseconds: 1500));
  }

  @override
  Widget build(BuildContext context) {
    return CheckMarkIndicator(
      onRefresh: () async {
        onRefresh();
      },
      child: SingleChildScrollView(
        child: Consumer<AccountService>(
            builder: (context, accountService, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildHeader(context),
                SizedBox(height: dimmension(20, context)),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const SearchScreen()),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: dimmension(20, context)),
                    child: Hero(
                      tag: 'search_input',
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: dimmension(15, context),
                          horizontal: dimmension(10, context),
                        ),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: borderColor,
                              width: dimmension(1, context),
                            ),
                            borderRadius: BorderRadius.circular(dimmension(10, context))),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              Icons.filter_list,
                              size: dimmension(25, context),
                              color: lightTextColor,
                            ),
                            Row(
                              children: [
                                Text(
                                  'جستجو غذاها و رستوران ها',
                                  style: Theme.of(context).textTheme.displaySmall,
                                ),
                                SizedBox(width: dimmension(5, context)),
                                Icon(
                                  Icons.search,
                                  size: dimmension(30, context),
                                  color: yellowColor,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: dimmension(30, context)),
                CategoriesWidget(bloc: _categoryListBloc),
                SizedBox(height: dimmension(30, context)),
                const BannerWidget(),
                SizedBox(height: dimmension(30, context)),
                RestaurantsSlider(bloc: _restaurantBloc),
                SizedBox(height: dimmension(100, context)),
              ],
            );
          }
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    AccountService accountService = getAccountService();
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dimmension(20, context),
        vertical: dimmension(20, context),
      ),
      width: MediaQuery.of(context).size.width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Consumer<TransactionService>(builder: (context, transactionService, child) {
                return GestureDetector(
                  onTap: () {
                    Get.toNamed('delivery');
                  },
                  child: Container(
                    padding: EdgeInsets.all(dimmension(10, context)),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: lightTextColor,
                        width: 0.8,
                      ),
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Icon(
                          Icons.receipt,
                          size: dimmension(23, context),
                          color: lightTextColor,
                        ),
                        Positioned(
                          right: dimmension(-5, context),
                          top: dimmension(-5, context),
                          child: Container(
                            width: dimmension(15, context),
                            height: dimmension(15, context),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: lightTextColor,
                              border: Border.all(
                                width: 1,
                                color: bgColor,
                              ),
                            ),
                            child: Text(
                              transactionService.transactionsList.length.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.white,
                                fontSize: dimmension(10, context),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              SizedBox(width: dimmension(15, context)),
              GestureDetector(
                onTap: () {
                  Get.toNamed('address');
                },
                child: Container(
                  padding: EdgeInsets.all(dimmension(10, context)),
                  decoration: BoxDecoration(
                    color: lightBgColor.withOpacity(0.5),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: yellowColor,
                      width: 0.8,
                    ),
                  ),
                  child: Icon(
                    Icons.map,
                    color: yellowColor,
                    size: dimmension(23, context),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: dimmension(20, context)),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                accountService.activeAddress != null
                    ? Expanded(
                        child: RichText(
                          textAlign: TextAlign.right,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textDirection: TextDirection.rtl,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'ارسال به',
                                style: Theme.of(context).textTheme.displaySmall,
                              ),
                              TextSpan(
                                text: '\n ${accountService.activeAddress?.briefAddress}',
                                style: Theme.of(context).textTheme.displayMedium,
                              ),
                            ],
                          ),
                        ),
                      )
                    : Text(
                        'لطفا آدرس خود را اضافه کنید',
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                SizedBox(width: dimmension(10, context)),
                SvgPicture.asset(
                  'assets/icons/location-dot-solid.svg',
                  height: dimmension(30, context),
                  color: yellowColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
