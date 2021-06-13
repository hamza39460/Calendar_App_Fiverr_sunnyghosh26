import 'package:flutter/material.dart';

class AppRoutes {
  static void push(BuildContext context, Widget page, {bool opaque = true}) {
    Navigator.of(context).push(new PageRouteBuilder(
        opaque: opaque, pageBuilder: (BuildContext context, _, __) => page));
  }

  static void pushWithThen(
      BuildContext context, Widget page, Function() thenFunction,
      {bool opaque = true}) {
    Navigator.of(context)
        .push(new PageRouteBuilder(
            opaque: opaque, pageBuilder: (BuildContext context, _, __) => page))
        .then((value) {
      thenFunction();
    });
  }

  static void replace(BuildContext context, Widget page) {
    Navigator.of(context).pushReplacement(
      new MaterialPageRoute(builder: (context) => page),
    );
  }

  static void makeFirst(BuildContext context, Widget page) {
    Navigator.of(context).popUntil((predicate) => predicate.isFirst);
    Navigator.of(context).pushReplacement(
      new MaterialPageRoute(builder: (context) => page),
    );
  }

  static void removeAllprevious(BuildContext context) {
    Navigator.of(context).popUntil((predicate) => predicate.isFirst);
  }

  static void pop(BuildContext context) {
    Navigator.of(context).pop();
  }

  static void dismissAlert(context) {
    Navigator.of(context).pop();
  }

  static void bottomSheetOpen(BuildContext context, Widget sheet,
      {isDismissible = false}) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return sheet;
      },
      isDismissible: isDismissible,
      isScrollControlled: true,
    );
  }

  static void bottomSheetOpenWithThen(
      BuildContext context, Widget sheet, Function() thenFunction,
      {isDismissible = false}) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return sheet;
      },
      isDismissible: isDismissible,
      isScrollControlled: true,
    ).then((value) {
      thenFunction();
    });
  }
}
