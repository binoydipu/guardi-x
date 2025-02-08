import 'package:flutter/material.dart';
import 'package:guardix/constants/colors.dart';
import 'package:guardix/service/auth/auth_service.dart';
import 'package:guardix/service/cloud/cloud_storage_exceptions.dart';
import 'package:guardix/service/cloud/firebase_cloud_storage.dart';
import 'package:guardix/service/cloud/model/cloud_report_comment.dart';
import 'package:guardix/utilities/decorations/input_decoration_template.dart';
import 'package:guardix/utilities/dialogs/delete_dialog.dart';
import 'package:guardix/utilities/dialogs/error_dialog.dart';
import 'package:guardix/views/report/comments/comments_list_view.dart';

class CommentsView extends StatefulWidget {
  const CommentsView({super.key});

  @override
  State<CommentsView> createState() => _CommentsViewState();
}

class _CommentsViewState extends State<CommentsView> {
  late String reportId;
  late TextEditingController _commentField;
  late FirebaseCloudStorage _cloudStorage;

  String? get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _commentField = TextEditingController();
    _cloudStorage = FirebaseCloudStorage();
    super.initState();
  }

  @override
  void dispose() {
    _commentField.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    reportId = ModalRoute.of(context)?.settings.arguments as String;
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
        title: const Text(
          'Comments',
          style: TextStyle(color: whiteColor),
        ),
        centerTitle: true,
        backgroundColor: midnightBlueColor,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _commentField,
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 5,
                  decoration: buildInputDecoration(label: 'Write Comment'),
                ),
                const SizedBox(height: 5),
                ElevatedButton(
                  onPressed: () async {
                    if (_commentField.text.isNotEmpty) {
                      try {
                        _cloudStorage.addNewComment(
                          reportId: reportId,
                          userId: userId!,
                          comment: _commentField.text,
                        );
                        _commentField.clear();
                      } on CouldNotAddCommentException catch (_) {
                        if (context.mounted) {
                          await showErrorDialog(
                            context,
                            'Could not add Comment',
                          );
                        }
                      } on Exception catch (_) {}
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Comment Field is Empty'),
                          action: SnackBarAction(
                            label: 'Ok',
                            onPressed: () {},
                          ),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: midnightBlueColor,
                  ),
                  child: const Text(
                    'Comment',
                    style: TextStyle(
                      color: whiteColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: StreamBuilder(
              stream: _cloudStorage.getAllComments(
                reportId: reportId,
              ),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                    if (snapshot.hasData) {
                      final allReportComments =
                          snapshot.data as Iterable<CloudReportComment>;

                      return CommentsListView(
                        reportComments: allReportComments,
                        onLongPress: (reportComment) async {
                          bool isDeleted = await showDeleteDialog(
                            context: context,
                            title: 'Delete Comment',
                            description: 'Do you want to delete this comment?',
                          );
                          if (isDeleted) {
                            try {
                              _cloudStorage.deleteComment(
                                reportId: reportId,
                                commentId: reportComment.commentId,
                              );
                            } on CouldNotDeleteCommentException catch (_) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        const Text('Unable to delete comment'),
                                    action: SnackBarAction(
                                      label: 'Ok',
                                      onPressed: () {},
                                    ),
                                  ),
                                );
                              }
                            } catch (_) {}
                          }
                        },
                      );
                    } else {
                      return const Center(child: Text('No comments found.'));
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
