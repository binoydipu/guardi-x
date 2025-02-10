import 'package:flutter/material.dart';
import 'package:guardix/utilities/dialogs/generic_dialog.dart';

Future<bool> showSuccessDialog({
  required BuildContext context,
  required String text,
  String? title,
}) async {
  return showGenericDialog(
    context: context,
    title: title ?? 'Success',
    content: text,
    optionsBuilder: () => {
      'OK': true,
    },
  ).then(
    (value) => value ?? true,
  );
}
