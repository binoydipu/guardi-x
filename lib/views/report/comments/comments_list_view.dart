import 'package:flutter/material.dart';
import 'package:guardix/constants/colors.dart';
import 'package:guardix/service/auth/auth_service.dart';
import 'package:guardix/service/cloud/model/cloud_report_comment.dart';
import 'package:guardix/utilities/helpers/find_time_ago.dart';

typedef CommentCallback = void Function(CloudReportComment advocate);

class CommentsListView extends StatelessWidget {
  final CommentCallback onLongPress;
  final Iterable<CloudReportComment> reportComments;
  String? get userId => AuthService.firebase().currentUser!.id;

  const CommentsListView({
    super.key,
    required this.reportComments,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: reportComments.length,
      itemBuilder: (context, index) {
        final reportComment = reportComments.elementAt(index);

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
          child: Card(
            color: whiteColor,
            elevation: 2.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: InkWell(
              onLongPress: () {
                onLongPress(reportComment);
              },
              borderRadius: BorderRadius.circular(8.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          backgroundColor: softBlueColor,
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              reportComment.userName,
                              style: const TextStyle(
                                color: midnightBlueColor,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              timeAgo(reportComment.createdAt),
                              style: const TextStyle(
                                color: Color.fromARGB(255, 133, 133, 133),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      reportComment.comment,
                      textAlign: TextAlign.justify,
                      style: const TextStyle(
                        color: blackColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}