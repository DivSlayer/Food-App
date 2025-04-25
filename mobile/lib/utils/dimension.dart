import 'package:flutter/material.dart';

double dimmension(dynamic size, BuildContext context) {
  double convertSize;
  if (size.runtimeType == int) {
    convertSize = size.toDouble();
  } else if (size.runtimeType == double) {
    convertSize = size;
  } else {
    convertSize = double.parse(size);
  }
  if (MediaQuery.of(context).size.width < 700) {
    double width = MediaQuery.of(context).size.width;
    double stylingWidth = 420;
    return convertSize / stylingWidth * width;
  } else if (MediaQuery.of(context).size.width < 900) {
    double width = MediaQuery.of(context).size.width;
    double stylingWidth = 750;
    return convertSize / stylingWidth * width;
  } else if (MediaQuery.of(context).size.width < 1960) {
    double width = MediaQuery.of(context).size.width;
    double stylingWidth = 1080;
    return convertSize / stylingWidth * width;
  }
  double width = MediaQuery.of(context).size.width;
  double stylingWidth = 411.42;
  return convertSize / stylingWidth * width;
}
