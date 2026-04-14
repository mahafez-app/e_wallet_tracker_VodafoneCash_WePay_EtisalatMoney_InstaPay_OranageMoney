import 'package:flutter/material.dart';

extension RoutesExtension on BuildContext {
  // PopUntil with go router
  void popUntil(bool Function(Route<dynamic>) predicate) {
    Navigator.of(this).popUntil(predicate);
  }
}
