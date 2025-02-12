import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guardix/constants/colors.dart';
import 'package:guardix/service/cloud/cloud_storage_constants.dart';

import 'package:guardix/utilities/helpers/generate_location_link.dart';
import 'package:guardix/utilities/helpers/local_storage.dart';
import 'package:guardix/utilities/helpers/make_phone_message_email.dart';

import 'package:guardix/utilities/helpers/shake_detector.dart';
import 'package:guardix/views/bottom_nav/chat_view.dart';
import 'package:guardix/views/bottom_nav/home/home_view.dart';
import 'package:guardix/views/bottom_nav/report_view.dart';
import 'package:guardix/views/bottom_nav/sos_view.dart';

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = [
    HomeView(),
    ChatView(),
    ReportView(),
    SosView(),
  ];

  late ShakeDetector _shakeDetector;

  @override
  void initState() {
    _shakeDetector = ShakeDetector(
      onShake: () async {
        //print('shake...');

        bool isEmergency = await LocalStorage.getEmergencyStatus() ?? true;

        if (isEmergency) {
          List<String> x = await LocalStorage.getTrustedContacts();

          final message =
              'I need emergency help! I\'m at ${await generateLocationLink()}.';
          final String userNumber = await LocalStorage.getUserPhone() ?? '';
          String receiverNumber = '';
          // ignore: unused_local_variable
          String senderNumber = '';

// 01643216242_01736361622
          for (int i = 0; i < x.length; ++i) {
            //             String senderPhone,
            // String receiverPhone,
            // String senderName,
            // String receiverName,
            // String message,
            // String chatRoomId,
            // DocumentReference chatRoomReference,

            if (x[i].substring(0, 11).compareTo(userNumber) == 0) {
              receiverNumber = x[i].substring(12);
              senderNumber = x[i].substring(0, 11);
            } else {
              receiverNumber = x[i].substring(0, 11);
              senderNumber = x[i].substring(12);
            }

            //FirebaseCloudStorage.sendMessage(receiverNumber, senderNumber);
            if (receiverNumber.compareTo(adminNumber) == 0) continue;
            sendBackgroundMessage(receiverNumber, message);
          }
        }
      },
    );
    _shakeDetector.startListening();
    super.initState();
  }

  @override
  void dispose() {
    _shakeDetector.stopListening();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        height: 80,
        elevation: 0,
        indicatorColor: softBlueColor,
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        surfaceTintColor: blackColor,
        backgroundColor: whiteColor,
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _onItemTapped(index);
          });
        },
        destinations: const [
          NavigationDestination(
            // icon: Image(
            //   image: AssetImage('assets/icon/home_icon.png'),
            //   width: 21,
            //   height: 21,
            //   fit: BoxFit.contain,
            // ),
            icon: Icon(
              Icons.home_outlined,
              size: 28,
              color: blackColor,
            ),
            label: 'Home',
          ),
          NavigationDestination(
            icon: FaIcon(
              FontAwesomeIcons.comments,
              size: 21,
              color: blackColor,
            ),
            label: 'Chat',
          ),
          NavigationDestination(
              icon: Icon(
                Icons.report_gmailerrorred,
                color: blackColor,
                size: 26,
              ),
              label: 'Report'),
          NavigationDestination(
              icon: Icon(
                Icons.sos,
                color: blackColor,
                size: 26,
              ),
              label: 'SOS'),
        ],
      ),
      body: _widgetOptions[_selectedIndex],
    );
  }
}
