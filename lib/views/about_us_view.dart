import 'package:flutter/material.dart';
import 'package:guardix/constants/colors.dart';

class AboutUsView extends StatelessWidget {
  const AboutUsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: midnightBlueColor,
        foregroundColor: whiteColor,
        title: const Text(
          'About Us',
          style: TextStyle(
            color: whiteColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    'This App is Developed by:',
                    style: TextStyle(
                      fontSize: 18,
                      color: blackColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(
                  Icons.person,
                  size: 200,
                ),
                Text(
                  'Binoy Bhushan Barman Dipu',
                  style: TextStyle(
                    fontSize: 18,
                    color: midnightBlueColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Leading University, Sylhet',
                  style: TextStyle(
                    fontSize: 16,
                    color: midnightBlueColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  'Email: binoydipu@gmail.com',
                  style: TextStyle(
                    fontSize: 16,
                    color: midnightBlueColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Icon(
                  Icons.person,
                  size: 200,
                ),
                Text(
                  'Md. Ashfak Uzzaman Chowdhury',
                  style: TextStyle(
                    fontSize: 18,
                    color: midnightBlueColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Leading University, Sylhet',
                  style: TextStyle(
                    fontSize: 16,
                    color: midnightBlueColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  'Email: mdashfak0508@gmail.com',
                  style: TextStyle(
                    fontSize: 16,
                    color: midnightBlueColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
