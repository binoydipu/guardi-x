import 'package:flutter/material.dart';
import 'package:guardix/constants/colors.dart';
import 'package:guardix/constants/routes.dart';
import 'package:guardix/service/auth/auth_constants.dart';
import 'package:guardix/service/auth/auth_service.dart';
import 'package:guardix/service/cloud/model/cloud_report.dart';
import 'package:guardix/service/cloud/firebase_cloud_storage.dart';
import 'package:guardix/utilities/decorations/input_decoration_template.dart';
import 'package:guardix/views/report/report_constants.dart';
import 'package:guardix/views/report/report_list_view.dart';

class OngoingIncidentsView extends StatefulWidget {
  const OngoingIncidentsView({super.key});

  @override
  State<OngoingIncidentsView> createState() => _OngoingIncidentsViewState();
}

class _OngoingIncidentsViewState extends State<OngoingIncidentsView> {
  late final FirebaseCloudStorage _cloudStorage;
  String get userEmail => AuthService.firebase().currentUser!.email;

  String? _selectedCategory;
  bool onlyFlagged = false;
  bool sortByUpvote = false;
  bool sortByLatest = false;

  @override
  void initState() {
    _cloudStorage = FirebaseCloudStorage();
    _selectedCategory = categoryList[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: whiteColor,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Ongoing Incidents',
          style: TextStyle(color: whiteColor),
        ),
        centerTitle: true,
        backgroundColor: midnightBlueColor,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(
                left: 16.0, right: 16.0, top: 10.0, bottom: 5.0),
            child: Text(
              'Filter by Category',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: DropdownButtonFormField(
              value: _selectedCategory,
              items: categoryList
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
              icon: const Icon(
                Icons.arrow_drop_down,
                color: midnightBlueColor,
              ),
              dropdownColor: Colors.blue[50],
              decoration: buildInputDecoration(label: 'Select Category'),
            ),
          ),
          if(userEmail == adminEmail)
            Row(
              children: [
                Checkbox(
                  value: onlyFlagged,
                  onChanged: (value) {
                    setState(() {
                      onlyFlagged = value!;
                    });
                  },
                ),
                const Text(
                  'Select Flagged Reports',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          Row(
            children: [
              const SizedBox(width: 16),
              const Text(
                'Sort: ',
                style: TextStyle(fontSize: 14),
              ),
              Checkbox(
                value: sortByUpvote,
                onChanged: (value) {
                  setState(() {
                    sortByUpvote = value!;
                  });
                },
              ),
              const Text(
                'Upvote',
                style: TextStyle(fontSize: 14),
              ),
              Checkbox(
                value: sortByLatest,
                onChanged: (value) {
                  setState(() {
                    sortByLatest = value!;
                  });
                },
              ),
              const Text(
                'Latest',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.only(left: 16.0, right: 16.0),
            child: Text(
              'Ongoing Incidents:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: StreamBuilder(
              stream: _cloudStorage.allCategoryReports(
                category: _selectedCategory,
                flag: onlyFlagged,
                sortByUpvote: sortByUpvote,
                sortByLatest: sortByLatest,
              ),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                    if (snapshot.hasData) {
                      final allReports = snapshot.data as Iterable<CloudReport>;
                      return ReportListView(
                        reports: allReports,
                        onTap: (report) {
                          Navigator.of(context).pushNamed(
                            reportDetailsRoute,
                            arguments: report,
                          );
                        },
                      );
                    } else {
                      return const Center(child: Text('No reports found.'));
                    }
                  default:
                    return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
