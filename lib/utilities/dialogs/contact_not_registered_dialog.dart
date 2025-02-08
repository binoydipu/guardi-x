import 'package:flutter/material.dart';
import 'package:guardix/utilities/dialogs/generic_dialog.dart';

Future<bool> showContactNotRegistered({required BuildContext context}) {
  return showGenericDialog(
    context: context,
    title: 'Contact Not Registered',
    content:
        'This contact is not registered.\nDo you want to inform about Gurdi-X?',
    optionsBuilder: () => {
      'Cancel': false,
      'Yes': true,
    },
  ).then(
    (value) => value ?? false,
  );
}
