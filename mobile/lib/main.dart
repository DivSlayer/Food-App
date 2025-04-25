import 'package:flutter/material.dart';
import 'package:food_app/screens/Address/add_address_screen.dart';
import 'package:food_app/screens/Address/address_screen.dart';
import 'package:food_app/screens/Category/category_screen.dart';
import 'package:food_app/screens/Comment/comment_screen.dart';
import 'package:food_app/screens/Delivery/delivery_screen.dart';
import 'package:food_app/screens/Food/food_screen.dart';
import 'package:food_app/screens/Home/home_screen.dart';
import 'package:food_app/screens/Payment/payment_screen.dart';
import 'package:food_app/screens/Profile/profile_screen.dart';
import 'package:food_app/screens/Receipt/receipt_screen.dart';
import 'package:food_app/screens/Restaurant/restaurant_screen.dart';
import 'package:food_app/screens/Search/search_screen.dart';
import 'package:food_app/screens/login/login_screen.dart';
import 'package:food_app/screens/register/otp_screen.dart';
import 'package:food_app/screens/register/register_screen.dart';
import 'package:food_app/screens/splash_screen.dart';
import 'package:food_app/services/account_service.dart';
import 'package:food_app/services/favorite_service.dart';
import 'package:food_app/services/order_service.dart';
import 'package:food_app/services/transaction_service.dart';
import 'package:food_app/theme/colors.dart';
import 'package:food_app/utils/dimension.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) => OrderService(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => FavoriteService(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => AccountService(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => TransactionService(),
        ),
      ],
      child: GetMaterialApp(
        title: 'Food Delivery App',
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          fontFamily: 'Dana',
          textTheme: Theme.of(context)
              .textTheme
              .apply(
                displayColor: textColor,
                fontFamily: 'Dana',
              )
              .copyWith(
                displayLarge: TextStyle(
                  fontSize: dimmension(20, context),
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
                displayMedium: TextStyle(
                  fontSize: dimmension(16, context),
                  color: textColor,
                  fontWeight: FontWeight.w500,
                ),
                displaySmall: TextStyle(
                  fontSize: dimmension(14, context),
                  color: lightTextColor,
                  fontWeight: FontWeight.w400,
                  // fontWeight: FontWeight.w500,
                ),
              ),
          scaffoldBackgroundColor: bgColor,
        ),
        home: const SplashScreen(),
        getPages: [
          GetPage(
            name: '/home',
            page: () => const HomeScreen(),
            transition: Transition.circularReveal,
            transitionDuration: const Duration(milliseconds: 300),
          ),
          GetPage(
            name: '/restaurant',
            page: () => const RestaurantScreen(),
            transition: Transition.circularReveal,
            transitionDuration: const Duration(milliseconds: 300),
          ),
          GetPage(
            name: '/food',
            page: () => const FoodScreen(),
            transition: Transition.circularReveal,
            transitionDuration: const Duration(milliseconds: 300),
          ),
          GetPage(
            name: '/address',
            page: () => const AddressScreen(),
            transition: Transition.circularReveal,
            transitionDuration: const Duration(milliseconds: 300),
          ),
          GetPage(
            name: '/add_address',
            page: () => const AddAddressScreen(),
            transition: Transition.circularReveal,
            transitionDuration: const Duration(milliseconds: 300),
          ),
          GetPage(
            name: '/category',
            page: () => const CategoryScreen(),
            transition: Transition.circularReveal,
            transitionDuration: const Duration(milliseconds: 300),
          ),
          GetPage(
            name: '/receipt',
            page: () => const ReceiptScreen(),
            transition: Transition.circularReveal,
            transitionDuration: const Duration(milliseconds: 300),
          ),
          GetPage(
            name: '/register',
            page: () => const RegisterScreen(),
            transition: Transition.circularReveal,
            transitionDuration: const Duration(milliseconds: 300),
          ),
          GetPage(
            name: '/login',
            page: () => const LoginScreen(),
            transition: Transition.circularReveal,
            transitionDuration: const Duration(milliseconds: 300),
          ),
          GetPage(
            name: '/splash',
            page: () => const SplashScreen(),
            transition: Transition.circularReveal,
            transitionDuration: const Duration(milliseconds: 300),
          ),
          GetPage(
            name: '/otp',
            page: () => const OtpScreen(),
            transition: Transition.circularReveal,
            transitionDuration: const Duration(milliseconds: 300),
          ),
          GetPage(
            name: '/profile',
            page: () => const ProfileScreen(),
            transition: Transition.circularReveal,
            transitionDuration: const Duration(milliseconds: 300),
          ),
          GetPage(
            name: '/delivery',
            page: () => const DeliveryScreen(),
            transition: Transition.circularReveal,
            transitionDuration: const Duration(milliseconds: 300),
          ),
          GetPage(
            name: '/payment',
            page: () => const PaymentScreen(),
            transition: Transition.circularReveal,
            transitionDuration: const Duration(milliseconds: 300),
          ),
          GetPage(
            name: '/comment',
            page: () => const CommentScreen(),
            transition: Transition.circularReveal,
            transitionDuration: const Duration(milliseconds: 300),
          ),
          GetPage(
            name: '/search',
            page: () => const SearchScreen(),
            transition: Transition.circularReveal,
            transitionDuration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }
}

AccountService getAccountService() {
  return Provider.of<AccountService>(navigatorKey.currentContext!, listen: false);
}

FavoriteService getFavoriteService() {
  return Provider.of<FavoriteService>(navigatorKey.currentContext!, listen: false);
}

OrderService getOrderService() {
  return Provider.of<OrderService>(navigatorKey.currentContext!, listen: false);
}

TransactionService getTransactionService() {
  return Provider.of<TransactionService>(navigatorKey.currentContext!, listen: false);
}
