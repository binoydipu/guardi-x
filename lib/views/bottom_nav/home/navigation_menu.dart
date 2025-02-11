import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guardix/constants/colors.dart';
import 'package:guardix/views/bottom_nav/chat_view.dart';
import 'package:guardix/views/bottom_nav/home/home_view.dart';
import 'package:guardix/views/bottom_nav/report_view.dart';
import 'package:guardix/views/incidents/ongoing_incidents_view.dart';

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = [
    HomeView(),
    OngoingIncidentsView(),
    ReportView(),
    ChatView(),
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
              icon: Icon(
                Icons.live_help_outlined,
                color: blackColor,
              ),
              label: 'Incidents'),
          NavigationDestination(
              icon: Icon(
                Icons.report_gmailerrorred,
                color: blackColor,
                size: 26,
              ),
              label: 'Report'),
          NavigationDestination(
            icon: FaIcon(
              FontAwesomeIcons.comments,
              size: 21,
              color: blackColor,
            ),
            label: 'Chat',
          ),
        ],
      ),
      body: _widgetOptions[_selectedIndex],
    );
  }
}
