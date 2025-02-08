import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guardix/service/cloud/cloud_storage_constants.dart';
import 'package:flutter/foundation.dart';

@immutable
class CloudUser {
  final String userId;
  final String userName;
  final String email;
  final String phone;

  const CloudUser({
    required this.userId,
    required this.userName,
    required this.email,
    required this.phone,
  });

  CloudUser.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : userId = snapshot.id,
        userName = snapshot.data()[userNameFieldName] as String,
        email = snapshot.data()[userEmailFieldName] as String,
        phone = snapshot.data()[userPhoneFieldName] as String;

  CloudUser.fromDocSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : userId = snapshot.id,
        userName = snapshot.data()?[userNameFieldName] ?? '',
        email = snapshot.data()?[userEmailFieldName] as String? ?? '',
        phone = snapshot.data()?[userPhoneFieldName] as String? ?? '';
}