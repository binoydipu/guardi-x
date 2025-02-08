import 'package:flutter/material.dart';
import 'package:guardix/constants/colors.dart';

void showSnackBar(
  BuildContext context,
  String message,
) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Center(child: Text(message)),
      backgroundColor: blackColor,
    ),
  );
}