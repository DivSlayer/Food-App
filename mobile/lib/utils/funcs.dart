import 'dart:math';
import 'package:food_app/models/order.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

Color fromHex(String hexString) {
  final buffer = StringBuffer();
  if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
  buffer.write(hexString.replaceFirst('#', ''));
  return Color(int.parse(buffer.toString(), radix: 16));
}

String capitalize(String value) {
  String newString = "";
  int current = 0;
  newString = value
      .split("")
      .map((e) {
        if (current == 0) {
          current += 1;
          return e.toUpperCase();
        } else {
          current += 1;
          return e;
        }
      })
      .toList()
      .join("");
  return newString;
}

setTimeOut({dynamic timeoutFunc, required Duration duration}) {
  Future.delayed(duration, timeoutFunc);
}

String formatTime(int seconds) {
  if (seconds < 0) {
    throw ArgumentError('Input should be a non-negative integer.');
  }
  int hours = seconds ~/ 3600;
  int remainingMinutes = (seconds % 3600) ~/ 60;
  int remainingSeconds = seconds % 60;
  String hoursStr = hours < 10 ? '0$hours' : '$hours';
  String minutesStr = remainingMinutes < 10 ? '0$remainingMinutes' : '$remainingMinutes';
  String secondsStr = remainingSeconds < 10 ? '0$remainingSeconds' : '$remainingSeconds';
  if (hoursStr != "00") {
    return '$hoursStr:$minutesStr:$secondsStr';
  }
  return '$minutesStr:$secondsStr';
}

String randomString(int length) {
  final random = Random();
  return String.fromCharCodes(
    Iterable.generate(
      length,
      (_) => random.nextInt(33) + 89,
    ),
  );
}

calculateDistance({
  required LatLng firstCord,
  required LatLng secondCord,
  bool stringed = true,
}) {
  const double R = 6371e3; // Earth's radius in meters
  double phi1 = firstCord.latitude * pi / 180;
  double phi2 = secondCord.latitude * pi / 180;
  double deltaPhi = (secondCord.latitude - firstCord.latitude) * pi / 180;
  double deltaLambda = (secondCord.longitude - firstCord.longitude) * pi / 180;

  double a = sin(deltaPhi / 2) * sin(deltaPhi / 2) +
      cos(phi1) * cos(phi2) * sin(deltaLambda / 2) * sin(deltaLambda / 2);
  double c = 2 * atan2(sqrt(a), sqrt(1 - a));

  double distance = R * c; // Distance in meters
  if (stringed == false) {
    return distance;
  }
  if (distance > 1000) {
    return "${(distance / 100).ceil() / 10}کیلو متر ";
  }

  return "${distance.floor()} متر";
}


String convertToJalali(DateTime dateTime) {
  // Convert to IRST (UTC+3:30) regardless of input time zone
  final utcDateTime = dateTime.toUtc();
  final iranDateTime = utcDateTime.add(const Duration(hours: 3, minutes: 30));

  // Convert to Jalali using the adjusted IRST time
  final gregorianDate = Gregorian.fromDateTime(iranDateTime);
  final jalaliDate = gregorianDate.toJalali();

  // Format date components with leading zeros
  final yy = (jalaliDate.year).toString().padLeft(4, '0');
  final mm = jalaliDate.month.toString().padLeft(2, '0');
  final dd = jalaliDate.day.toString().padLeft(2, '0');

  // Format time components from IRST-adjusted DateTime
  final hh = iranDateTime.hour.toString().padLeft(2, '0');
  final mn = iranDateTime.minute.toString().padLeft(2, '0');
  final ss = iranDateTime.second.toString().padLeft(2, '0');

  return '$yy-$mm-$dd $hh:$mn';
}


int calculatePrice(List<OrderModel> orders) {
  int extrasPrice = orders
      .map(
        (order) =>
        order.extras.map((extra) => extra.price * (extra.quantity)).reduce((a, b) => a + b),
  )
      .reduce((a, b) => a + b);

  int instructionsPrice = orders
      .map(
        (order) => order.instructions
        .map((instruction) => instruction.price * (instruction.quantity))
        .reduce((a, b) => a + b),
  )
      .reduce((a, b) => a + b);

  int foodsPrice = orders
      .map((order) => (order.food.sizes[0].price) * order.quantity)
      .reduce((a, b) => a + b);
  return foodsPrice + instructionsPrice + extrasPrice;
}