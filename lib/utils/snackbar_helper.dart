import 'package:flutter/material.dart';

void showErrorMessage(
  BuildContext context,
  String message,
) {
  final snackBar = SnackBar(
    content: Text(
      message,
      style: const TextStyle(color: Colors.white),
    ),
    backgroundColor: Colors.red.shade300,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void showSuccessMessage(
  BuildContext context,
  String message,
) {
  final snackBar = SnackBar(
    content: Text(
      message,
      style: const TextStyle(color: Colors.white),
    ),
    backgroundColor: Colors.green.shade300,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
