import 'package:flutter/material.dart';

Container buildBannerFromImage({
  required String imageUrl,
  double? height,
  double? width,
  Color? color,
  BoxBorder? border,
  BoxFit? fit,
  double borderRadius = 0,
}) {
  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      border: border,
      color: color,
      borderRadius: BorderRadius.circular(borderRadius),
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Image(fit: fit, image: AssetImage(imageUrl) as ImageProvider),
    ),
  );
}
