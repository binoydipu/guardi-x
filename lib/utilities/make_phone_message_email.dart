import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:guardix/components/snack_bar.dart';
import 'package:guardix/components/toast.dart';

import 'package:url_launcher/url_launcher.dart';

void makePhoneCall(BuildContext context, String phoneNumber) async {
  final Uri phoneUri = Uri(
    scheme: 'tel',
    path: phoneNumber,
  );

  if (await canLaunchUrl(phoneUri)) {
    await launchUrl(phoneUri);
  } else {
    //showSnackBar('Could not launch the dialer');
    if (context.mounted) {
      showSnackBar(context, 'Could not launch the dialer');
    }
  }
}

void sendMessage(
    BuildContext context, String phoneNumber, String message) async {
  final Uri smsUri = Uri(
    scheme: 'sms',
    path: phoneNumber,
    queryParameters: {
      'body': message,
    },
  );

  if (await canLaunchUrl(smsUri)) {
    await launchUrl(smsUri);
  } else {
    if (context.mounted) {
      showSnackBar(context, 'Could not launch the messaging app');
    }
  }
}

void sendBackgroundMessage(
    BuildContext context, String phone, String message) async {
  const platform = MethodChannel('smsChannel');
  try {
    // funtion inside .kt :  private fun sendSMS(phone: String, message: String)  --java-->  private void sendSMS(String phone, String message)
    await platform.invokeMethod('sendSMS', {
      'phone': phone,
      'message': message,
    });
  } catch (e) {
    showToast('Error to send emergency SMS');
  }
}
