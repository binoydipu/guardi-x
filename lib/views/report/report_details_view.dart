import 'package:flutter/material.dart';
import 'package:guardix/constants/colors.dart';
import 'package:guardix/constants/routes.dart';
import 'package:guardix/service/auth/auth_constants.dart';
import 'package:guardix/service/auth/auth_service.dart';
import 'package:guardix/service/cloud/cloud_storage_constants.dart';
import 'package:guardix/service/cloud/model/cloud_report.dart';
import 'package:guardix/service/cloud/cloud_storage_exceptions.dart';
import 'package:guardix/service/cloud/firebase_cloud_storage.dart';
import 'package:guardix/utilities/decorations/report_status_decoration.dart';
import 'package:guardix/utilities/dialogs/confirmation_dialog.dart';
import 'package:guardix/utilities/dialogs/error_dialog.dart';
import 'package:guardix/utilities/dialogs/loading_dialog.dart';
import 'package:guardix/utilities/dialogs/success_dialog.dart';
import 'package:guardix/utilities/helpers/format_date_time.dart';
import 'package:guardix/utilities/helpers/format_number.dart';
import 'package:share_plus/share_plus.dart';

class ReportDetailsView extends StatefulWidget {
  const ReportDetailsView({super.key});

  @override
  State<ReportDetailsView> createState() => _ReportDetailsViewState();
}

class _ReportDetailsViewState extends State<ReportDetailsView> {
  String? get userEmail => AuthService.firebase().currentUser!.email;
  String? get userId => AuthService.firebase().currentUser!.id;

  late final FirebaseCloudStorage _cloudStorage;
  late CloudReport report;
  late String reportId;

  bool _isFirstTime = true;

  void _updateReportUserAction({
    required CloudReport report,
    required String fieldName,
    required String userId,
  }) async {
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
    final loadingDialog = showLoadingDialog(
      context: context,
      text: 'Updating Info...',
    );
    await _cloudStorage.updateReportUserAction(
      documentId: report.documentId,
      userActions: userActions,
      flags: flags,
      upvotes: upvotes,
      downvotes: downvotes,
    );
    loadingDialog();
  }

  @override
  void initState() {
    _cloudStorage = FirebaseCloudStorage();
    _isFirstTime = true;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isFirstTime) {
      report = ModalRoute.of(context)?.settings.arguments as CloudReport;
      reportId = report.documentId;
    }
    super.didChangeDependencies();
  }

  Stream<CloudReport> _fetchReportStream() {
    return _cloudStorage.getReportStream(documentId: reportId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: whiteColor,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            : null,
        actions: userEmail == adminEmail || userEmail == report.ownerEmail
            ? [
                PopupMenuButton(
                  icon: const Icon(
                    Icons.more_vert,
                    color: whiteColor,
                  ),
                  onSelected: (String value) async {
                    if (value == 'Edit') {
                      _isFirstTime = false;
                      Navigator.of(context).pushNamed(
                        editReportRoute,
                        arguments: report,
                      );
                    } else if (value == 'Share') {
                      Share.share(report.toString());
                    } else if (value == 'Delete') {
                      bool isDeleted = await showConfirmationDialog(
                        context: context,
                        title: 'Delete Report',
                        description: 'Are you sure want to delete this report?',
                      );
                      if (context.mounted) {
                        if (isDeleted) {
                          try {
                            _cloudStorage.deleteReport(
                                documentId: report.documentId);
                            bool reportDeleted = await showSuccessDialog(
                              context: context,
                              text: 'Report updated successfully.',
                            );
                            if (reportDeleted) {
                              if (context.mounted) {
                                Navigator.of(context).pop();
                              }
                            }
                          } on CouldNotDeleteReportException catch (_) {
                            if (context.mounted) {
                              await showErrorDialog(
                                context,
                                'Could not delete report',
                              );
                            }
                          } on Exception catch (_) {}
                        }
                      }
                    }
                  },
                  itemBuilder: (context) {
                    return [
                      const PopupMenuItem<String>(
                        value: 'Edit',
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Edit',
                            style: TextStyle(
                              color: blackColor,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                      const PopupMenuItem<String>(
                        value: 'Share',
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Share',
                            style: TextStyle(
                              color: blackColor,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                      const PopupMenuItem<String>(
                        value: 'Delete',
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Delete',
                            style: TextStyle(
                              color: blackColor,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ];
                  },
                ),
              ]
            : null,
        title: const Text(
          'Report Details',
          style: TextStyle(color: whiteColor),
        ),
        centerTitle: true,
        backgroundColor: midnightBlueColor,
      ),
      body: StreamBuilder<CloudReport>(
        stream: _fetchReportStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final report = snapshot.data;

          if (report == null) {
            return const Center(child: Text('Report not found.'));
          }

          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Category: ${report.category}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: blackColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 15,
                        color: blackColor,
                      ),
                      children: [
                        const TextSpan(
                          text: 'Posted By: ',
                        ),
                        TextSpan(
                          text: report.ownerName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 15,
                        color: blackColor,
                      ),
                      children: [
                        const TextSpan(
                          text: 'Email: ',
                        ),
                        TextSpan(
                          text: report.ownerEmail,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Posted on: ${formatDateTime(report.createdAt)}',
                    style: const TextStyle(
                      fontSize: 15,
                      color: blackColor,
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Center(
                    child: Text(
                      'Personal Information',
                      style: TextStyle(
                        fontSize: 16,
                        color: blackColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 17),
                  Text(
                    'Victim Name: ${report.victimName}',
                    style: const TextStyle(
                      fontSize: 15,
                      color: blackColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Victim Address: ${report.victimAddress}',
                    style: const TextStyle(
                      fontSize: 15,
                      color: blackColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Victim Contact: ${report.victimContact}',
                    style: const TextStyle(
                      fontSize: 15,
                      color: blackColor,
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Center(
                    child: Text(
                      'Witness Information',
                      style: TextStyle(
                        fontSize: 16,
                        color: blackColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 17),
                  Text(
                    'Witness Name: ${report.witnessName}',
                    style: const TextStyle(
                      fontSize: 15,
                      color: blackColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Witness Contact: ${report.witnessContact}',
                    style: const TextStyle(
                      fontSize: 15,
                      color: blackColor,
                    ),
                  ),
                  const SizedBox(height: 25),
                  Center(
                    child: Text(
                      report.isNonCrimeReport
                          ? 'Incident Information'
                          : 'Crime Information',
                      style: const TextStyle(
                        fontSize: 16,
                        color: blackColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 17),
                  Text(
                    'Date of ${report.isNonCrimeReport ? 'Incident' : 'Crime'}: ${report.dateOfCrime}',
                    style: const TextStyle(
                      fontSize: 15,
                      color: blackColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'TIme of ${report.isNonCrimeReport ? 'Incident' : 'Crime'}: ${report.timeOfCrime}',
                    style: const TextStyle(
                      fontSize: 15,
                      color: blackColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Location of ${report.isNonCrimeReport ? 'Incident' : 'Crime'}: ${report.locationOfCrime}',
                    style: const TextStyle(
                      fontSize: 15,
                      color: blackColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Injury Type: ${report.injuryType}',
                    style: const TextStyle(
                      fontSize: 15,
                      color: blackColor,
                    ),
                  ),
                  const SizedBox(height: 25),
                  Text(
                    'Reported Police Station: ${report.policeStation}',
                    style: const TextStyle(
                      fontSize: 15,
                      color: blackColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text(
                        'Status: ',
                        style: TextStyle(
                          fontSize: 14,
                          color: blackColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      buildStatus(reportStatus: report.reportStatus),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Center(
                    child: Text(
                      '${report.isNonCrimeReport ? 'Incident' : 'Crime'} Description:',
                      style: const TextStyle(
                        fontSize: 15,
                        color: blackColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    report.descriptionOfCrime,
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      fontSize: 15,
                      color: blackColor,
                    ),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildButtonCard(
                        report: report,
                        context: context,
                        icon: Icons.arrow_upward,
                        text: 'Upvote',
                        onTap: () => _updateReportUserAction(
                          fieldName: upvotesFieldName,
                          report: report,
                          userId: userId!,
                        ),
                        value: report.upvotes,
                      ),
                      const SizedBox(width: 10),
                      buildButtonCard(
                        report: report,
                        context: context,
                        icon: Icons.arrow_downward,
                        text: 'Downvote',
                        onTap: () => _updateReportUserAction(
                          fieldName: downvotesFieldName,
                          report: report,
                          userId: userId!,
                        ),
                        value: report.downvotes,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildButtonCard(
                        report: report,
                        context: context,
                        icon: Icons.comment,
                        text: 'Comment',
                        onTap: () {
                          Navigator.of(context).pushNamed(reportCommentsRoute,
                              arguments: report.documentId);
                        },
                      ),
                      const SizedBox(width: 10),
                      buildButtonCard(
                        report: report,
                        context: context,
                        icon: Icons.flag,
                        text: 'Flag',
                        onTap: () => _updateReportUserAction(
                          fieldName: flagsFieldName,
                          report: report,
                          userId: userId!,
                        ),
                        value: report.flags,
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget buildButtonCard({
  required BuildContext context,
  required IconData icon,
  required String text,
  required CloudReport report,
  int? value,
  required VoidCallback onTap,
}) {
  Color? iconColor = midnightBlueColor;
  Color? valueColor = blackColor;
  String? userId = AuthService.firebase().currentUser!.id;
  if (text == 'Upvote') {
    iconColor = report.userActions[userId]?.contains(upvotesFieldName) ?? false
        ? brightGreenColor
        : midnightBlueColor;
  } else if (text == 'Downvote') {
    iconColor =
        report.userActions[userId]?.contains(downvotesFieldName) ?? false
            ? crimsonRedColor
            : midnightBlueColor;
  } else if (text == 'Flag') {
    iconColor = report.userActions[userId]?.contains(flagsFieldName) ?? false
        ? crimsonRedColor
        : midnightBlueColor;
    valueColor = report.flags > 0 ? crimsonRedColor : blackColor;
  }

  return Container(
    constraints: const BoxConstraints(
      minWidth: 140,
    ),
    decoration: BoxDecoration(
      border: Border.all(
        color: softBlueColor,
        width: 1.0,
      ),
      borderRadius: BorderRadius.circular(16.0),
    ),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              icon,
              color: iconColor,
            ),
            const SizedBox(width: 5),
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: blackColor,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 5),
            if (value != null)
              Text(
                formatNumber(value),
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: valueColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    ),
  );
}
