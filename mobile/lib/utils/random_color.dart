import 'package:flutter/material.dart';
import 'dart:math' as math;
Color randomColor(){
  return Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
}