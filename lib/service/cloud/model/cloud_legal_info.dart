import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guardix/service/cloud/cloud_storage_constants.dart';
import 'package:flutter/foundation.dart';

@immutable
class CloudLegalInfo {
  final String documentId;
  final String lawTitle;
  final String lawDescription;

  const CloudLegalInfo({
    required this.documentId,
    required this.lawTitle,
    required this.lawDescription,
  });

  CloudLegalInfo.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        lawTitle = snapshot.data()[lawTitleFieldName] as String,
        lawDescription = snapshot.data()[lawDescriptionFieldName] as String;
}
