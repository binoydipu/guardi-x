import 'package:fluttertoast/fluttertoast.dart';
import 'package:guardix/constants/colors.dart';

void showToast(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: softBlueColor,
      textColor: blackColor,
      fontSize: 16.0);
}