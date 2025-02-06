import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guardix/service/cloud/cloud_storage_constants.dart';
import 'package:flutter/foundation.dart';

@immutable
class CloudAdvocate {
  final String advocateName;
  final String advocateType;
  final String advocateEmail;
  final String advocatePhone;
  final String advocateAddress;

  const CloudAdvocate({
    required this.advocateName,
    required this.advocateType,
    required this.advocateEmail,
    required this.advocatePhone,
    required this.advocateAddress,
  });

  CloudAdvocate.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : advocateName = snapshot.data()[advocateNameFieldName] as String,
        advocateType = snapshot.data()[advocateTypeFieldName] as String,
        advocateEmail = snapshot.data()[advocateEmailFieldName] as String,
        advocatePhone = snapshot.data()[advocatePhoneFieldName] as String,
        advocateAddress = snapshot.data()[advocateAddressFieldName] as String;
}