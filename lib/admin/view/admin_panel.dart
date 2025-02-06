import 'package:flutter/material.dart';
import 'package:guardix/constants/colors.dart';
import 'package:guardix/constants/routes.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: whiteColor,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            : null,
        title: const Text(
          'Admin Panel',
          style: TextStyle(color: whiteColor),
        ),
        centerTitle: true,
        backgroundColor: midnightBlueColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(addNewAdvocateRoute);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: midnightBlueColor,
                      elevation: 2,
                      shadowColor: midnightBlueColor,
                      foregroundColor: whiteColor,
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text(
                      'Add New Advocate',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
