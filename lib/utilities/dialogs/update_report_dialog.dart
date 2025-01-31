import 'package:flutter/material.dart';
import 'package:guardix/utilities/dialogs/generic_dialog.dart';

Future<bool> showUpdateReportDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Update Report',
    content: 'Are you sure want to update the report?',
    optionsBuilder: () => {
      'Cancel': false,
      'Yes': true,
    },
  ).then(
    (value) => value ?? false,
  );
}
