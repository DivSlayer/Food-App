import 'package:flutter/material.dart';
import 'package:food_app/components/buttons/yellow_btn.dart';
import 'package:food_app/components/forms/custom_text_form.dart';
import 'package:food_app/components/forms/form_group.dart';
import 'package:food_app/components/forms/input.dart';
import 'package:food_app/models/address.dart' show AddressModel;
import 'package:food_app/theme/colors.dart';
import 'package:food_app/utils/dimension.dart';
import 'package:food_app/utils/validators.dart';

class AddressForm extends StatefulWidget {
  const AddressForm({
    super.key,
    required this.onSubmit,
    this.isSending = false,
    this.defaultAddress,
  });

  final AddressModel? defaultAddress;
  final Function(Map<String, dynamic>, BuildContext) onSubmit;
  final bool isSending;

  @override
  State<AddressForm> createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressForm> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController titleController = TextEditingController();

  String? nameError, addressError, phoneError, titleError;

  validation() {
    bool condition = true;
    if (nameController.text == "") {
      setState(() {
        nameError = "این فیلد اجباری است";
      });
      condition = false;
    }
    if (phoneController.text == "") {
      setState(() {
        phoneError = "این فیلد اجباری است";
      });
      condition = false;
    }
    if (addressController.text == "") {
      setState(() {
        addressError = "این فیلد اجباری است";
      });
      condition = false;
    }
    if (titleController.text == "") {
      setState(() {
        titleError = "این فیلد اجباری است";
      });
      condition = false;
    }
    return condition;
  }

  Map<String, dynamic> getJson() {
    if (widget.defaultAddress != null) {
      AddressModel editedAddress = widget.defaultAddress!.copyWith(
        phone: phoneController.text,
        title: titleController.text,
        briefAddress: addressController.text,
        name: nameController.text,
      );
      return editedAddress.toJson();
    }
    Map<String, dynamic> json = {};
    json.addAll({
      'phone': phoneController.text,
      'name': nameController.text,
      'title': titleController.text,
      'brief_address': addressController.text
    });
    return json;
  }

  @override
  void initState() {
    super.initState();
    if (widget.defaultAddress != null) {
      setState(() {
        nameController.text = widget.defaultAddress!.name;
        addressController.text = widget.defaultAddress!.briefAddress;
        phoneController.text = widget.defaultAddress!.phone;
        titleController.text = widget.defaultAddress!.title;
      });
    }
    phoneController.addListener(() {
      var (result, error) = Validators.validatePhone(phoneController.text);
      setState(() {
        phoneError = error;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(dimmension(20, context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FormGroup(
            label: 'عنوان',
            error: titleError,
            input: CustomInput(
              textAlign: TextAlign.right,
              bgColor: bgColor,
              controller: titleController,
              placeholder: 'عنوان آدرس را وارد کنید',
              deactiveBorderColor: borderColor.withOpacity(0.7),
              onChange: () {},
            ),
          ),
          SizedBox(height: dimmension(30, context)),
          FormGroup(
            label: 'نام دریافت کننده',
            error: nameError,
            input: CustomInput(
              textAlign: TextAlign.right,
              bgColor: bgColor,
              controller: nameController,
              placeholder: 'نام دریافت کننده را وارد کنید',
              deactiveBorderColor: borderColor.withOpacity(0.7),
              onChange: () {},
            ),
          ),
          SizedBox(height: dimmension(30, context)),
          FormGroup(
            label: 'آدرس',
            error: addressError,
            input: CustomInput(
              textAlign: TextAlign.right,
              bgColor: bgColor,
              controller: addressController,
              placeholder: 'آدرس مکان موردنظر را وارد کنید',
              deactiveBorderColor: borderColor.withOpacity(0.7),
              onChange: () {},
            ),
          ),
          SizedBox(height: dimmension(30, context)),
          FormGroup(
            label: 'شماره تماس',
            error: phoneError,
            input: CustomInput(
              textAlign: TextAlign.right,
              keyboardType: TextInputType.phone,
              bgColor: bgColor,
              controller: phoneController,
              placeholder: 'نام دریافت کننده را وارد کنید',
              deactiveBorderColor: borderColor.withOpacity(0.7),
              onChange: () {},
            ),
          ),
          SizedBox(height: dimmension(30, context)),
          YellowBtn(
            title: 'اضافه کردن',
            onTap: () {
              if (validation()) {
                widget.onSubmit(getJson(), context);
              }
            },
            isSending: widget.isSending,
            textC: Colors.white,
            radius: dimmension(10, context),
            padding: EdgeInsets.symmetric(
              horizontal: dimmension(20, context),
              vertical: dimmension(15, context),
            ),
          ),
        ],
      ),
    );
  }
}
