import 'package:flutter/material.dart';
import 'package:guardix/constants/colors.dart';

InputDecoration buildInputDecoration({
  required String label,
  Widget? prefixIcon,
  Widget? suffixIcon,
}) {
  return InputDecoration(
    contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
    label: Text(
      label,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
    ),
    filled: true,
    fillColor: textInputFillColor,
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(10),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        color: midnightBlueColor,
        width: 2,
      ),
      borderRadius: BorderRadius.circular(10),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        color: crimsonRedColor,
        width: 2,
      ),
      borderRadius: BorderRadius.circular(10),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        color: crimsonRedColor,
        width: 2,
      ),
      borderRadius: BorderRadius.circular(10),
    ),
    errorStyle: const TextStyle(color: crimsonRedColor),
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
  );
}
