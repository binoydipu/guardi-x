import 'package:flutter/material.dart';
import 'package:guardix/constants/colors.dart';
import 'package:guardix/service/auth/auth_exception.dart';
import 'package:guardix/service/auth/auth_service.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(22.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 65),
              const Text(
                'Login Here',
                style: TextStyle(
                  color: midnightBlueColor,
                  fontSize: 33,
                  fontWeight: FontWeight.w900,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  '"Stay Connected, Stay Protected"',
                  style: TextStyle(
                    color: blackColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 70),
              TextField(
                controller: _email,
                enableSuggestions: false,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 17, horizontal: 15),
                  label: const Text(
                    'Email',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                  filled: true,
                  fillColor: const Color.fromARGB(18, 0, 53, 102),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: midnightBlueColor,
                      width: 2.5,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: crimsonRedColor,
                      width: 2.5,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _password,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 17, horizontal: 15),
                  label: const Text(
                    'Password',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                  filled: true,
                  fillColor: const Color.fromARGB(18, 0, 53, 102),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: midnightBlueColor,
                      width: 2.5,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: crimsonRedColor,
                      width: 2.5,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () async {},
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text(
                      'Forgot your password?',
                      style: TextStyle(
                        color: midnightBlueColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        final email = _email.text;
                        final password = _password.text;
/*
              try {
                await AuthService.firebase().logIn(
                  email: email,
                  password: password,
                );
                final user = AuthService.firebase().currentUser;

                if (user?.isEmailVerified ?? false) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    notesRoute,
                    (route) =>
                        false, // This predicate ensures that all previous routes are removed.
                  );
                } else {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    verifyEmailRoute,
                    (route) =>
                        false, // This predicate ensures that all previous routes are removed.
                  );
                }

                // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const NotesView()),(route) => false,);
                //Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) => const NotesView()),(route) => false,);
                // Navigator.pushNamedAndRemoveUntil(context, '/notes/', (route) => false);
                //Navigator.of(context).pushNamedAndRemoveUntil(...) method pushes a named route onto the navigator stack and removes all previous routes until the given predicate returns true.
              } on UserNotFoundAuthException {
                await showErrorDialog(context, 'User not found');
              } on WrongPasswordAuthException {
                await showErrorDialog(context, 'Wrong password');
              } on GenericAuthException {
                await showErrorDialog(context, 'Authantication Error');
              }
*/
                        ///
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          '/home/',
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: midnightBlueColor,
                        elevation: 2,
                        shadowColor: midnightBlueColor,
                        foregroundColor: whiteColor,
                        textStyle: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Sign in'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/register/',
                    (route) => false,
                  );
                },
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  'Create new account',
                  style: TextStyle(
                    color: blackColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 50),
              const Text(
                'Or continue with',
                style: TextStyle(
                  color: skyBlueColor,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: lightGreyColor,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                          vertical: 11, horizontal: 20),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Image.network(
                      'https://cdn-icons-png.flaticon.com/128/6424/6424087.png',
                      width: 22,
                      height: 22,
                      color: midnightBlueColor,
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: lightGreyColor,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 18),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Image.network(
                      'https://img.icons8.com/?size=50&id=118467&format=png',
                      width: 25,
                      height: 25,
                      color: midnightBlueColor,
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: lightGreyColor,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 18),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Image.network(
                      'https://img.icons8.com/?size=30&id=95294&format=png',
                      width: 25,
                      height: 25,
                      color: midnightBlueColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
