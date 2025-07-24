import 'package:flutter/cupertino.dart';

String getErrorMessage(String code) {
  switch (code) {
    case "email_taken":
      return "Email already in use";
    case "password_mismatch":
      return "Passwords do not match";
    default:
      return "Unknown error";
  }
}

void showErrorMessage(context, String code) {
  showCupertinoDialog(
    context: context,
    builder: (_) => CupertinoAlertDialog(
      title: Text(getErrorMessage(code)),
      actions: [
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () => Navigator.pop(context),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}
