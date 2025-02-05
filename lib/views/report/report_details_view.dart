import 'package:flutter/material.dart';
import 'package:guardix/constants/colors.dart';
import 'package:guardix/constants/routes.dart';
import 'package:guardix/service/auth/auth_constants.dart';
import 'package:guardix/service/auth/auth_service.dart';
import 'package:guardix/service/cloud/model/cloud_report.dart';
import 'package:guardix/service/cloud/cloud_storage_exceptions.dart';
import 'package:guardix/service/cloud/firebase_cloud_storage.dart';
import 'package:guardix/utilities/dialogs/delete_dialog.dart';
import 'package:guardix/utilities/dialogs/error_dialog.dart';
import 'package:guardix/utilities/dialogs/report_created_dialog.dart';
import 'package:share_plus/share_plus.dart';

class ReportDetailsView extends StatefulWidget {
  const ReportDetailsView({super.key});

  @override
  State<ReportDetailsView> createState() => _ReportDetailsViewState();
}

class _ReportDetailsViewState extends State<ReportDetailsView> {
  String? get userEmail => AuthService.firebase().currentUser!.email;

  late final FirebaseCloudStorage _cloudStorage;
  late final CloudReport report;
  bool _isInitialized = false;
  bool _isNonCrimeReport = false;

  @override
  void initState() {
    _cloudStorage = FirebaseCloudStorage();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (!_isInitialized) {
      report = ModalRoute.of(context)?.settings.arguments as CloudReport;
      
      _isNonCrimeReport = report.category == 'Lost Items' ||
          report.category == 'Missing Human' ||
          report.category == 'Missing Pet';
      _isInitialized = true;
    }
    super.didChangeDependencies();
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
                      Navigator.of(context).pushNamed(
                        editReportRoute,
                        arguments: report,
                      );
                    } else if (value == 'Share') {
                      Share.share(report.toString());
                    } else if (value == 'Delete') {
                      bool isDeleted = await showDeleteDialog(
                        context: context,
                        title: 'Delete Report',
                        description: 'Are you sure want to delete this report?',
                      );
                      if (context.mounted) {
                        if (isDeleted) {
                          try {
                            _cloudStorage.deleteReport(
                                documentId: report.documentId);
                            bool reportDeleted = await showReportCreatedDialog(
                              context,
                              'Report updated successfully.',
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
      body: SingleChildScrollView(
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
              Text(
                'Posted By: ${report.ownerEmail}',
                style: const TextStyle(
                  fontSize: 15,
                  color: blackColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
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
              const SizedBox(height: 20),
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
              const SizedBox(height: 20),
              Text(
                'Date of ${_isNonCrimeReport ? 'Incident' : 'Crime'}: ${report.dateOfCrime}',
                style: const TextStyle(
                  fontSize: 15,
                  color: blackColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'TIme of ${_isNonCrimeReport ? 'Incident' : 'Crime'}: ${report.timeOfCrime}',
                style: const TextStyle(
                  fontSize: 15,
                  color: blackColor,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Location of ${_isNonCrimeReport ? 'Incident' : 'Crime'}: ${report.locationOfCrime}',
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
              const SizedBox(height: 20),
              Text(
                'Reported Police Station: ${report.policeStation}',
                style: const TextStyle(
                  fontSize: 15,
                  color: blackColor,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Report Status: ${report.reportStatus}',
                style: const TextStyle(
                  fontSize: 15,
                  color: crimsonRedColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                '${_isNonCrimeReport ? 'Incident' : 'Crime'} Description:',
                style: const TextStyle(
                  fontSize: 15,
                  color: blackColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                report.descriptionOfCrime,
                style: const TextStyle(
                  fontSize: 15,
                  color: blackColor,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.arrow_upward,
                          color: midnightBlueColor,
                        ),
                      ),
                      const Text('Upvote'),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.arrow_downward,
                          color: midnightBlueColor,
                        ),
                      ),
                      const Text('Downvote'),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.comment,
                          color: midnightBlueColor,
                        ),
                      ),
                      const Text('Comment'),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          Share.share(report.toString());
                        },
                        icon: const Icon(
                          Icons.share,
                          color: midnightBlueColor,
                        ),
                      ),
                      const Text('Share'),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.flag,
                          color: midnightBlueColor,
                        ),
                      ),
                      const Text('Flag'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
