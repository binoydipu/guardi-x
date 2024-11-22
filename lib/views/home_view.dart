import 'package:flutter/material.dart';
import 'package:guardix/constants/colors.dart';

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
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/welcome/',
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
