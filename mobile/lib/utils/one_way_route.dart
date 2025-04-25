import 'package:flutter/material.dart';

oneWayRoute({required BuildContext context, required Widget screen}) {
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => screen,
      ), (r) {
    return false;
  });
}
