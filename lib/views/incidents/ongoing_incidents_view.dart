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
  bool _onlyFlagged = false;
  bool _sortByUpvote = false;
  bool _sortByLatest = true;
  bool _filtersHidden = true;

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
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _filtersHidden
                  ? const SizedBox(width: 10) 
                  : const Text(
                    'Filter by Category',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _filtersHidden = !_filtersHidden;
                    });
                  },
                  child: Text(
                    '${_filtersHidden ? 'Show' : 'Hide'} Filters',
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (!_filtersHidden) 
            Column(
              children: [
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
                if (userEmail == adminEmail)
                  Row(
                    children: [
                      Checkbox(
                        value: _onlyFlagged,
                        onChanged: (value) {
                          setState(() {
                            _onlyFlagged = value!;
                          });
                        },
                      ),
                      const Text(
                        'Select Flagged Reports',
                          style: TextStyle(
                          color: blackColor,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                Row(
                  children: [
                    const SizedBox(width: 16),
                    const Text(
                      'Sort: ',
                      style: TextStyle(
                        color: blackColor,
                        fontSize: 14,
                      ),
                    ),
                    Checkbox(
                      value: _sortByUpvote,
                      onChanged: (value) {
                        setState(() {
                          _sortByUpvote = value!;
                        });
                      },
                    ),
                    const Text(
                      'Upvote',
                      style: TextStyle(
                        color: blackColor,
                        fontSize: 14,
                      ),
                    ),
                    Checkbox(
                      value: _sortByLatest,
                      onChanged: (value) {
                        setState(() {
                          _sortByLatest = value!;
                        });
                      },
                    ),
                    const Text(
                      'Latest',
                      style: TextStyle(
                        color: blackColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          const SizedBox(height: 10),
          Expanded(
            child: StreamBuilder(
              stream: _cloudStorage.allCategoryReports(
                category: _selectedCategory,
                flag: _onlyFlagged,
                sortByUpvote: _sortByUpvote,
                sortByLatest: _sortByLatest,
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
