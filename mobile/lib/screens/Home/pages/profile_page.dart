import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_app/main.dart';
import 'package:food_app/screens/login/login_screen.dart';
import 'package:food_app/services/account_service.dart';
import 'package:food_app/theme/colors.dart';
import 'package:food_app/utils/dimension.dart';
import 'package:food_app/utils/one_way_route.dart';
import 'package:get/get.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<ProfileButtonModel> buttons = [
    ProfileButtonModel(
      title: 'تنظیمات',
      begin: blueColor,
      end: blueColor.withOpacity(0.5),
      icon: Icons.settings,
    ),
    ProfileButtonModel(
      title: 'گزارش تخلف',
      begin: const Color(0xffbb001c),
      end: const Color(0xffbb001c).withOpacity(0.5),
      icon: Icons.warning_amber_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    AccountService accountService = getAccountService();
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: dimmension(20, context),
              vertical: dimmension(30, context),
            ),
            child: Text(
              'پروفایل',
              style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    color: yellowColor,
                  ),
            ),
          ),
          _buildProfileButton(context, accountService),
          ...List.generate(
            buttons.length,
            (index) => _buildButton(context, buttons[index]),
          ),
        ],
      ),
    );
  }

  GestureDetector _buildProfileButton(BuildContext context, AccountService accountService) {
    return GestureDetector(
      onTap: () {
        Get.toNamed('profile');
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: dimmension(20, context))
            .copyWith(bottom: dimmension(30, context)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(dimmension(15, context)),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.grey,
              Colors.grey.shade600,
            ],
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                accountService.logOut().then((bool res) {
                  oneWayRoute(
                    context: context,
                    screen: LoginScreen(),
                  );
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: dimmension(40, context)),
                width: dimmension(50, context),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(dimmension(15, context)),
                    bottomLeft: Radius.circular(dimmension(15, context)),
                  ),
                  color: redColor.withOpacity(0.5),
                ),
                child: Center(
                  child: Icon(
                    Icons.logout_rounded,
                    color: Colors.white,
                    size: dimmension(30, context),
                  ),
                ),
              ),
            ),
            SizedBox(width: dimmension(40, context)),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(dimmension(20, context)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        "${accountService.account!.firstName} ${accountService.account!.lastName}",
                        textAlign: TextAlign.right,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.displayMedium!.copyWith(
                              color: Colors.white,
                            ),
                      ),
                    ),
                    SizedBox(width: dimmension(20, context)),
                    Image.network(
                      accountService.account!.profileImage ?? "",
                      width: dimmension(70, context),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, ProfileButtonModel button) {
    return Container(
      margin: EdgeInsets.only(bottom: dimmension(30, context)),
      padding: EdgeInsets.symmetric(horizontal: dimmension(20, context)),
      child: Container(
        padding: EdgeInsets.all(dimmension(20, context)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(dimmension(15, context)),
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              button.begin,
              button.end,
            ],
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Text(
                button.title,
                textAlign: TextAlign.right,
                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
            SizedBox(width: dimmension(20, context)),
            Icon(
              button.icon,
              size: dimmension(40, context),
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileButtonModel {
  final String title;
  final Color begin, end;
  final IconData icon;

  ProfileButtonModel(
      {required this.title, required this.begin, required this.end, required this.icon});
}
