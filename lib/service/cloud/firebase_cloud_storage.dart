import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guardix/service/cloud/model/cloud_report.dart';
import 'package:guardix/service/cloud/cloud_storage_constants.dart';
import 'package:guardix/service/cloud/cloud_storage_exceptions.dart';

class FirebaseCloudStorage {
  final reports = FirebaseFirestore.instance.collection(reportCollectionName);

  final users = FirebaseFirestore.instance.collection(userCollectionName);

  void createNewUser({
    required String userId,
    required String userName,
    required String email,
    required String phone,
  }) async {
    try {
      await users.doc(userId).set({
        userIdFieldName: userId,
        userNameFiellName: userName,
        userEmailFieldName: email,
        userPhoneFieldName: phone,
      });
    } catch (e) {
      throw CouldNotAddUserException();
    }
  }

  Future<void> deleteReport({
    required String documentId,
  }) async {
    try {
      await reports.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteReportException();
    }
  }

  /// update a report status
  Future<void> updateReport({
    required String documentId,
    required String victimName,
    required String victimAddress,
    required String victimContact,
    required String witnessName,
    required String witnessContact,
    required String dateOfCrime,
    required String timeOfCrime,
    required String locationOfCrime,
    required String descriptionOfCrime,
    required String injuryType,
    required String policeStation,
    required String reportStatus,
  }) async {
    try {
      await reports.doc(documentId).update({
        victimNameFieldName: victimName,
        victimAddressFieldName: victimAddress,
        victimContactFieldName: victimContact,
        witnessNameFieldName: witnessName,
        witnessContactFieldName: witnessContact,
        dateOfCrimeFieldName: dateOfCrime,
        timeOfCrimeFieldName: timeOfCrime,
        locationOfCrimeFieldName: locationOfCrime,
        descriptionOfCrimeFieldName: descriptionOfCrime,
        injuryTypeFieldName: injuryType,
        policeStationFieldName: policeStation,
        reportStatusFieldName: reportStatus,
      });
    } catch (e) {
      throw CouldNotUpdateReportException();
    }
  }

  /// Get all the reports of that category live as they are occuring in reports collection
  Stream<Iterable<CloudReport>> allCategoryReports({
    String? category,
  }) {
    return reports.snapshots().map((event) => event.docs
        .map((doc) => CloudReport.fromSnapshot(doc))
        .where((report) =>
            category == null || category == '' || report.category == category));
  }

  /// Get all the reports of current user
  Stream<Iterable<CloudReport>> getMyReports({
    required String userEmail,
    String? reportStatus,
  }) {
    return reports.snapshots().map((event) => event.docs
        .map((doc) => CloudReport.fromSnapshot(doc))
        .where((report) =>
            (reportStatus == null ||
                reportStatus == '' ||
                report.reportStatus == reportStatus) &&
            report.ownerEmail == userEmail));
  }

  /// Takes a snapshot at a point of time, and returns
  Future<Iterable<CloudReport>> getCategoryReports({
    required String category,
  }) async {
    try {
      return await reports
          .where(
            categoryFieldName,
            isEqualTo: category,
          )
          .get()
          .then(
            (value) => value.docs.map((doc) => CloudReport.fromSnapshot(doc)),
          );
    } catch (e) {
      throw CouldNotGetAllReportsException();
    }
  }

  void createNewReport({
    required String ownerEmail,
    required String category,
    required String victimName,
    required String victimAddress,
    required String victimContact,
    required String witnessName,
    required String witnessContact,
    required String dateOfCrime,
    required String timeOfCrime,
    required String locationOfCrime,
    required String descriptionOfCrime,
    required String injuryType,
    required String policeStation,
    required String reportStatus,
  }) async {
    try {
      await reports.add({
        ownerEmailFieldName: ownerEmail,
        categoryFieldName: category,
        victimNameFieldName: victimName,
        victimAddressFieldName: victimAddress,
        victimContactFieldName: victimContact,
        witnessNameFieldName: witnessName,
        witnessContactFieldName: witnessContact,
        dateOfCrimeFieldName: dateOfCrime,
        timeOfCrimeFieldName: timeOfCrime,
        locationOfCrimeFieldName: locationOfCrime,
        descriptionOfCrimeFieldName: descriptionOfCrime,
        injuryTypeFieldName: injuryType,
        policeStationFieldName: policeStation,
        reportStatusFieldName: reportStatus,
      });
    } catch (e) {
      throw CouldNotCreateReportException();
    }
  }

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();

  // private constructor
  FirebaseCloudStorage._sharedInstance();
  // factory constructor
  factory FirebaseCloudStorage() => _shared;
}
