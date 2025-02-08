import 'package:flutter/material.dart';
import 'package:guardix/constants/colors.dart';
import 'package:guardix/service/auth/auth_service.dart';
import 'package:guardix/service/cloud/cloud_storage_constants.dart';
import 'package:guardix/service/cloud/firebase_cloud_storage.dart';
import 'package:guardix/service/cloud/model/cloud_report.dart';
import 'package:guardix/utilities/helpers/find_time_ago.dart';
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

        return InkWell(
          onTap: () {
            onTap(report);
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 10.0),
            child: Container(
              alignment: Alignment.topLeft,
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        report.category,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        style: const TextStyle(
                          color: blackColor,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        report.reportStatus,
                        style: const TextStyle(
                          color: blackColor,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    timeAgo(report.createdAt),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: const TextStyle(
                      color: blackColor,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    'Date of ${report.isNonCrimeReport ? 'incident' : 'crime'}: ${report.dateOfCrime} at ${report.timeOfCrime}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: const TextStyle(
                      color: blackColor,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    'Posted By: ${report.ownerEmail}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: const TextStyle(
                      color: blackColor,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    'Location: ${report.locationOfCrime}',
                    style: const TextStyle(
                      color: blackColor,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    report.descriptionOfCrime,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: const TextStyle(
                      color: blackColor,
                      fontSize: 13,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () => _updateReportUserAction(
                                fieldName: upvotesFieldName,
                                report: report,
                                userId: userId!,
                              ),
                              icon: const Icon(
                                Icons.arrow_upward,
                                color: midnightBlueColor,
                              ),
                            ),
                            Text(
                              '${report.upvotes}',
                              style: const TextStyle(
                                color: blackColor,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        child: Row(
                          children: [
                            IconButton(
                              onPressed:  () => _updateReportUserAction(
                                fieldName: downvotesFieldName,
                                report: report,
                                userId: userId!,
                              ),
                              icon: const Icon(
                                Icons.arrow_downward,
                                color: midnightBlueColor,
                              ),
                            ),
                            Text(
                              '${report.downvotes}',
                              style: const TextStyle(
                                color: blackColor,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
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
                      SizedBox(
                        child: Row(
                          children: [
                            IconButton(
                              onPressed:  () => _updateReportUserAction(
                                fieldName: flagsFieldName,
                                report: report,
                                userId: userId!,
                              ),
                              icon: const Icon(
                                Icons.flag,
                                color: midnightBlueColor,
                              ),
                            ),
                            Text(
                              '${report.flags}  ',
                              style: TextStyle(
                                color: report.flags == 0
                                    ? blackColor
                                    : crimsonRedColor,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
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
