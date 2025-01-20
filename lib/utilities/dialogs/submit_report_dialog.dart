import 'package:flutter/material.dart';
import 'package:guardix/utilities/dialogs/generic_dialog.dart';

Future<bool> showReportSubmissionDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Submit Report',
    content: 'Are you sure want to submit the report?',
    optionsBuilder: () => {
      'Cancel': false,
      'Yes': true,
    },
  ).then(
    (value) => value ?? false,
  );
}
