import 'package:flutter/material.dart';

void showErrorSnackbar({
  required BuildContext context,
  required String message,
}) {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Center(
        child: Text(message),
      ),
      backgroundColor: Theme.of(context).colorScheme.error,
    ),
  );
}

void showNormalSnackbar({
  required BuildContext context,
  required String message,
}) {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Center(
        child: Text(message),
      ),
    ),
  );
}
