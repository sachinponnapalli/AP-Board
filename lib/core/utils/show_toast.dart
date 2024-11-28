import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

void showToast(String message, int seconds) {
  toastification.show(
    description: Text(
      message,
    ),
    alignment: const Alignment(0.5, 0.9),
    showProgressBar: false,
    autoCloseDuration: Duration(seconds: seconds),
    icon: const Icon(Icons.school),
  );
}
