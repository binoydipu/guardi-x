import 'package:flutter/material.dart';
import 'package:guardix/constants/colors.dart';

Widget buildStatus({
  required String reportStatus,
}) {
  Color? boxColor;
  Color? textColor;
  if (reportStatus == 'Resolved') {
    boxColor = Colors.green[50];
    textColor = Colors.green;
  } else if (reportStatus == 'Closed') {
    boxColor = Colors.blue[50];
    textColor = midnightBlueColor;
  } else if (reportStatus == 'Rejected') {
    boxColor = Colors.red[50];
    textColor = crimsonRedColor;
  } else if (reportStatus == 'Under Review') {
    boxColor = Colors.deepOrange[50]; 
    textColor = Colors.deepOrange;  
  } else {
    boxColor = Colors.orange[50];
    textColor = Colors.orange;
  }

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
    decoration: BoxDecoration(
      color: boxColor,
      borderRadius: BorderRadius.circular(12.0),
    ),
    child: Text(
      reportStatus,
      style: TextStyle(
        color: textColor,
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
