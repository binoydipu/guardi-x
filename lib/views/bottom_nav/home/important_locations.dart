import 'package:flutter/material.dart';
import 'package:guardix/constants/colors.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> _openMap(String location, BuildContext context) async {
  String googleUrl = 'https://www.google.com/maps/search/$location';
  final Uri url = Uri.parse(googleUrl);
  try {
    await launchUrl(url);
  } catch (e) {
    if(context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch the dialer')),
      );
    }
  }
}

Widget buildLocations({
  required BuildContext context,
}) {
  return SizedBox(
    height: 125,
    child: GridView.count(
      scrollDirection: Axis.horizontal,
      crossAxisCount: 1,
      crossAxisSpacing: 10,
      children: [
        buildButton(
          onPressed: () {
            _openMap('Police Station', context);
          },
          color: midnightBlueColor,
          icon: Icons.local_police,
          text: 'Police Stations',
        ),
        buildButton(
          onPressed: () {
            _openMap('Fire Service', context);
          },
          color: const Color.fromARGB(255, 255, 119, 0),
          icon: Icons.fire_truck,
          text: 'Fire Service',
        ),
        buildButton(
          onPressed: () {
            _openMap('Hospitals', context);
          },
          color: const Color.fromARGB(255, 191, 13, 0),
          icon: Icons.local_hospital,
          text: 'Hospitals',
        ),
        buildButton(
          onPressed: () {
            _openMap('Pharmacy', context);
          },
          color: Colors.green,
          icon: Icons.local_pharmacy,
          text: 'Pharmacy',
        ),
        buildButton(
          onPressed: () {
            _openMap('Bus Station', context);
          },
          color: Colors.blue,
          icon: Icons.bus_alert,
          text: 'Bus Station',
        ),
        buildButton(
          onPressed: () {
            _openMap('Train Station', context);
          },
          color: Colors.blueGrey,
          icon: Icons.train,
          text: 'Train Station',
        ),
        buildButton(
          onPressed: () {
            _openMap('Hotel', context);
          },
          color: Colors.purple,
          icon: Icons.hotel,
          text: 'Hotel',
        ),
        buildButton(
          onPressed: () {
            _openMap('ATM Booth', context);
          },
          color: const Color.fromARGB(154, 30, 110, 147),
          icon: Icons.atm,
          text: 'ATM',
        ),
      ],
    ),
  );
}

Widget buildButton({
  required VoidCallback onPressed,
  required Color color,
  required IconData icon,
  required String text,
}) {
  return SizedBox(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          elevation: 4,
          shadowColor: color,
          padding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 15,
          ),
          minimumSize: const Size.fromHeight(100),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
            ),
            const SizedBox(height: 10),
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: whiteColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ),
  );
}
