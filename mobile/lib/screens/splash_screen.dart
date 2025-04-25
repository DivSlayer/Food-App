import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_app/components/buttons/iconed_button.dart';
import 'package:food_app/models/account.dart';
import 'package:food_app/models/token_model.dart';
import 'package:food_app/resource/server_resource.dart';
import 'package:food_app/response_models/splash_response.dart';
import 'package:food_app/services/db.dart';
import 'package:food_app/theme/colors.dart';
import 'package:food_app/utils/dimension.dart';
import 'package:food_app/utils/loading_widget.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final ServerResource _serverResource = ServerResource();

  bool isLoading = true;
  bool isCheckingServer = true;
  bool firstTime = true;
  AccountModel? accountModel;

  checkServer() async {
    try {
      SplashResponse serverCheck = await _serverResource.splashCheck();
      DatabaseService db = DatabaseService();
      TokenModel? token = await db.getToken();
      if (serverCheck.serverError != null) {
        setState(() {
          isLoading = false;
          firstTime = false;
        });
        return;
      }

      SplashResponse userCheck = await _serverResource.userCheck();
      if (userCheck.userError != null) {
        Get.offAllNamed('login');
      } else {
        Get.offAllNamed('home');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        firstTime = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    checkServer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: bgColor,
        toolbarHeight: 0,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: dimmension(100, context)),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Food App',
                    style: Theme.of(context).textTheme.displayLarge!.copyWith(
                        color: yellowColor,
                        fontSize: dimmension(35, context),
                        fontFamily: 'Poppins'),
                  ),
                  SizedBox(height: dimmension(15, context)),
                  Text(
                    'food everywhere!',
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                          color: lightTextColor,
                        ),
                  )
                ],
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: AnimatedOpacity(
                      opacity: isLoading && firstTime ? 1 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'لطفا صبر کنید...',
                            textDirection: TextDirection.rtl,
                            style: Theme.of(context).textTheme.displayMedium!.copyWith(
                                  color: lightTextColor,
                                ),
                          ),
                          SizedBox(height: dimmension(25, context)),
                          const LoadingWidget(),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: AnimatedOpacity(
                      opacity: isLoading && firstTime ? 0 : 1,
                      duration: const Duration(milliseconds: 150),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isLoading ? 'لطفا صبرکنید ...' : 'خطا در ارتباط با سرور!',
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              color: isLoading ? bgColor : orangeColor,
                              fontSize: dimmension(18, context),
                            ),
                          ),
                          SizedBox(height: dimmension(20, context)),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: IconedButton(
                              func: () {
                                setState(() {
                                  isLoading = true;
                                  checkServer();
                                });
                              },
                              bgColor: orangeColor,
                              isLoading: isLoading,
                              title: 'تلاش مجدد',
                              fontSize: dimmension(16, context),
                              iconSize: dimmension(20, context),
                              icon: CupertinoIcons.refresh_thick,
                              fontColor: Colors.white,
                            ),
                          ),
                          SizedBox(height: dimmension(20, context)),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: dimmension(10, context)),
          ],
        ),
      ),
    );
  }
}
