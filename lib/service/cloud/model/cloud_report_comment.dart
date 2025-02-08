import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guardix/service/cloud/cloud_storage_constants.dart';
import 'package:flutter/foundation.dart';

@immutable
class CloudReportComment {
  final String commentId;
  final String userId;
  final String comment;
  final DateTime createdAt;

  const CloudReportComment({
    required this.commentId,
    required this.userId,
    required this.comment,
    required this.createdAt,
  });

  CloudReportComment.fromSnapshot(
    QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
    : commentId = snapshot.id,
      userId = snapshot.data()[userIdFieldName] as String? ?? '',
      createdAt = (snapshot.data()[createdAtFieldName] as Timestamp?)?.toDate() ?? DateTime.now(),
      comment = snapshot.data()[commentsFieldName] as String? ?? '';
}
