import 'package:flutter/material.dart';
import 'package:guardix/constants/colors.dart';
import 'package:guardix/constants/routes.dart';
import 'package:guardix/service/auth/auth_exception.dart';
import 'package:guardix/service/auth/auth_service.dart';
import 'package:guardix/utilities/dialogs/error_dialog.dart';
import 'package:guardix/utilities/validation_utils.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _mobile;
  late final TextEditingController _password;
  late final TextEditingController _confirmPassword;

  String _emailErrorText =
      ''; // Will show message if email is not valid at the bottom of the text field
  String _mobileErrorText = '';
  String _passwordErrorText = '';
  String _confirmPasswordErrorText = '';

  bool emailValid = false;
  bool _mobileValid = false;
  bool _passwordValid = false;
  bool _confirmPasswordValid = false;

  @override
  void initState() {
    _email = TextEditingController();
    _mobile = TextEditingController();
    _password = TextEditingController();
    _confirmPassword = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _mobile.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(22.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Aligns the children to the left
            children: [
              const SizedBox(height: 65),
              const Text(
                'Create Account',
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
                  'Create an account so that you can join the movement for "Safer Communities"',
                  style: TextStyle(
                    color: blackColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),
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
                  // errorBorder: OutlineInputBorder(
                  //   borderSide: const BorderSide(
                  //     color: crimsonRedColor,
                  //     width: 2.5,
                  //   ),
                  //   borderRadius: BorderRadius.circular(10),
                  // ),
                  // errorText: _emailErrorText,
                ),
                onChanged: (value) {
                  // Update the error text based on validation
                  setState(() {
                    if (value.isNotEmpty &&
                        ValidationUtils.validateEmail(value)) {
                      _emailErrorText = '';
                      emailValid = true;
                    } else {
                      _emailErrorText = value.isEmpty
                          ? 'Please enter your  email address'
                          : 'Please enter a valid  email address';
                      emailValid = false;
                    }
                  });
                },
              ),
              //if (_emailErrorText.isNotEmpty) // no need this logic
              // This is for error message
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 16.0),
                child: Text(
                  _emailErrorText,
                  style: const TextStyle(color: crimsonRedColor, fontSize: 10),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _mobile,
                enableSuggestions: true,
                autocorrect: false,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 17, horizontal: 15),
                  label: const Text(
                    'Mobile Number',
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
                  // errorBorder: OutlineInputBorder(
                  //   borderSide: const BorderSide(
                  //     color: crimsonRedColor,
                  //     width: 2.5,
                  //   ),
                  //   borderRadius: BorderRadius.circular(10),
                  // ),
                  // errorText: _mobileErrorText,
                ),
                onChanged: (value) {
                  // Update the error text based on validation
                  setState(() {
                    if (value.isNotEmpty &&
                        ValidationUtils.validateMobile(value)) {
                      _mobileErrorText = '';
                      _mobileValid = true;
                    } else {
                      _mobileErrorText = value.isEmpty
                          ? 'Please enter your mobile nummber'
                          : 'Please enter a valid mobile number';
                      _mobileValid = false;
                    }
                  });
                },
              ),

              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 16.0),
                child: Text(
                  _mobileErrorText,
                  style: const TextStyle(color: crimsonRedColor, fontSize: 10),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _password,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                keyboardType: TextInputType.text,
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
                  // errorBorder: OutlineInputBorder(
                  //   borderSide: const BorderSide(
                  //     color: crimsonRedColor,
                  //     width: 2.5,
                  //   ),
                  //   borderRadius: BorderRadius.circular(10),
                  // ),
                ),
                onChanged: (value) {
                  // Update the error text based on validation
                  setState(() {
                    if (value.isNotEmpty &&
                        ValidationUtils.validatePassword(value)) {
                      _passwordErrorText = '';
                      _passwordValid = true;
                    } else {
                      _passwordErrorText = value.isEmpty
                          ? 'Please enter a strong password'
                          : 'Use at least an uppercase, a lowercase, a special character and a number. The length should be at least 6 and not more than 20';
                      _passwordValid = false;
                    }
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 16.0),
                child: Text(
                  _passwordErrorText,
                  style: const TextStyle(color: crimsonRedColor, fontSize: 10),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _confirmPassword,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 17, horizontal: 15),
                  label: const Text(
                    'Confirm Password',
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
                  // errorBorder: OutlineInputBorder(
                  //   borderSide: const BorderSide(
                  //     color: crimsonRedColor,
                  //     width: 2.5,
                  //   ),
                  //   borderRadius: BorderRadius.circular(10),
                  // ),
                ),
                onChanged: (value) {
                  // Update the error text based on validation
                  setState(() {
                    final password = _password.text;
                    final confirmPassword = _confirmPassword.text;
                    if (confirmPassword.isNotEmpty &&
                        (confirmPassword.compareTo(password) == 0)) {
                      _confirmPasswordErrorText = '';
                      _confirmPasswordValid = true;
                    } else {
                      _confirmPasswordErrorText = value.isEmpty
                          ? 'Please confirm password'
                          : 'Passwords not matched';
                      _confirmPasswordValid = false;
                    }
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 16.0),
                child: Text(
                  _confirmPasswordErrorText,
                  style: const TextStyle(color: crimsonRedColor, fontSize: 10),
                ),
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final email = _email.text;
                        final mobile = _mobile.text;
                        final password = _password.text;
                        final confirmPassword = _confirmPassword.text;

                        if (emailValid &&
                            _mobileValid &&
                            _passwordValid &&
                            _confirmPasswordValid) {
                          try {
                            await AuthService.firebase().createUser(
                              email: email,
                              password: password,
                            );

                            AuthService.firebase().sendEmailVerification();
                            Navigator.of(context).pushNamed(verifyEmailRoute);
                          } on Exception catch (e) {
                            print(e.toString());
                          } on WeakPasswordAuthException catch (_) {
                            await showErrorDialog(
                              context,
                              'weak-password',
                            );
                          } on EmailAlreadyInUseAuthException catch (_) {
                            await showErrorDialog(
                              context,
                              'Email is already in use',
                            );
                          } on InvalidEmailAuthException catch (_) {
                            await showErrorDialog(
                              context,
                              'Invalid Email',
                            );
                          } on GenericAuthException catch (e) {
                            print('So');
                            print(e.toString());
                            await showErrorDialog(
                              context,
                              'Failed to register',
                            );
                          }
                        }

                        Navigator.of(context).pushNamedAndRemoveUntil(
                          loginRoute,
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
                      child: const Text('Sign up'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/login/',
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
                  'Already have an account',
                  style: TextStyle(
                    color: blackColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 25),
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
