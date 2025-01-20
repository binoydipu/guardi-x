import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guardix/constants/colors.dart';
import 'package:guardix/constants/routes.dart';
import 'package:guardix/views/verify_email_view.dart';
import 'package:guardix/service/auth/auth_service.dart';
import 'package:guardix/navigation_menu.dart';
import 'package:guardix/views/about_us_view.dart';
import 'package:guardix/views/home_view.dart';
import 'package:guardix/views/login_view.dart';
import 'package:guardix/views/register_view.dart';
import 'package:guardix/views/report_view.dart';
import 'package:guardix/views/sos_view.dart';
import 'package:guardix/views/track_view.dart';
import 'package:guardix/views/welcome_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Guardi-X',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: midnightBlueColor),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: midnightBlueColor,
            statusBarBrightness: Brightness.dark,
          ),
        ),
      ),
      home: const InitializeView(),
      routes: {
        welcomeRoute: (context) => const WelcomeView(),
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
        initializeRout: (context) => const InitializeView(),
        navigationMenuRoute: (context) => const NavigationMenu(),
        homeRoute: (context) => const HomeView(),
        reportRoute: (context) => const ReportView(),
        trackRoute: (context) => const TrackView(),
        sosRoute: (context) => const SosView(),
        aboutUsRoute: (context) => const AboutUsView(),
      },
    );
  }
}

class InitializeView extends StatelessWidget {
  const InitializeView({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;

            if (user != null) {
              if (user.isEmailVerified) {
                //print('Email is verified');

                return const NavigationMenu();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const WelcomeView();
            }

          default:
            //return const Text('Loading...');
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
