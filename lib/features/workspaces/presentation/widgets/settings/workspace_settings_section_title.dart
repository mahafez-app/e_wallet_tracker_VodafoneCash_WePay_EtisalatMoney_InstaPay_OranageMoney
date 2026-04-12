// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart';

class WorkspaceSettingsSectionTitle extends StatelessWidget {
  const WorkspaceSettingsSectionTitle({
    super.key,
    required this.title,
    this.isDanger = false,
  });

  final String title;
  final bool isDanger;

  @override
  Widget build(BuildContext context) {
    final color = isDanger
        ? Theme.of(context).colorScheme.error
        : Theme.of(context).colorScheme.onSurfaceVariant;

    return Text(
      title,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
        color: color,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}
