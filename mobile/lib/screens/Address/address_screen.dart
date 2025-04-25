import 'package:flutter/material.dart';
import 'package:food_app/main.dart';
import 'package:food_app/screens/Address/components/addresses_list.dart';
import 'package:food_app/services/account_service.dart';
import 'package:food_app/theme/colors.dart';
import 'package:food_app/utils/dimension.dart';
import 'package:get/get.dart';

import '../../refresh_indicators/checkmark_indicator.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  Future<void> onRefresh() async {
    AccountService accountService = getAccountService();

    accountService.updateDetails();
    return Future.delayed(const Duration(milliseconds: 1500));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CheckMarkIndicator(
          onRefresh: () async {
            onRefresh();
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: dimmension(5, context)),
                      child: IconButton(
                        icon: Icon(
                          Icons.chevron_left_rounded,
                          size: dimmension(30, context),
                          color: textColor,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    Text(
                      'مدیریت آدرس ها',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed('add_address');
                      },
                      child: Container(
                        padding: EdgeInsets.all(dimmension(5, context)),
                        margin: EdgeInsets.only(right: dimmension(20, context)),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(dimmension(5, context)),
                          border: Border.all(
                            color: yellowColor,
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          Icons.add_rounded,
                          color: yellowColor,
                          size: dimmension(22, context),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: dimmension(30, context)),
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(horizontal: dimmension(20, context)),
                  child: const AddressesList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
