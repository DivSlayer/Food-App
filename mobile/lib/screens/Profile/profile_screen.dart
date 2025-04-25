import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_app/components/forms/form_group.dart';
import 'package:food_app/components/forms/input.dart';
import 'package:food_app/main.dart';
import 'package:food_app/services/account_service.dart';
import 'package:food_app/theme/colors.dart';
import 'package:food_app/utils/dimension.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _lastEditingController = TextEditingController();
  final TextEditingController _phoneEditingController = TextEditingController();
  AccountService accountService = getAccountService();

  @override
  void initState() {
    super.initState();
    _phoneEditingController.text = accountService.account?.phone ?? '09*********';
    _nameEditingController.text = accountService.account?.firstName ?? '';
    _lastEditingController.text = accountService.account?.lastName ?? '';
  }

  @override
  Widget build(BuildContext context) {
    AccountService accountService = getAccountService();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'پروفایل',
          style: Theme.of(context).textTheme.displayLarge!.copyWith(color: yellowColor),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.chevron_left_rounded, color: textColor, size: dimmension(30, context)),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: dimmension(20, context),
                ).copyWith(top: dimmension(120, context), bottom: dimmension(20, context)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(dimmension(20, context)),
                  border: Border.all(color: borderColor.withOpacity(0.5), width: 1),
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    SingleChildScrollView(
                      child: Container(
                        margin: EdgeInsets.only(top: dimmension(100, context)),
                        padding: EdgeInsets.all(dimmension(15, context)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            FormGroup(
                              label: 'نام',
                              input: CustomInput(
                                keyboardType: TextInputType.phone,
                                textAlign: TextAlign.right,
                                controller: _nameEditingController,
                                prefixIcon: const Icon(Icons.person, color: lightTextColor),
                                onChange: () {},
                              ),
                            ),
                            SizedBox(height: dimmension(30, context)),
                            FormGroup(
                              label: 'نام خانوادگی',
                              input: CustomInput(
                                keyboardType: TextInputType.phone,
                                textAlign: TextAlign.right,
                                controller: _lastEditingController,
                                prefixIcon: const Icon(Icons.person, color: lightTextColor),
                                onChange: () {},
                              ),
                            ),
                            SizedBox(height: dimmension(30, context)),
                            FormGroup(
                              label: 'شماره همراه',
                              input: CustomInput(
                                keyboardType: TextInputType.phone,
                                textAlign: TextAlign.right,
                                controller: _phoneEditingController,
                                placeholder: '09xxxxxxxxx',
                                prefixIcon: const Icon(Icons.phone, color: lightTextColor),
                                onChange: () {},
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: dimmension(-100, context),
                      left: dimmension(100, context),
                      child: Image.network(
                        accountService.account!.profileImage ?? "",
                        width: dimmension(180, context),
                        height: dimmension(180, context),
                      ),
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
}
