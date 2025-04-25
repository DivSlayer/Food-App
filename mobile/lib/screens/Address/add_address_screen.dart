import 'package:flutter/material.dart';
import 'package:food_app/main.dart';
import 'package:food_app/models/address.dart';
import 'package:food_app/screens/Address/components/address_form.dart';
import 'package:food_app/screens/Address/components/custom_map_widget.dart';
import 'package:food_app/services/account_service.dart';
import 'package:food_app/theme/colors.dart';
import 'package:food_app/utils/dimension.dart';
import 'package:food_app/utils/snack.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  AddressModel? defaultAddress = Get.arguments?['address'];

  double detailsHeight = 0;
  double opacity = 0.5;
  bool liked = false;
  bool goingUp = false;
  bool isSending = false;
  LatLng? _userPosition;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    AccountService accountService = getAccountService();
    return Scaffold(
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Stack(
          children: [
            CustomMapWidget(
              onUserPosChange: (LatLng newPos) {
                setState(() {
                  _userPosition = newPos;
                });
              },
              defaultAddress: defaultAddress,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedContainer(
                height: detailsHeight != 0
                    ? detailsHeight
                    : size.height * 0.4 + dimmension(50, context),
                width: size.width,
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(dimmension(30, context)),
                    topRight: Radius.circular(dimmension(30, context)),
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: borderColor.withOpacity(0.3),
                        offset: const Offset(0, -3),
                        blurRadius: dimmension(20, context)),
                  ],
                ),
                duration: const Duration(milliseconds: 50),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onVerticalDragEnd: (DragEndDetails details) {
                          double windowSize = MediaQuery.of(context).size.height;
                          double maxHeight = windowSize * 0.75;
                          double minHeight = size.height * 0.4 + dimmension(50, context);
                          double differenceFT = maxHeight - detailsHeight;
                          if (goingUp) {
                            if (differenceFT < (maxHeight - minHeight) * 0.9) {
                              setState(() {
                                detailsHeight = maxHeight;
                              });
                            } else {
                              setState(() {
                                detailsHeight = minHeight;
                              });
                            }
                          } else {
                            if (differenceFT > (maxHeight - minHeight) * 0.1) {
                              setState(() {
                                detailsHeight = minHeight;
                              });
                            } else {
                              setState(() {
                                detailsHeight = maxHeight;
                              });
                            }
                          }
                        },
                        onVerticalDragUpdate: (DragUpdateDetails details) {
                          double positionY = details.globalPosition.dy;
                          double windowSize = MediaQuery.of(context).size.height;
                          double maxHeight = windowSize * 0.75;
                          double minHeight = size.height * 0.4 + dimmension(50, context);
                          double heightDifference = maxHeight - minHeight;
                          if (detailsHeight <= maxHeight) {
                            double differ = windowSize - (detailsHeight + positionY);
                            if (detailsHeight + differ < maxHeight &&
                                (detailsHeight + differ) > minHeight) {
                              double pathDis = maxHeight - minHeight;
                              double numerator = positionY - pathDis;
                              numerator = numerator < 0 ? 0 : numerator;
                              double denominator = ((windowSize - minHeight) - pathDis);
                              double percent = numerator / denominator;
                              percent = 1 - percent;
                              setState(() {
                                opacity = percent < 0.5 ? 0.5 : percent;
                                detailsHeight += differ;
                                goingUp = differ > 0;
                              });
                            }
                          }
                        },
                        child: Container(
                          width: size.width,
                          padding: EdgeInsets.symmetric(
                            vertical: dimmension(20, context),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(dimmension(30, context)),
                              topRight: Radius.circular(dimmension(30, context)),
                            ),
                          ),
                          child: FractionallySizedBox(
                            widthFactor: dimmension(50, context) / size.width,
                            child: Container(
                              height: dimmension(7, context),
                              decoration: BoxDecoration(
                                color: yellowColor.withOpacity(opacity),
                                borderRadius: BorderRadius.circular(dimmension(20, context)),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: dimmension(30, context)),
                      Text(
                        'اضافه کردن آدرس',
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      AddressForm(
                        isSending: isSending,
                        defaultAddress: defaultAddress,
                        onSubmit: (Map<String, dynamic> json, formContext) async {
                          Map<String, dynamic> newJson = {};
                          newJson.addAll(json);
                          if (_userPosition != null) {
                            setState(() {
                              isSending = true;
                            });
                            newJson.addAll({
                              'latitude': _userPosition!.latitude,
                              'longitude': _userPosition!.longitude,
                            });
                            bool res =
                                await accountService.addAddress(json: newJson).then((result) {
                              setState(() {
                                isSending = false;
                              });
                              return result;
                            });
                            if (res) {
                              showSnack('با موفقیت اضافه شد!', context, color: greenColor);
                              Navigator.pop(context);
                            } else {
                              showSnack('خطایی رخ داده است', context, color: redColor);
                            }
                          } else {
                            showSnack(
                              'لطفا مکان را از روی نقشه انتخاب کنید',
                              context,
                              color: redColor,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
