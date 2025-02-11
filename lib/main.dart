import 'package:flutter/material.dart';
import 'package:guardix/admin/actions/add_legal_info.dart';
import 'package:guardix/admin/actions/add_new_advocate.dart';
import 'package:guardix/admin/view/admin_panel.dart';
import 'package:guardix/constants/colors.dart';
import 'package:guardix/constants/routes.dart';
import 'package:guardix/service/auth/auth_constants.dart';
import 'package:guardix/views/bottom_nav/home/edit_profile_view.dart';
import 'package:guardix/views/forgot_password_view.dart';
import 'package:guardix/views/incidents/ongoing_incidents_view.dart';
import 'package:guardix/views/report/category_selection_view.dart';
import 'package:guardix/views/report/comments/comments_view.dart';
import 'package:guardix/views/report/edit_report_view.dart';
import 'package:guardix/views/report/report_details_view.dart';
import 'package:guardix/views/report/report_form_view.dart';
import 'package:guardix/views/verify_email_view.dart';
import 'package:guardix/service/auth/auth_service.dart';
import 'package:guardix/views/bottom_nav/home/navigation_menu.dart';
import 'package:guardix/views/about_us_view.dart';
import 'package:guardix/views/bottom_nav/home/home_view.dart';
import 'package:guardix/views/login_view.dart';
import 'package:guardix/views/register_view.dart';
import 'package:guardix/views/bottom_nav/report_view.dart';
import 'package:guardix/views/bottom_nav/sos_view.dart';
import 'package:guardix/views/bottom_nav/track_view.dart';
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
        brightness: Brightness.light,
        scaffoldBackgroundColor: appBackgroundColor,
        primaryColor: midnightBlueColor,
      ),
      home: const InitializeView(),
      routes: {
        welcomeRoute: (context) => const WelcomeView(),
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
        forgotPasswordRoute: (context) => const ForgotPasswordView(),
        initializeRout: (context) => const InitializeView(),
        navigationMenuRoute: (context) => const NavigationMenu(),
        homeRoute: (context) => const HomeView(),
        reportRoute: (context) => const ReportView(),
        trackRoute: (context) => const TrackView(),
        sosRoute: (context) => const SosView(),
        editProfileRoute: (context) => const EditProfileView(),
        aboutUsRoute: (context) => const AboutUsView(),
        adminPanelRoute: (context) => const AdminPanel(),
        selectCategoryRoute: (context) => const CategorySelectionView(),
        reportFormRoute: (context) => const ReportFormView(),
        ongoingIncidentsRoute: (context) => const OngoingIncidentsView(),
        reportDetailsRoute: (context) => const ReportDetailsView(),
        editReportRoute: (context) => const EditReportView(),
        addNewAdvocateRoute: (context) => const AddNewAdvocate(),
        addNewLegalInfoRoute: (context) => const AddLegalInfo(),
        reportCommentsRoute: (context) => const CommentsView(),
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
              if (user.email == adminEmail || user.isEmailVerified) {
                return const NavigationMenu();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const WelcomeView();
            }

          default:
            return Container(
              width: double.infinity,
              height: double.infinity,
              color: whiteColor,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
        }
      },
    );
  }
}
