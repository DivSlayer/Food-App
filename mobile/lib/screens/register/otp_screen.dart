import 'package:flutter/material.dart';
import 'package:food_app/components/buttons/yellow_btn.dart';
import 'package:food_app/main.dart';
import 'package:food_app/services/account_service.dart';
import 'package:food_app/theme/colors.dart';
import 'package:food_app/utils/dimension.dart';
import 'package:food_app/utils/snack.dart';
import 'package:get/get.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _fieldOne = TextEditingController();
  final TextEditingController _fieldTwo = TextEditingController();
  final TextEditingController _fieldThree = TextEditingController();
  final TextEditingController _fieldFour = TextEditingController();

  final Map<String, dynamic> arguments = Get.arguments;

  bool isSending = false;

  Future<void> registerUser(Map<String, dynamic> json) async {
    final AccountService accountService = getAccountService();
    setState(() {
      isSending = true;
    });
    accountService.register(json: json).then((result) {
      if (context.mounted) {
        if (result) {
          showSnack('وارد شدید!', context);
          Get.offAllNamed('home');
        } else {
          showSnack('خطایی رخ داده است!', context, color: redColor);

          setState(() {
            isSending = false;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: bgColor,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: dimmension(100, context),
                    margin: EdgeInsets.symmetric(
                      horizontal: dimmension(20, context),
                      vertical: dimmension(20, context),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: dimmension(10, context),
                      vertical: dimmension(5, context),
                    ),
                    decoration: BoxDecoration(
                      color: yellowColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(dimmension(100, context)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.chevron_left_rounded,
                          size: dimmension(20, context),
                          color: yellowColor,
                        ),
                        Text(
                          'مرحله قبل',
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(color: yellowColor, fontSize: dimmension(13, context)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: dimmension(30, context)),
            Center(
              child: Text(
                'تایید شماره تلفن',
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                      color: yellowColor,
                      fontSize: dimmension(27, context),
                    ),
              ),
            ),
            SizedBox(height: dimmension(15, context)),
            Center(
              child: Text(
                'لطفا کد ارسال شده را وارد کنید',
                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      color: lightTextColor,
                      fontSize: dimmension(14, context),
                    ),
              ),
            ),
            SizedBox(height: dimmension(50, context)),
            const Spacer(flex: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _otpTextField(_fieldOne, true),
                _otpTextField(_fieldTwo, false),
                _otpTextField(_fieldThree, false),
                _otpTextField(_fieldFour, false),
              ],
            ),
            SizedBox(height: dimmension(100, context)),
            Container(
              margin: EdgeInsets.symmetric(horizontal: dimmension(40, context)),
              child: YellowBtn(
                title: 'تایید',
                isSending: isSending,
                onTap: () {
                  Map<String, dynamic> json = arguments['data'];
                  registerUser(json);
                },
                textC: bgColor,
              ),
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }

  Widget _otpTextField(TextEditingController controller, bool autoFocus) {
    return SizedBox(
      width: dimmension(50, context),
      child: TextField(
        controller: controller,
        autofocus: autoFocus,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        decoration: InputDecoration(
          counterText: '',
          enabledBorder: getBorder(),
          border: getBorder(),
          focusedBorder: getBorder(focused: true),
        ),
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }

  OutlineInputBorder getBorder({bool focused = false}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(dimmension(5, context)),
      borderSide: BorderSide(
        color: focused ? yellowColor.withOpacity(0.5) : borderColor.withOpacity(0.7),
        width: 2,
      ),
    );
  }
}
