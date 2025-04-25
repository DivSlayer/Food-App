import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_app/models/extra.dart';
import 'package:food_app/models/instruction.dart';
import 'package:food_app/models/order.dart';
import 'package:food_app/screens/Receipt/components/receipt_item.dart';
import 'package:food_app/theme/colors.dart';
import 'package:food_app/utils/dimension.dart';
import 'package:food_app/utils/number_formatter.dart';
import 'package:get/get.dart';

import '../../models/food.dart' show FoodModel;

class ReceiptScreen extends StatefulWidget {
  const ReceiptScreen({super.key});

  @override
  State<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  final FoodModel food = Get.arguments['food'];
  final OrderModel order = Get.arguments['order'];

  @override
  void initState() {
    super.initState();
  }

  List<ExtraModel> getSortedExtras(List<ExtraModel> unsortedExtras) {
    List<ExtraModel> newList = [];
    for (var i = 0; i < unsortedExtras.length; i++) {
      ExtraModel extra = unsortedExtras[i];
      int count = unsortedExtras.fold(
        0,
        (count, element) => count + (element.name == extra.name ? 1 : 0),
      );
      ExtraModel newExtra = ExtraModel(
        name: extra.name,
        price: extra.price,
        icon: extra.icon,
        quantity: count,
        uuid: '',
      );
      bool contains = newList.fold(
        false,
        (contains, element) => contains || (element.name == extra.name),
      );
      if (contains == false) {
        newList.add(newExtra);
      }
    }
    return newList;
  }

  List<InstructionModel> getSortedIns(List<InstructionModel> unsortedIns) {
    List<InstructionModel> newList = [];
    for (var i = 0; i < unsortedIns.length; i++) {
      InstructionModel instruction = unsortedIns[i];
      int count = unsortedIns.fold(
        0,
        (count, element) => count + (element.name == instruction.name ? 1 : 0),
      );

      InstructionModel newInstruction = InstructionModel(
        name: instruction.name,
        price: instruction.price,
        image: instruction.image,
        quantity: count,
        uuid: '',
      );
      bool contains = newList.fold(
        false,
        (contains, element) => contains || (element.name == instruction.name),
      );
      if (contains == false) {
        newList.add(newInstruction);
      }
    }
    return newList;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SizedBox(
        width: size.width,
        child: Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: dimmension(20, context),
              vertical: dimmension(40, context),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: dimmension(20, context),
              vertical: dimmension(20, context),
            ),
            decoration: BoxDecoration(
              border: Border.all(color: borderColor.withOpacity(0.5), width: 1),
              borderRadius: BorderRadius.circular(dimmension(20, context)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ReceiptItem(
                  name: food.name,
                  image: Image.asset('assets/images/pizza.png'),
                  totalPrice: food.selectedSize!.price * order.quantity,
                  eachPrice: food.selectedSize!.price,
                  quantity: order.quantity,
                ),
                ...List.generate(getSortedExtras(order.extras).length, (index) {
                  ExtraModel extra = getSortedExtras(food.restaurant!.extras)[index];
                  return ReceiptItem(
                    name: extra.name,
                    image: SvgPicture.asset(extra.icon),
                    totalPrice: (extra.quantity ?? 1) * extra.price,
                    eachPrice: extra.price,
                    quantity: extra.quantity ?? 1,
                  );
                }),
                ...List.generate(getSortedIns(order.instructions).length, (index) {
                  InstructionModel instruction = getSortedIns(order.instructions)[index];
                  return ReceiptItem(
                    name: instruction.name,
                    image: SvgPicture.network(instruction.image),
                    totalPrice: (instruction.quantity ?? 1) * instruction.price,
                    eachPrice: instruction.price,
                    quantity: instruction.quantity ?? 1,
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: bgColor,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(Icons.chevron_left_rounded, size: dimmension(30, context), color: textColor),
      ),
      title: Text('رسید سفارش', style: Theme.of(context).textTheme.displayLarge),
      centerTitle: true,
    );
  }
}
