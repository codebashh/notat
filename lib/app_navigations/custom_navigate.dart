import 'package:flutter/material.dart';

class CustomNavigate {
  static navigateTo(BuildContext context, String route,
      {Map arguments = const {}}) {
    Navigator.pushNamed(context, '/$route', arguments: arguments);
  }

  static Future<bool?> navigateToClass(
      BuildContext context, Widget route) async {
    final result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => route));
    return result;
  }

  static navigateReplacement(BuildContext context, String route,
      {Map arguments = const {}}) {
    Navigator.pushNamed(context, '/$route', arguments: arguments);
  }
}
