import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_app/main.dart';
import 'package:food_app/services/account_service.dart';
import 'package:food_app/theme/colors.dart';
import 'package:food_app/utils/dimension.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class AddressesList extends StatefulWidget {
  const AddressesList({super.key});

  @override
  State<AddressesList> createState() => _AddressesListState();
}

class _AddressesListState extends State<AddressesList> {
  AccountService accountService = getAccountService();

  @override
  Widget build(BuildContext context) {
    return Consumer<AccountService>(
      builder: (context, accountService, child) {
        return ListView.builder(
          itemCount: accountService.account?.addresses.length ?? 0,
          itemBuilder:
              (context, index) => GestureDetector(
                onTap: () {
                  print(accountService.activeAddress!.uuid);
                  print(accountService.account!.addresses[index].uuid);
                  accountService.updateAddress(accountService.account!.addresses[index]);
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: dimmension(30, context)),
                  child: Dismissible(
                    direction: DismissDirection.startToEnd,
                    key: GlobalKey(),
                    background: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(dimmension(20, context)),
                        color: redColor,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.delete_outline_rounded,
                              size: dimmension(40, context),
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: dimmension(5, context)),
                          Text(
                            'حذف',
                            style: Theme.of(
                              context,
                            ).textTheme.displayMedium!.copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: EdgeInsets.all(dimmension(20, context)),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(dimmension(20, context)),
                        border: Border.all(
                          color:
                              accountService.activeAddress!.uuid ==
                                      accountService.account?.addresses[index].uuid
                                  ? yellowColor
                                  : borderColor.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  accountService.account?.addresses[index].title ?? "",
                                  style: Theme.of(context).textTheme.displayMedium,
                                ),
                                SizedBox(height: dimmension(15, context)),
                                Text(
                                  accountService.account?.addresses[index].briefAddress ?? "",
                                  style: Theme.of(context).textTheme.displaySmall,
                                  textDirection: TextDirection.rtl,
                                  textAlign: TextAlign.right,
                                  maxLines: 2,
                                ),
                                SizedBox(height: dimmension(15, context)),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: IconButton(
                                    onPressed: () {
                                      Get.toNamed(
                                        'add_address',
                                        arguments: {
                                          'address': accountService.account?.addresses[index],
                                        },
                                      );
                                    },
                                    icon: Container(
                                      padding: EdgeInsets.all(dimmension(5, context)),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(dimmension(5, context)),
                                        border: Border.all(color: yellowColor, width: 1),
                                      ),
                                      child: Icon(
                                        Icons.edit_location_alt_outlined,
                                        color: yellowColor,
                                        size: dimmension(22, context),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: dimmension(15, context)),
                          Container(
                            width: dimmension(80, context),
                            height: dimmension(80, context),
                            padding: EdgeInsets.all(dimmension(10, context)),
                            decoration: BoxDecoration(
                              color: lightBgColor,
                              borderRadius: BorderRadius.circular(dimmension(15, context)),
                            ),
                            child: Center(child: SvgPicture.asset('assets/vectors/map.svg')),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
        );
      },
    );
  }
}
