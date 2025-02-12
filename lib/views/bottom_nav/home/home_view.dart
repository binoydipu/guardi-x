import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guardix/constants/colors.dart';
import 'package:guardix/constants/routes.dart';
import 'package:guardix/service/auth/auth_constants.dart';
import 'package:guardix/service/auth/auth_service.dart';
import 'package:guardix/enums/drawer_action.dart';
import 'package:guardix/service/cloud/firebase_cloud_storage.dart';
import 'package:guardix/service/cloud/model/cloud_user.dart';

import 'package:guardix/utilities/helpers/local_storage.dart';
import 'package:guardix/utilities/dialogs/loading_dialog.dart';
import 'package:guardix/views/bottom_nav/sos_view.dart';
import 'package:guardix/views/drawer/app_language_view.dart';
import 'package:guardix/views/drawer/notification_view.dart';
import 'package:guardix/views/drawer/settings_view.dart';
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
  String? get userId => AuthService.firebase().currentUser!.id;
  late FirebaseCloudStorage _cloudStorage;
  CloudUser? cloudUser;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _cloudStorage = FirebaseCloudStorage();
    _getUser();
    super.initState();
  }

  Future<void> _getUser() async {
    try {
      final user = await _cloudStorage.getUser(userId: userId!);
      setState(() {
        cloudUser = user;
      });
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    Widget container = const HomePage();

    if (currentPage == DrawerAction.home) {
      container = const HomePage();
    } else if (currentPage == DrawerAction.legalInfo) {
      container = const LegalInfoView();
    } else if (currentPage == DrawerAction.sos) {
      container = const SosView();
    } else if (currentPage == DrawerAction.notification) {
      container = const NotificationView();
    } else if (currentPage == DrawerAction.language) {
      container = const AppLanguageView();
    } else if (currentPage == DrawerAction.settings) {
      container = const SettingsView();
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const FaIcon(
              FontAwesomeIcons.bars,
              size: 22,
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        backgroundColor: midnightBlueColor,
        foregroundColor: whiteColor,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: () {
                LocalStorage.getUserPhone();
                if (cloudUser != null) {
                  _showProfileDrawer(context);
                } else {
                  final closeDialog = showLoadingDialog(
                    context: context,
                    text: 'Loading..',
                  );
                  _getUser().then((_) {
                    closeDialog();
                    if (context.mounted) {
                      _showProfileDrawer(context);
                    }
                  });
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: whiteColor,
                    width: 2,
                  ),
                ),
                child: const CircleAvatar(
                  radius: 15,
                  backgroundImage: AssetImage('assets/images/profile_pic.png')
                      as ImageProvider,
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: whiteColor,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(height: 50, color: midnightBlueColor),
              Container(
                padding: const EdgeInsets.all(16),
                color: midnightBlueColor,
                child: const Row(
                  children: [
                    SizedBox(width: 10),
                    // CircleAvatar(
                    //   backgroundImage: AssetImage('assets/icon/icon.png'),
                    //   radius: 24,
                    // ),
                    FaIcon(
                      FontAwesomeIcons.shieldHalved,
                      size: 35,
                      color: whiteColor,
                    ),
                    SizedBox(width: 16),
                    Text(
                      'Guardi-X',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
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
                    )
                  : const SizedBox(),
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

  void _showProfileDrawer(BuildContext context) {
    if (cloudUser == null) {
      return;
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/images/profile_pic.png')
                    as ImageProvider,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    cloudUser!.userName,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  if (cloudUser!.isAdmin) const SizedBox(width: 5),
                  if (cloudUser!.isAdmin)
                    const Icon(
                      Icons.admin_panel_settings,
                      color: midnightBlueColor,
                    ),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                cloudUser!.email,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.phone, color: Colors.deepPurple),
                title: Text(cloudUser!.phone),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.blue),
                title: const Text('Edit Profile'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).pushNamed(editProfileRoute);
                },
              ),
              if (cloudUser!.isAdmin)
                ListTile(
                  leading: const Icon(Icons.admin_panel_settings,
                      color: midnightBlueColor),
                  title: const Text('Admin Panel'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).pushNamed(adminPanelRoute);
                  },
                ),
              ListTile(
                leading: const Icon(Icons.history, color: Colors.green),
                title: const Text('Case History'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).pushNamed(trackRoute);
                },
              ),
              ListTile(
                leading: const Icon(Icons.lock, color: Colors.orange),
                title: const Text('Change Password'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text('Logout'),
                onTap: () {
                  _handleLogout();
                  LocalStorage.removeUserData();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget drawerList() {
    return Container(
      color: whiteColor,
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          menuItem(1, 'Home', Icons.home, 25,
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
          menuItem(2, 'Legal Information', FontAwesomeIcons.scaleBalanced, 20,
              currentPage == DrawerAction.legalInfo ? true : false),
          menuItem(3, 'SOS Emergency', Icons.sos_rounded, 24,
              currentPage == DrawerAction.sos ? true : false),
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
          menuItem(4, 'Notification', FontAwesomeIcons.solidBell, 20,
              currentPage == DrawerAction.notification ? true : false),
          menuItem(5, 'App Language', FontAwesomeIcons.language, 20,
              currentPage == DrawerAction.language ? true : false),
          menuItem(6, 'Settings', Icons.settings, 23,
              currentPage == DrawerAction.settings ? true : false),
        ],
      ),
    );
  }

  Widget menuItem(
      int id, String title, IconData icon, double iconSize, bool selected) {
    return Material(
      color: selected ? lightGreyColor : Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          setState(() {
            if (id == 1) {
              currentPage = DrawerAction.home;
            } else if (id == 2) {
              currentPage = DrawerAction.legalInfo;
            } else if (id == 3) {
              currentPage = DrawerAction.sos;
            } else if (id == 4) {
              currentPage = DrawerAction.notification;
            } else if (id == 5) {
              currentPage = DrawerAction.language;
            } else if (id == 6) {
              currentPage = DrawerAction.settings;
            }
          });
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
                  size: iconSize,
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

  void _handleLogout() async {
    bool isLoggedout = await showLogOutDialog(context);
    if (isLoggedout) {
      await LocalStorage.removeUserData();
      await AuthService.firebase().logOut();
      if (context.mounted) {
        Navigator.of(_scaffoldKey.currentContext!).pushNamedAndRemoveUntil(
          welcomeRoute,
          (route) => false,
        );
      }
    }
  }
}
