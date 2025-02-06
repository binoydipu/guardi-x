import 'package:flutter/material.dart';
import 'package:guardix/utilities/dialogs/generic_dialog.dart';

Future<bool> showAddAdvocateDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Add Advocate',
    content: 'Are you sure want to add the advocate?',
    optionsBuilder: () => {
      'Cancel': false,
      'Yes': true,
    },
  ).then(
    (value) => value ?? false,
  );
}
