import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HelperMethods {
  static String formatDateTime(DateTime dateTime) {
    DateFormat dateFormat = DateFormat("MMM dd, yyyy h:mma");
    return dateFormat.format(dateTime);
  }

  static showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
