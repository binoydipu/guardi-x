import 'package:flutter/material.dart';
import 'package:guardix/constants/colors.dart';
import 'package:guardix/service/cloud/cloud_report.dart';

typedef ReportCallback = void Function(CloudReport report);

class ReportListView extends StatelessWidget {
  final Iterable<CloudReport> reports;
  final ReportCallback onTap;

  const ReportListView({
    super.key,
    required this.reports,
    required this.onTap,
  });

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
                    'Date of crime: ${report.dateOfCrime} at ${report.timeOfCrime}',
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
                      IconButton(
                        onPressed: () {
                          
                        },
                        icon: const Icon(
                          Icons.arrow_upward, 
                          color: midnightBlueColor,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          
                        },
                        icon: const Icon(
                          Icons.arrow_downward, 
                          color: midnightBlueColor,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          
                        },
                        icon: const Icon(
                          Icons.comment, 
                          color: midnightBlueColor,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          
                        },
                        icon: const Icon(
                          Icons.share, 
                          color: midnightBlueColor,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          
                        },
                        icon: const Icon(
                          Icons.report_gmailerrorred, 
                          color: midnightBlueColor,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );

        // return ListTile(
        //   onTap: () {
        //     onTap(report);
        //   },
        //   title: Text(
        //     report.category,
        //     maxLines: 1,
        //     softWrap: true,
        //     style: const TextStyle(
        //       color: blackColor,
        //       fontWeight: FontWeight.bold,
        //     ),
        //     overflow: TextOverflow.ellipsis,
        //   ),
        //   subtitle: Text(
        //     report.descriptionOfCrime,
        //     maxLines: 2,
        //     softWrap: true,
        //     overflow: TextOverflow.ellipsis,
        //   ),
        // );
      },
    );
  }
}
