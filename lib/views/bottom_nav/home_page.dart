import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:guardix/constants/colors.dart';
import 'package:guardix/constants/routes.dart';
import 'package:guardix/utilities/decorations/banner_image_decoration.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> _bannerImageUrls = [
    "assets/images/pic2.jpg",
    "assets/images/pic1.jpg",
    "assets/images/pic2.jpg",
    "assets/images/pic3.jpg",
    "assets/images/pic1.jpg",
  ];

  void _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );

    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      _showSnackBar('Could not launch the dialer');
    }
  }

  void _sendMessage(String phoneNumber) async {
    final Uri smsUri = Uri(
      scheme: 'sms',
      path: phoneNumber,
    );

    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    } else {
      _showSnackBar('Could not launch the messaging app');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  int _currentBannerId = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Column(
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                    // height: 180.0,
                    aspectRatio: 16 / 8,
                    viewportFraction: 0.8,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 3),
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    enlargeFactor: 0.3,
                    scrollDirection: Axis.horizontal,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentBannerId = index;
                      });
                    },
                  ),
                  items: _bannerImageUrls.map((imageUrl) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                            color: crimsonRedColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: buildBannerDecoration(
                            imageUrl: imageUrl,
                            borderRadius: 15,
                            color: softBlueColor,
                            fit: BoxFit.fill,
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int i = 0; i < _bannerImageUrls.length; i++)
                      Container(
                        width: i == _currentBannerId ? 20 : 10,
                        height: i == _currentBannerId ? 4 : 3,
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: i == _currentBannerId ? midnightBlueColor : softBlueColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: 140,
                          width: 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                whiteColor,
                                softBlueColor,
                              ],
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: lightGreyColor,
                                blurRadius: 3.0,
                                offset: Offset(2.0, 2.0),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed(selectCategoryRoute);
                              },
                              child: const Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(
                                    Icons.report,
                                    size: 50,
                                  ),
                                  Text(
                                    'Want to report a crime?',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: blackColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          height: 140,
                          width: 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                whiteColor,
                                softBlueColor,
                              ],
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: lightGreyColor,
                                blurRadius: 3.0,
                                offset: Offset(2.0, 2.0),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).pushNamed(trackRoute);
                              },
                              child: const Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(
                                    Icons.history,
                                    size: 50,
                                  ),
                                  Text(
                                    'View Your Case History',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: blackColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          height: 140,
                          width: 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                whiteColor,
                                softBlueColor,
                              ],
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: lightGreyColor,
                                blurRadius: 3.0,
                                offset: Offset(2.0, 2.0),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed(ongoingIncidentsRoute);
                              },
                              child: const Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(
                                    Icons.live_help,
                                    size: 50,
                                  ),
                                  Text(
                                    'Ongoing Incidents',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: blackColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 350,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: safetyOrangeColor,
                      boxShadow: const [
                        BoxShadow(
                          color: lightGreyColor,
                          blurRadius: 3.0,
                          offset: Offset(2.0, 2.0),
                        ),
                      ],
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.map_outlined,
                            size: 80,
                          ),
                          Text(
                            'Google Map Here',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: blackColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Find Expert Advocates for Your Legal Needs',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: blackColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            constraints: const BoxConstraints(
                              minWidth: 150,
                              maxWidth: 200,
                            ),
                            decoration: BoxDecoration(
                              color: softBlueColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  'assets/images/lawyer_icon.png',
                                  height: 50,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Mr. Abc Xyz',
                                        style: TextStyle(
                                          color: midnightBlueColor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Text(
                                        'Crime Lawyer',
                                        style: TextStyle(
                                          color: blackColor,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          IconButton(
                                            onPressed: () =>
                                                _makePhoneCall('123999'),
                                            icon: const Icon(
                                              Icons.call,
                                              color: midnightBlueColor,
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () =>
                                                _sendMessage('123999'),
                                            icon: const Icon(
                                              Icons.message,
                                              color: midnightBlueColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            constraints: const BoxConstraints(
                              minWidth: 150,
                              maxWidth: 200,
                            ),
                            decoration: BoxDecoration(
                              color: softBlueColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  'assets/images/lawyer_icon.png',
                                  height: 50,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Mr. Abc Xyz',
                                        style: TextStyle(
                                          color: midnightBlueColor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Text(
                                        'Crime Lawyer',
                                        style: TextStyle(
                                          color: blackColor,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          IconButton(
                                            onPressed: () =>
                                                _makePhoneCall('123888'),
                                            icon: const Icon(
                                              Icons.call,
                                              color: midnightBlueColor,
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () =>
                                                _sendMessage('123888'),
                                            icon: const Icon(
                                              Icons.message,
                                              color: midnightBlueColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
