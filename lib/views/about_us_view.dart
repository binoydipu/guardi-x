import 'package:flutter/material.dart';
import 'package:guardix/components/toast.dart';
import 'package:guardix/constants/colors.dart';
import 'package:url_launcher/url_launcher.dart';

const aboutGuardixApp =
    "Guardi-X is a security-focused mobile application designed to keep you and your loved ones safe. With features like real-time crime reporting, missing persons and items tracking, and chat with tructed contacts, Guardi-X ensures you're never alone in times of need. The app allows users to share their location with nearby individuals, family members, or authorities, ensuring help is always within reach. Stay informed, stay safe, with Guardi-X—your personal security companion.";

class AboutUsView extends StatelessWidget {
  const AboutUsView({super.key});

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
          'About',
          style: TextStyle(color: whiteColor),
        ),
        centerTitle: true,
        backgroundColor: midnightBlueColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              children: [
                const Text(
                  'Guardi-X',
                  style: TextStyle(
                    fontSize: 22,
                    color: midnightBlueColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Text(
                    'Version 1.0.0',
                    style: TextStyle(
                      fontSize: 14,
                      color: blackColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    aboutGuardixApp,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 14,
                      color: blackColor,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Text(
                    'This App is Developed by:',
                    style: TextStyle(
                      fontSize: 18,
                      color: midnightBlueColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildDeveloperCard(
                  name: 'Binoy Bhushan Barman Dipu',
                  institution: 'Leading University, Sylhet',
                  email: 'binoydipu@gmail.com',
                  imagePath: 'assets/images/binoy_pic.jpg',
                  socialMedia: [
                    _buildSocialIcon(
                        'facebook', 'https://facebook.com/binoy.dipu.9'),
                    _buildSocialIcon(
                        'linkedin', 'https://linkedin.com/in/binoydipu'),
                    _buildSocialIcon(
                        'github', 'https://github.com/binoydipu'),
                    _buildSocialIcon('mail',
                        'mailto:binoythe999@gmail.com'),
                    _buildSocialIcon(
                        'youtube', 'https://youtube.com/@binoydipu'),
                  ],
                ),
                const SizedBox(height: 10),
                _buildDeveloperCard(
                  name: 'Md. Ashfak Uzzaman Chowdhury',
                  institution: 'Leading University, Sylhet',
                  email: 'mdashfak0508@gmail.com',
                  imagePath: 'assets/images/ashfak_pic.jpg',
                  socialMedia: [
                    _buildSocialIcon(
                        'facebook', 'https://facebook.com/profile.php?id=100077962608844'),
                    _buildSocialIcon(
                        'linkedin', 'https://linkedin.com/in/ashfak-uzzaman-700931231'),
                    _buildSocialIcon(
                        'github', 'https://github.com/Ashfak-Uzzaman'),
                    _buildSocialIcon('mail',
                        'mailto:mdashfak0508@gmail.com'),
                    _buildSocialIcon(
                        'youtube', 'https://youtube.com/'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeveloperCard({
    required String name,
    required String institution,
    required String email,
    required String imagePath,
    required List<Widget> socialMedia,
  }) {
    return Card(
      elevation: 4,
      color: const Color.fromARGB(255, 216, 242, 246),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ClipOval(
              child: Image.asset(
                imagePath,
                width: 140,
                height: 140,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              name,
              style: const TextStyle(
                fontSize: 18,
                color: midnightBlueColor,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              institution,
              style: const TextStyle(
                fontSize: 14,
                color: blackColor,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            const Text(
              'CSE Batch - 59',
              style: TextStyle(
                fontSize: 14,
                color: blackColor,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              email,
              style: const TextStyle(
                fontSize: 14,
                color: blackColor,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: socialMedia,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialIcon(String iconName, String url) {
    return IconButton(
      icon: Image(
        image: AssetImage('assets/icon/${iconName}_icon.png'),
        width: 21,
        height: 21,
        fit: BoxFit.contain,
      ),
      onPressed: () {
        _openLink(url);
      },
    );
  }

  void _openLink(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      showToast('Can\'t launch URL');
    }
  }
}
