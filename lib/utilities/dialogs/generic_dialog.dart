import 'package:flutter/material.dart';

// a type definition for a function that returns a Map<String, T?>. The keys of the map represent the button labels in the dialog, and the values represent the associated return values when those buttons are pressed. The T here is a generic type, meaning the dialog can return values of any type.
typedef DialogOptionBuilder<T> = Map<String, T?> Function();

Future<T?> showGenericDialog<T>({
  required BuildContext context,
  required String title,
  required String content,
  required DialogOptionBuilder optionsBuilder,
}) {
  final options =
      optionsBuilder(); // Calls the optionsBuilder to generate the buttons and their return values.
  return showDialog<T>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: options.keys.map((optionTitle) {
          // optionTitle is a parameter of the anonymous function passed to the map method.
          final value = options[optionTitle];
          return TextButton(
            onPressed: () {
              if (value != null) {
                Navigator.of(context).pop(value);
              } else {
                Navigator.of(context).pop();
              }
            },
            child: Text(optionTitle),
          );
        }).toList(),
      );
    },
  );
}
