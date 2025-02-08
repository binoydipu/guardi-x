import 'package:flutter/material.dart';
import 'package:guardix/constants/colors.dart';
import 'package:guardix/constants/routes.dart';
import 'package:guardix/service/auth/auth_service.dart';
import 'package:guardix/service/cloud/cloud_storage_constants.dart';
import 'package:guardix/service/cloud/firebase_cloud_storage.dart';
import 'package:guardix/service/cloud/model/cloud_report.dart';
import 'package:guardix/utilities/decorations/report_status_decoration.dart';
import 'package:guardix/utilities/helpers/find_time_ago.dart';
import 'package:guardix/utilities/helpers/format_number.dart';
import 'package:share_plus/share_plus.dart';

typedef ReportCallback = void Function(CloudReport report);

class ReportListView extends StatelessWidget {
  final Iterable<CloudReport> reports;
  final ReportCallback onTap;
  final FirebaseCloudStorage _cloudStorage = FirebaseCloudStorage();
  String? get userId => AuthService.firebase().currentUser!.id;

  ReportListView({
    super.key,
    required this.reports,
    required this.onTap,
  });

  void _updateReportUserAction({
    required CloudReport report,
    required String fieldName,
    required String userId,
  }) {
    final userActions = report.userActions;
    int flags = report.flags;
    int upvotes = report.upvotes;
    int downvotes = report.downvotes;
    if (userActions.containsKey(userId)) {
      if (fieldName == flagsFieldName) {
        if (!userActions[userId]!.contains(flagsFieldName)) {
          report.userActions[userId]!.add(flagsFieldName);
          flags++;
        } else {
          report.userActions[userId]!.remove(flagsFieldName);
          flags--;
        }
      } else if (fieldName == upvotesFieldName) {
        if (!userActions[userId]!.contains(upvotesFieldName)) {
          report.userActions[userId]!.add(upvotesFieldName);
          upvotes++;
          if (userActions[userId]!.contains(downvotesFieldName)) {
            report.userActions[userId]!.remove(downvotesFieldName);
            downvotes--;
          }
        } else {
          report.userActions[userId]!.remove(upvotesFieldName);
          upvotes--;
        }
      } else if (fieldName == downvotesFieldName) {
        if (!userActions[userId]!.contains(downvotesFieldName)) {
          report.userActions[userId]!.add(downvotesFieldName);
          downvotes++;
          if (userActions[userId]!.contains(upvotesFieldName)) {
            report.userActions[userId]!.remove(upvotesFieldName);
            upvotes--;
          }
        } else {
          report.userActions[userId]!.remove(downvotesFieldName);
          downvotes--;
        }
      }
    } else {
      report.userActions[userId] = [fieldName];
      if (fieldName == flagsFieldName) {
        flags++;
      } else if (fieldName == upvotesFieldName) {
        upvotes++;
      } else if (fieldName == downvotesFieldName) {
        downvotes++;
      }
    }
    _cloudStorage.updateReportUserAction(
      documentId: report.documentId,
      userActions: userActions,
      flags: flags,
      upvotes: upvotes,
      downvotes: downvotes,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: reports.length,
      itemBuilder: (context, index) {
        final report = reports.elementAt(index);

        return Card(
          color: whiteColor,
          elevation: 2.0,
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: InkWell(
            onTap: () {
              onTap(report);
            },
            borderRadius: BorderRadius.circular(8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        report.category,
                        style: const TextStyle(
                          color: midnightBlueColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      buildStatus(reportStatus: report.reportStatus),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    timeAgo(report.createdAt),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Date of ${report.isNonCrimeReport ? 'incident' : 'crime'}: ${report.dateOfCrime} at ${report.timeOfCrime}',
                    style: const TextStyle(
                      color: blackColor,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Posted By: ${report.ownerEmail}',
                    style: const TextStyle(
                      color: blackColor,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Location: ${report.locationOfCrime}',
                    style: const TextStyle(
                      color: blackColor,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    report.descriptionOfCrime,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: blackColor,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => _updateReportUserAction(
                              fieldName: upvotesFieldName,
                              report: report,
                              userId: userId!,
                            ),
                            icon: Icon(
                              Icons.arrow_upward,
                              color: report.userActions[userId]
                                          ?.contains(upvotesFieldName) ??
                                      false
                                  ? brightGreenColor
                                  : midnightBlueColor,
                            ),
                          ),
                          Text(
                            formatNumber(report.upvotes),
                            style: const TextStyle(
                              color: blackColor,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => _updateReportUserAction(
                              fieldName: downvotesFieldName,
                              report: report,
                              userId: userId!,
                            ),
                            icon: Icon(
                              Icons.arrow_downward,
                              color: report.userActions[userId]
                                          ?.contains(downvotesFieldName) ??
                                      false
                                  ? crimsonRedColor
                                  : midnightBlueColor,
                            ),
                          ),
                          Text(
                            formatNumber(report.downvotes),
                            style: const TextStyle(
                              color: blackColor,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                            reportCommentsRoute,
                            arguments: report.documentId,
                          );
                        },
                        icon: const Icon(
                          Icons.comment,
                          color: midnightBlueColor,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Share.share(report.toString());
                        },
                        icon: const Icon(
                          Icons.share,
                          color: midnightBlueColor,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => _updateReportUserAction(
                              fieldName: flagsFieldName,
                              report: report,
                              userId: userId!,
                            ),
                            icon: Icon(
                              Icons.flag,
                              color: report.userActions[userId]
                                          ?.contains(flagsFieldName) ??
                                      false
                                  ? crimsonRedColor
                                  : midnightBlueColor,
                            ),
                          ),
                          Text(
                            formatNumber(report.flags),
                            style: TextStyle(
                              color: report.flags > 0
                                  ? crimsonRedColor
                                  : blackColor,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}