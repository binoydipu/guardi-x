import 'package:flutter/material.dart';
import 'package:guardix/constants/colors.dart';

InputDecoration buildInputDecoration({
  required String label
}) {
  return InputDecoration(
    contentPadding: const EdgeInsets.symmetric(vertical: 17, horizontal: 15),
    label: Text(
      label,
      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
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
        width: 2.5,
      ),
      borderRadius: BorderRadius.circular(10),
    ),
  );
}
