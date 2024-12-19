import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

@immutable
class AuthUser {
  final String id;
  final String email;
  final bool isEmailVerified;

  const AuthUser({
    required this.id,
    required this.email,
    required this.isEmailVerified,
  });

  factory AuthUser.fromFirebase(User user) => AuthUser(
        id: user.uid,
        email: user
            .email!, // By using ! (null assertion operator), we tell the compiler: "We guarantee this value will not be null at this point, so treat it as non-null."
        isEmailVerified: user.emailVerified,
      );
}
