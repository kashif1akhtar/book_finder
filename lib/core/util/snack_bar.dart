// snackbar_helper.dart
import 'package:flutter/material.dart';

class SnackbarHelper {
  static void show(BuildContext context, String message,
      {String? actionLabel, VoidCallback? onAction}) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
      action: (actionLabel != null && onAction != null)
          ? SnackBarAction(
        label: actionLabel,
        onPressed: onAction,
      )
          : null,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
