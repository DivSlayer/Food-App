import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_app/components/buttons/iconed_button.dart';
import 'package:food_app/components/forms/form_group.dart';
import 'package:food_app/components/forms/input.dart';
import 'package:food_app/theme/colors.dart';
import 'package:food_app/utils/dimension.dart';
import 'package:food_app/utils/regexes.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool showPassword = false;
  bool showPassword2 = false;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _pass1Controller = TextEditingController();
  final TextEditingController _pass2Controller = TextEditingController();

  String? pass2Error, firstNameError, pass1Error, lastNameError;
  String? phoneError;
  bool? lengthRoleStat;
  bool? combineRoleStat;

  bool validateForm() {
    bool condition = true;
    if (_firstNameController.text == "") {
      setState(() {
        firstNameError = "این فیلد اجباری است";
      });
    } else {
      setState(() {
        firstNameError = null;
      });
    }
    if (_lastNameController.text == "") {
      setState(() {
        lastNameError = "این فیلد اجباری است";
      });
    } else {
      setState(() {
        lastNameError = null;
      });
    }
    if (_phoneNumberController.text == "") {
      setState(() {
        phoneError = "این فیلد اجباری است";
      });
    } else {
      setState(() {
        phoneError = null;
      });
    }
    if (_pass1Controller.text == "") {
      setState(() {
        pass1Error = "این فیلد اجباری است";
      });
    } else {
      setState(() {
        pass1Error = null;
      });
    }
    return condition;
  }

  bool validatePhone(String value) {
    if (value != '') {
      if (!phoneRegexValidate(value)) {
        setState(() {
          phoneError = 'شماره همراه نامعتبر است';
        });
        return false;
      } else {
        setState(() {
          phoneError = null;
        });
        return true;
      }
    } else {
      setState(() {
        phoneError = null;
      });
      return false;
    }
  }

  bool validatePass1(String value) {
    if (value != "") {
      bool combined = hasNumberAndString(value);
      int length = value.length;
      setState(() {
        combineRoleStat = combined;
        lengthRoleStat = length >= 8;
      });
      return combined && length >= 8;
    } else {
      setState(() {
        combineRoleStat = null;
        lengthRoleStat = null;
      });
      return false;
    }
  }

  bool validatePass2(String value) {
    if (value != "") {
      if (value != _pass1Controller.text) {
        setState(() {
          pass2Error = 'رمزعبور ها با یکدیگر همخوانی ندارند';
        });
        return false;
      } else {
        setState(() {
          pass2Error = null;
        });
        return true;
      }
    } else {
      setState(() {
        pass2Error = null;
      });
      return false;
    }
  }
  @override
  void dispose() {
    _pass1Controller.dispose();
    _pass2Controller.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _pass1Controller.addListener(() {
      validatePass1(_pass1Controller.text);
      validateForm();
    });
    _pass2Controller.addListener(() {
      validatePass2(_pass2Controller.text);
    });
    _phoneNumberController.addListener(() {
      validatePhone(_phoneNumberController.text);
      validateForm();
    });
    _lastNameController.addListener(() {
      validateForm();
    });
    _firstNameController.addListener(() {
      validateForm();
    });
    super.initState();
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
                  'ثبت نام',
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                        color: yellowColor,
                        fontSize: dimmension(35, context),
                      ),
                ),
              ),
              SizedBox(height: dimmension(15, context)),
              Center(
                child: Text(
                  'عضو جدید',
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        color: lightTextColor,
                      ),
                ),
              ),
              SizedBox(height: dimmension(50, context)),
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
            label: 'نام',
            error: firstNameError,
            input: CustomInput(
              textAlign: TextAlign.right,
              controller: _firstNameController,
              placeholder: 'نام خود را وارد کنید',
              prefixIcon: const Icon(
                Icons.person,
                color: lightTextColor,
              ),
              onChange: () {},
            ),
          ),
          SizedBox(height: dimmension(20, context)),
          FormGroup(
            label: 'نام خانوادگی',
            error: lastNameError,
            input: CustomInput(
              textAlign: TextAlign.right,
              controller: _lastNameController,
              placeholder: 'نام خانوادگی خود را وارد کنید',
              prefixIcon: const Icon(
                Icons.person,
                color: lightTextColor,
              ),
              onChange: () {},
            ),
          ),
          SizedBox(height: dimmension(20, context)),
          FormGroup(
            label: 'شماره همراه',
            error: phoneError,
            input: CustomInput(
              textAlign: TextAlign.right,
              keyboardType: TextInputType.phone,
              controller: _phoneNumberController,
              placeholder: '09xxxxxxxxx',
              prefixIcon: const Icon(
                Icons.phone,
                color: lightTextColor,
              ),
              onChange: () {},
            ),
          ),
          SizedBox(height: dimmension(20, context)),
          FormGroup(
            label: 'رمز عبور',
            error: pass1Error,
            helpWidget: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(height: dimmension(5, context)),
                _buildRoleItem(
                  context: context,
                  value: 'رمزعبور باید حداقل 8 کاراکتر باشد',
                  controller: lengthRoleStat,
                ),
                SizedBox(height: dimmension(5, context)),
                _buildRoleItem(
                  context: context,
                  value: 'رمزعبور باید ترکیبی از ارقام و حروف باشد',
                  controller: combineRoleStat,
                ),
              ],
            ),
            input: CustomInput(
              textAlign: TextAlign.right,
              placeholder: 'xxxxxxxxx',
              controller: _pass1Controller,
              obscureText: !showPassword,
              onChange: () {},
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
            ),
          ),
          SizedBox(height: dimmension(20, context)),
          FormGroup(
            label: 'تکرار رمز عبور',
            error: pass2Error,
            input: CustomInput(
              controller: _pass2Controller,
              textAlign: TextAlign.right,
              placeholder: 'xxxxxxxxx',
              obscureText: !showPassword2,
              prefixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    showPassword2 = !showPassword2;
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
                      showPassword2 ? CupertinoIcons.eye_slash_fill : CupertinoIcons.eye_fill,
                      color: lightTextColor,
                    ),
                  ),
                ),
              ),
              onChange: () {},
            ),
          ),
          SizedBox(height: dimmension(30, context)),
          IconedButton(
            func: () {
              bool con1 = validatePhone(_phoneNumberController.text);
              bool con2 = validatePass1(_pass1Controller.text);
              bool con3 = validatePass2(_pass2Controller.text);
              bool con4 = validateForm();
              if (con1 && con2 && con3) {
                Map<String, dynamic> json = {
                  'phone': _phoneNumberController.text,
                  "first_name": _firstNameController.text,
                  "last_name": _lastNameController.text,
                  "password1": _pass1Controller.text,
                  "password2": _pass2Controller.text,
                };
                Get.toNamed('otp', arguments: {"data": json});
              }
            },
            bgColor: yellowColor,
            title: 'مرحله بعد',
          ),
          SizedBox(height: dimmension(20, context)),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'وارد شوید',
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                        fontFamily: 'Lalezar',
                        color: yellowColor,
                        fontSize: dimmension(16, context),
                      ),
                ),
              ),
              SizedBox(width: dimmension(10, context)),
              Text(
                'حساب دارید؟',
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      color: lightTextColor,
                      fontSize: dimmension(14, context),
                    ),
              ),
            ],
          ),
          SizedBox(height: dimmension(40, context)),
        ],
      ),
    );
  }

  Padding _buildRoleItem({required BuildContext context, required String value, bool? controller}) {
    return Padding(
      padding: EdgeInsets.only(right: dimmension(5, context)),
      child: Text(
        value,
        style: TextStyle(
          color: controller != null
              ? controller
                  ? greenColor
                  : redColor
              : lightTextColor,
          fontSize: dimmension(12, context),
        ),
      ),
    );
  }
}
