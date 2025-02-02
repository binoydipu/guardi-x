import 'package:flutter/material.dart';
import 'package:guardix/constants/colors.dart';
import 'package:guardix/constants/services_and_numbers.dart';
import 'package:url_launcher/url_launcher.dart';

class SosView extends StatefulWidget {
  const SosView({super.key});

  @override
  State<SosView> createState() => _SosViewState();
}

class _SosViewState extends State<SosView> {
  void _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );

    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch the dialer')),
      );
    }
    /*if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw 'Could not launch $phoneNumber';
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SOS Emergency',
          style: TextStyle(color: whiteColor),
        ),
        centerTitle: true,
        backgroundColor: midnightBlueColor,
      ),
      body: ListView.builder(
          padding: const EdgeInsets.only(top: 25.0, left: 25.0, right: 25.0),
          itemCount: 6,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(25, 0, 25, 25),
              child: ElevatedButton(
                onPressed: () => _makePhoneCall(numbers[index]),
                style: ElevatedButton.styleFrom(
                  backgroundColor: midnightBlueColor,
                  elevation: 2,
                  shadowColor: midnightBlueColor,
                  foregroundColor: whiteColor,
                  textStyle: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 15,
                  ),
                  minimumSize: const Size.fromHeight(100),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                child: Text(
                  services[index],
                  textAlign: TextAlign.center,
                ),
              ),
            );
          },
        ),
    );
  }
}
