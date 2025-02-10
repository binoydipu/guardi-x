import 'package:flutter/material.dart';
import 'package:guardix/utilities/dialogs/generic_dialog.dart';

Future<String> showImageSourceDialog({
  required BuildContext context,
}) {
  return showGenericDialog(
    context: context,
    title: 'Choose Image Source',
    content: 'You will be redirected to the source.',
    optionsBuilder: () => {
      'Cancel': 'cancle',
      'Camera': 'camera',
      'Gallery': 'gallery',
    },
  ).then(
    (value) => value ?? 'cancle',
  );
}
