import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guardix/service/cloud/cloud_storage_constants.dart';
import 'package:guardix/service/cloud/cloud_storage_exceptions.dart';

class FirebaseUserCloudStorage {
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
}
