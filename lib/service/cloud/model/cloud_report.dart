import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guardix/service/cloud/cloud_storage_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:guardix/utilities/helpers/format_date_time.dart';

@immutable
class CloudReport {
  final String documentId;
  final String category;

  final String ownerEmail;
  final String ownerName;

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
  final int flags;
  final int upvotes;
  final int downvotes;
  final Map<String, List<String>> userActions; // Map of userId to their actions

  final DateTime createdAt;

  CloudReport({
    required this.documentId,
    required this.category,
    required this.ownerEmail,
    required this.ownerName,
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
    required this.flags,
    required this.upvotes,
    required this.downvotes,
    required this.createdAt,
  }) : userActions = {};

  CloudReport.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        category = snapshot.data()[categoryFieldName],
        ownerEmail = snapshot.data()[ownerEmailFieldName] as String,
        ownerName = snapshot.data()[ownerNameFieldName] as String? ?? 'Anonymous',
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
        reportStatus = snapshot.data()[reportStatusFieldName] as String,
        flags = snapshot.data()[flagsFieldName] as int,
        upvotes = snapshot.data()[upvotesFieldName] as int,
        downvotes = snapshot.data()[downvotesFieldName] as int,
        createdAt =
            (snapshot.data()[createdAtFieldName] as Timestamp?)?.toDate() ??
                DateTime.now(),
        userActions = _mapUserActions(snapshot.data()[userActionsFieldName]);

  CloudReport.fromDocSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        category = snapshot.data()?[categoryFieldName] ?? '',
        ownerEmail = snapshot.data()?[ownerEmailFieldName] as String? ?? '',
        ownerName = snapshot.data()?[ownerNameFieldName] as String? ?? 'Anonymous',
        victimName = snapshot.data()?[victimNameFieldName] as String? ?? '',
        victimAddress =
            snapshot.data()?[victimAddressFieldName] as String? ?? '',
        victimContact =
            snapshot.data()?[victimContactFieldName] as String? ?? '',
        witnessName = snapshot.data()?[witnessNameFieldName] as String? ?? '',
        witnessContact =
            snapshot.data()?[witnessContactFieldName] as String? ?? '',
        dateOfCrime = snapshot.data()?[dateOfCrimeFieldName] as String? ?? '',
        timeOfCrime = snapshot.data()?[timeOfCrimeFieldName] as String? ?? '',
        locationOfCrime =
            snapshot.data()?[locationOfCrimeFieldName] as String? ?? '',
        descriptionOfCrime =
            snapshot.data()?[descriptionOfCrimeFieldName] as String? ?? '',
        injuryType = snapshot.data()?[injuryTypeFieldName] as String? ?? '',
        policeStation =
            snapshot.data()?[policeStationFieldName] as String? ?? '',
        reportStatus = snapshot.data()?[reportStatusFieldName] as String? ?? '',
        flags = snapshot.data()?[flagsFieldName] as int? ?? 0,
        upvotes = snapshot.data()?[upvotesFieldName] as int? ?? 0,
        downvotes = snapshot.data()?[downvotesFieldName] as int? ?? 0,
        createdAt =
            (snapshot.data()?[createdAtFieldName] as Timestamp?)?.toDate() ??
                DateTime.now(),
        userActions = _mapUserActions(snapshot.data()?[userActionsFieldName]);

  @override
  String toString() {
    return '''
    📌 $category Report:
    ---------------------------
    🔹 Category: $category
    📧 Reported by: $ownerName
    🕒 Posted on: ${formatDateTime(createdAt)}

    👤 Victim Information:
    - Name: $victimName
    - Address: $victimAddress
    - Contact: $victimContact

    👀 Witness Information:
    - Name: $witnessName
    - Contact: $witnessContact

    📅 Date & Time of ${isNonCrimeReport ? 'Incident' : 'Crime'}:
    - Date: $dateOfCrime
    - Time: $timeOfCrime

    📍 Location: $locationOfCrime
    📝 Description: $descriptionOfCrime
    🤕 Injury Type: $injuryType
    🚔 Police Station: $policeStation

    📜 Report Status: $reportStatus

    👍 Upvotes: $upvotes
    👎 Downvotes: $downvotes
    ''';
  }

  bool get isNonCrimeReport =>
      category == 'Lost Items' ||
      category == 'Missing Human' ||
      category == 'Missing Pet';

  /// Convert Map<String, dynamic> to Map<String, List<String>>
  static Map<String, List<String>> _mapUserActions(dynamic userActionsData) {
    if (userActionsData == null) {
      return {};
    }

    final Map<String, List<String>> result = {};
    userActionsData.forEach((key, value) {
      if (value is List) {
        result[key] = List<String>.from(value);
      } else {
        result[key] = [];
      }
    });

    return result;
  }
}
