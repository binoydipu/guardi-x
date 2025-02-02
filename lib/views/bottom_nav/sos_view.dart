import 'package:flutter/material.dart';
import 'package:guardix/constants/colors.dart';
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
      body: ListView(
        padding: const EdgeInsets.only(top: 25.0, left: 25.0, right: 25.0),
        children: [
          ElevatedButton(
            onPressed: () => _makePhoneCall('999'),
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
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text(
              'National Emergency Service',
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          ElevatedButton(
            onPressed: () => _makePhoneCall('109'),
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
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text(
              'Prevent Violence or Trafficking of Women and Children',
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          ElevatedButton(
            onPressed: () => _makePhoneCall('16263'),
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
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text(
              'Ambulance Service',
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          ElevatedButton(
            onPressed: () => _makePhoneCall('16430'),
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
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text(
              'Government Legal Assistance',
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          ElevatedButton(
            onPressed: () => _makePhoneCall('106'),
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
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text(
              'Anti-Corruption Commission Helpline',
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          ElevatedButton(
            onPressed: () => _makePhoneCall('1090'),
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
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text(
              'Disaster Early Warning',
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
