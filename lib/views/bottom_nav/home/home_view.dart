import 'package:flutter/material.dart';
import 'package:guardix/constants/colors.dart';
import 'package:guardix/constants/routes.dart';
import 'package:guardix/service/auth/auth_constants.dart';
import 'package:guardix/service/auth/auth_service.dart';
import 'package:guardix/enums/drawer_action.dart';
import 'package:guardix/views/drawer/app_language_view.dart';
import 'package:guardix/views/drawer/emergency_view.dart';
import 'package:guardix/views/drawer/location_view.dart';
import 'package:guardix/views/drawer/notification_view.dart';
import 'package:guardix/views/drawer/settings_view.dart';
import 'package:guardix/views/drawer/contacts/contacts_view.dart';
import 'package:guardix/views/bottom_nav/home_page.dart';
import 'package:guardix/views/drawer/legal_info/legal_info_view.dart';
import 'package:guardix/utilities/dialogs/logout_dialog.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  DrawerAction currentPage = DrawerAction.home;
  String? get userEmail => AuthService.firebase().currentUser!.email;

  @override
  Widget build(BuildContext context) {
    Widget container = const HomePage();
    
    if (currentPage == DrawerAction.home) {
      container = const HomePage();
    } else if (currentPage == DrawerAction.contacts) {
      container = const ContactsView();
    } else if (currentPage == DrawerAction.legalInfo) {
      container = const LegalInfoView();
    } else if (currentPage == DrawerAction.notification) {
      container = const NotificationView();
    } else if (currentPage == DrawerAction.location) {
      container = const LocationView();
    } else if (currentPage == DrawerAction.emergency) {
      container = const EmergencyView();
    } else if (currentPage == DrawerAction.language) {
      container = const AppLanguageView();
    } else if (currentPage == DrawerAction.settings) {
      container = const SettingsView();
    } else if (currentPage == DrawerAction.logout) {
      // DONE: Implemented Logout
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: midnightBlueColor,
        foregroundColor: whiteColor,
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Profile Drawer
            },
            icon: const Icon(Icons.person),
          ),
          IconButton(
            onPressed: () => _handleLogout(context),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: whiteColor,
        child: SingleChildScrollView(
          child: Column(
            children: [
              drawerList(),
              const Divider(color: softBlueColor),
              userEmail == adminEmail
                ? TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed(adminPanelRoute);
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.admin_panel_settings,
                        color: midnightBlueColor,
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Admin Panel',
                        style: TextStyle(
                          color: midnightBlueColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ) : const SizedBox(),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed(aboutUsRoute);
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.info_outlined,
                      color: midnightBlueColor,
                    ),
                    SizedBox(width: 5),
                    Text(
                      'About us',
                      style: TextStyle(
                        color: midnightBlueColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: container,
    );
  }

  Widget drawerList() {
    return Container(
      color: whiteColor,
      padding: const EdgeInsets.only(top: 60),
      child: Column(
        children: [
          menuItem(1, 'Home', Icons.home,
              currentPage == DrawerAction.home ? true : false),
          const Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 22, top: 8),
                child: Text(
                  'Support',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 18,
                    color: midnightBlueColor,
                    backgroundColor: whiteColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          menuItem(2, 'Contacts', Icons.contact_emergency,
              currentPage == DrawerAction.contacts ? true : false),
          menuItem(3, 'Legal Information', Icons.info,
              currentPage == DrawerAction.legalInfo ? true : false),
          const Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 22, top: 8),
                child: Text(
                  'Settings',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 18,
                    color: midnightBlueColor,
                    backgroundColor: whiteColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          menuItem(4, 'Notification', Icons.notifications,
              currentPage == DrawerAction.notification ? true : false),
          menuItem(5, 'Locations', Icons.location_on,
              currentPage == DrawerAction.location ? true : false),
          menuItem(6, 'Emergency', Icons.emergency,
              currentPage == DrawerAction.emergency ? true : false),
          menuItem(7, 'App Language', Icons.language,
              currentPage == DrawerAction.language ? true : false),
          menuItem(8, 'Settings', Icons.settings,
              currentPage == DrawerAction.settings ? true : false),
          menuItem(9, 'Logout', Icons.logout,
              currentPage == DrawerAction.logout ? true : false),
        ],
      ),
    );
  }

  Widget menuItem(int id, String title, IconData icon, bool selected) {
    return Material(
      color: selected ? lightGreyColor : Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          setState(() {
            if (id == 1) {
              currentPage = DrawerAction.home;
            } else if (id == 2) {
              currentPage = DrawerAction.contacts;
            } else if (id == 3) {
              currentPage = DrawerAction.legalInfo;
            } else if (id == 4) {
              currentPage = DrawerAction.notification;
            } else if (id == 5) {
              currentPage = DrawerAction.location;
            } else if (id == 6) {
              currentPage = DrawerAction.emergency;
            } else if (id == 7) {
              currentPage = DrawerAction.language;
            } else if (id == 8) {
              currentPage = DrawerAction.settings;
            }
          });
          if (id == 9) {
            _handleLogout(context);
          }
        },
        splashColor: softBlueColor,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Icon(
                  icon,
                  size: 22,
                  color: midnightBlueColor,
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  title,
                  style: const TextStyle(
                    color: midnightBlueColor,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _handleLogout(BuildContext context) async {
    bool isLoggedout = await showLogOutDialog(context);
    if(isLoggedout) {
      await AuthService.firebase().logOut();
      if(context.mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          welcomeRoute,
          (route) => false,
        );
      }
    }
  }
}
