import 'package:flutter/material.dart';

Container buildBannerDecoration({
  required String title,
  required String text,
  double? height,
  double? width,
  required List<Color> backgroundColor,
  Color? titleColor,
  Color? textColor,
  double borderRadius = 0,
}) {
  return Container(
    width: width,
    height: height,
    constraints: (width == null && height == null)
        ? const BoxConstraints() 
        : const BoxConstraints(), 
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: backgroundColor,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(borderRadius),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: titleColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor,
              fontSize: 16,
            ),
          ),
        ),
      ],
    ),
  );
}

/*
import 'package:flutter/material.dart';

Container buildBannerDecoration({
  required String title,
  required String text,
  double? height,
  double? width,
  Color? backgroundColor,
  Color? titleColor,
  Color? textColor,
  double borderRadius = 0,
}) {
  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(borderRadius),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: titleColor,
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}

*/