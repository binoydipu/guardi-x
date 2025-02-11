import 'package:flutter/material.dart';
import 'package:guardix/constants/colors.dart';

Widget buildCard({
  required BuildContext context,
  required IconData icon,
  double? iconSize,
  required String text,
  required VoidCallback onTap,
}) {
  return Container(
    height: 130, 
    width: 120,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16.0),
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color.fromARGB(255, 245, 245, 245), Color.fromARGB(255, 206, 244, 249)], 
      ),
      boxShadow: const [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 4.0,
          offset: Offset(2.0, 2.0),
        ),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.0),
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: iconSize ?? 45,
              color: blackColor,
            ),
            const SizedBox(height: 5),
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: blackColor,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}