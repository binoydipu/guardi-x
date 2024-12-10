import 'package:flutter/material.dart';
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
      appBar: AppBar(
        title: const Text('Verify Email'),
      ),
      body: Column(
        children: [
          const Text('Verify Your Email'),
          ElevatedButton(
              onPressed: () async {
                await AuthService.firebase().sendEmailVerification();
                // this function returns a future. So we need to use await to wait on it. because we have to wait for future
              },
              child: const Text('Send Email Verification')),
          TextButton(
            onPressed: () async {
              await AuthService.firebase().logOut();
              Navigator.of(context).pushNamedAndRemoveUntil(
                registerRoute,
                (route) => false,
              );
            },
            child: const Text('Restart'),
          )
        ],
      ),
    );
  }
}
