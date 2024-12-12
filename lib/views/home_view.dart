import 'package:flutter/material.dart';
import 'package:guardix/constants/colors.dart';
import 'package:guardix/constants/routes.dart';
import 'package:guardix/service/auth/auth_service.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: midnightBlueColor,
        foregroundColor: whiteColor,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.person),
          ),
          IconButton(
            onPressed: () async {
              await AuthService.firebase().logOut();
              // ignore: use_build_context_synchronously
              Navigator.of(context).pushNamedAndRemoveUntil(
                welcomeRoute,
                (route) => false,
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      drawer: const Drawer(
        backgroundColor: skyBlueColor,
        child: Text(
          'On Progress',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
