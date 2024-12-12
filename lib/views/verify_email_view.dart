import 'package:flutter/material.dart';
import 'package:guardix/constants/colors.dart';
import 'package:guardix/constants/routes.dart';
import 'package:guardix/service/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 100,
            ),
            const Icon(
              Icons.mark_email_unread_outlined,
              color: midnightBlueColor,
              size: 100,
            ),
            const SizedBox(
              height: 50,
            ),
            const Text(
              'Verify Your Email',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: midnightBlueColor),
            ),
            const SizedBox(
              height: 30,
            ),
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                '''We have just send email verification link on your email. Please check email and click on that link to verify your Email address.
                \nAfter verification, click on the Continue button.''',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
                onPressed: () async {
                  await AuthService.firebase().logOut();
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    welcomeRoute,
                    (route) => false,
                  );
                },
                child: const Text(
                  'Continue',
                  style: TextStyle(fontSize: 18),
                )),
            const SizedBox(
              height: 50,
            ),
            TextButton(
              onPressed: () async {
                await AuthService.firebase().sendEmailVerification();
                // this function returns a future. So we need to use await to wait on it. because we have to wait for future
              },
              child: const Text(
                'Resend Send Email Verification?',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: skyBlueColor),
              ),
            ),
            const SizedBox(
              height: 150,
            ),
          ],
        ),
      ),
    );
  }
}
