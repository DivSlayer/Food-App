import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_app/components/buttons/iconed_button.dart';
import 'package:food_app/components/forms/form_group.dart';
import 'package:food_app/components/forms/input.dart';
import 'package:food_app/main.dart';
import 'package:food_app/services/account_service.dart';
import 'package:food_app/theme/colors.dart';
import 'package:food_app/utils/dimension.dart';
import 'package:food_app/utils/snack.dart';
import 'package:food_app/utils/validators.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneEditingController = TextEditingController();
  final TextEditingController _passEditingController = TextEditingController();

  String? phoneError, passError;
  bool showPassword = false;
  bool firstUse = true;
  bool isSending = false;

  Future<void> loginUser() async {
    var (con1, error) = Validators.validatePhone(_phoneEditingController.text);
    bool con2 = _passEditingController.text != '';
    final AccountService accountService = getAccountService();
    if (con1 && con2) {
      setState(() {
        firstUse = false;
        isSending = true;
      });
      accountService.login(json: {
        'phone': _phoneEditingController.text,
        'password': _passEditingController.text,
      }).then((result) {
        print("Login result: ${result}");
        if (result.error == null) {
          showSnack('وارد شدید!', context);
          Get.offAllNamed('home');
        } else {
          showSnack(result.error!, context, color: redColor);
          setState(() {
            isSending = false;
          });
        }
      });
    }
    if (!con1) {
      setState(() {
        phoneError = 'این فیلد اجباری است!';
      });
    }
    if (!con2) {
      setState(() {
        passError = 'این فیلد اجباری است!';
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _phoneEditingController.addListener(() {
      var (result, error) = Validators.validatePhone(_phoneEditingController.text);
      setState(() {
        phoneError = error;
      });
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(height: dimmension(15, context)),
              Center(
                child: Text(
                  'ورود',
                  style: Theme
                      .of(context)
                      .textTheme
                      .displayLarge!
                      .copyWith(color: yellowColor, fontSize: dimmension(35, context)),
                ),
              ),
              SizedBox(height: dimmension(15, context)),
              Center(
                child: Text(
                  'دسترسی به حساب',
                  style: Theme
                      .of(context)
                      .textTheme
                      .displayMedium!
                      .copyWith(
                    color: lightTextColor,
                  ),
                ),
              ),
              SizedBox(height: dimmension(100, context)),
              _buildFormGroup(context),
              SizedBox(height: dimmension(15, context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormGroup(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dimmension(20, context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FormGroup(
            label: 'شماره همراه',
            error: phoneError,
            input: CustomInput(
              keyboardType: TextInputType.phone,
              textAlign: TextAlign.right,
              controller: _phoneEditingController,
              placeholder: '09xxxxxxxxx',
              prefixIcon: const Icon(
                Icons.phone,
                color: lightTextColor,
              ),
              onChange: () {},
            ),
          ),
          SizedBox(height: dimmension(30, context)),
          FormGroup(
            label: 'رمز عبور',
            error: passError,
            input: CustomInput(
              controller: _passEditingController,
              textAlign: TextAlign.right,
              placeholder: 'xxxxxxxxx',
              obscureText: !showPassword,
              prefixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    showPassword = !showPassword;
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(left: dimmension(10, context)),
                  width: dimmension(45, context),
                  height: dimmension(30, context),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      dimmension(15, context),
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      showPassword ? CupertinoIcons.eye_slash_fill : CupertinoIcons.eye_fill,
                      color: lightTextColor,
                    ),
                  ),
                ),
              ),
              onChange: () {},
            ),
          ),
          SizedBox(height: dimmension(50, context)),
          IconedButton(
            func: () {
              if (!isSending) {
                loginUser();
              }
            },
            bgColor: yellowColor,
            isLoading: isSending,
            innerWidget: _buildText(),
          ),
          SizedBox(height: dimmension(20, context)),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => Get.toNamed('register'),
                child: Text(
                  'ثبت نام کنید',
                  style: Theme
                      .of(context)
                      .textTheme
                      .displaySmall!
                      .copyWith(
                    fontFamily: 'Lalezar',
                    color: yellowColor,
                    fontSize: dimmension(16, context),
                  ),
                ),
              ),
              SizedBox(width: dimmension(10, context)),
              Text(
                'حساب ندارید؟',
                style: Theme
                    .of(context)
                    .textTheme
                    .displaySmall,
              ),
            ],
          )
        ],
      ),
    );
  }

  Text _buildText() {
    return Text(
      'ورود',
      maxLines: 1,
      style: Theme
          .of(context)
          .textTheme
          .displayLarge!
          .copyWith(
        color: Colors.white,
      ),
    );
  }
}
