import 'package:flutter/material.dart';
import 'package:guardix/utilities/dialogs/generic_dialog.dart';

Future<bool> showConfirmationDialog({
  required BuildContext context,
  String? title,
  String? description,
}) {
  return showGenericDialog(
    context: context,
    title: title ?? 'Delete',
    content: description ?? 'Are you sure want to delete this item?',
    optionsBuilder: () => {
      'Cancel': false,
      'Yes': true,
    },
  ).then(
    (value) => value ?? false,
  );
}
