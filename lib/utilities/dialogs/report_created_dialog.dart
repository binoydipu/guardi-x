import 'package:flutter/material.dart';
import 'package:guardix/utilities/dialogs/generic_dialog.dart';

Future<bool> showReportCreatedDialog(
  BuildContext context,
  String text,
) async {
  return showGenericDialog(
    context: context,
    title: 'Success',
    content: text,
    optionsBuilder: () => {
      'OK': true,
    },
  ).then(
    (value) => value ?? true,
  );
}
