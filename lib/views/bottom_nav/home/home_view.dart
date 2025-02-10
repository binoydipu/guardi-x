import 'package:flutter/material.dart';
import 'package:guardix/constants/colors.dart';
import 'package:guardix/constants/routes.dart';
import 'package:guardix/service/auth/auth_constants.dart';
import 'package:guardix/service/auth/auth_service.dart';
import 'package:guardix/enums/drawer_action.dart';
import 'package:guardix/service/cloud/firebase_cloud_storage.dart';
import 'package:guardix/service/cloud/model/cloud_user.dart';
import 'package:guardix/utilities/helpers/local_storage.dart';
import 'package:guardix/utilities/dialogs/loading_dialog.dart';
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
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: midnightBlueColor,
        foregroundColor: whiteColor,
        actions: [
          IconButton(
            onPressed: () {
              LocalStorage.getUserPhone();
              if(cloudUser != null) {
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
            icon: const Icon(Icons.account_circle_outlined),
          ),
          // IconButton(onPressed: () => _handleLogout(), icon: const Icon(Icons.logout),),
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

  void _handleLogout() async {
    bool isLoggedout = await showLogOutDialog(context);
    if (isLoggedout) {
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
