import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guardix/service/cloud/cloud_storage_constants.dart';
import 'package:flutter/foundation.dart';

@immutable
class CloudReport {
  final String documentId;
  final String category;

  final String ownerEmail;

  final String victimName;
  final String victimAddress;
  final String victimContact;
  final String witnessName;
  final String witnessContact;

  final String dateOfCrime;
  final String timeOfCrime;
  final String locationOfCrime;
  final String descriptionOfCrime;
  final String injuryType;
  final String policeStation;

  final String reportStatus;

  const CloudReport({
    required this.documentId,
    required this.category,
    required this.ownerEmail,
    required this.victimName,
    required this.victimAddress,
    required this.victimContact,
    required this.witnessName,
    required this.witnessContact,
    required this.dateOfCrime,
    required this.timeOfCrime,
    required this.locationOfCrime,
    required this.descriptionOfCrime,
    required this.injuryType,
    required this.policeStation,
    required this.reportStatus,
  });

  CloudReport.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        category = snapshot.data()[categoryFieldName],
        ownerEmail = snapshot.data()[ownerEmailFieldName] as String,
        victimName = snapshot.data()[victimNameFieldName] as String,
        victimAddress = snapshot.data()[victimAddressFieldName] as String,
        victimContact = snapshot.data()[victimContactFieldName] as String,
        witnessName = snapshot.data()[witnessNameFieldName] as String,
        witnessContact = snapshot.data()[witnessContactFieldName] as String,
        dateOfCrime = snapshot.data()[dateOfCrimeFieldName] as String,
        timeOfCrime = snapshot.data()[timeOfCrimeFieldName] as String,
        locationOfCrime = snapshot.data()[locationOfCrimeFieldName] as String,
        descriptionOfCrime =
            snapshot.data()[descriptionOfCrimeFieldName] as String,
        injuryType = snapshot.data()[injuryTypeFieldName] as String,
        policeStation = snapshot.data()[policeStationFieldName] as String,
        reportStatus = snapshot.data()[reportStatusFieldName] as String;
}
