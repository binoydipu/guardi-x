import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guardix/constants/colors.dart';
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
    // TrackView(),
    SosView(),
  ];

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
          NavigationDestination(icon: Icon(
              Icons.home_outlined,
              size: 32,
              color: blackColor,
            ), label: 'Home',),
          NavigationDestination(
            icon: FaIcon(
              FontAwesomeIcons.comment,
              size: 26,
              color: blackColor,
            ),
            label: 'Chat',
          ),
          NavigationDestination(
              icon: Icon(Icons.report_gmailerrorred, color: blackColor,), label: 'Report'),
          // NavigationDestination(
          //     icon: Icon(Icons.manage_search), label: 'Track'),
          NavigationDestination(icon: Icon(Icons.sos, color: blackColor,), label: 'SOS'),
        ],
      ),
      body: _widgetOptions[_selectedIndex],
    );
  }
}
