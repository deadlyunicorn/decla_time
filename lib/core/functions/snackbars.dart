import "package:flutter/material.dart";

void showErrorSnackbar({
  required BuildContext context,
  required String message,
  TextAlign? textAlign = TextAlign.center,
}) {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Center(
        child: Text(
          message,
          textAlign: textAlign,
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.error,
    ),
  );
}

void showNormalSnackbar({
  required BuildContext context,
  required String message,
  TextAlign? textAlign = TextAlign.center,
  Duration duration = const Duration(milliseconds: 4000),
  
}) {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: duration,
      content: Center(
        child: Text(
          message,
          textAlign: textAlign,
        ),
      ),
    ),
  );
}
