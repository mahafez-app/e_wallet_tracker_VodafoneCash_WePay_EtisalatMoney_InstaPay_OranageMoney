// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart';

import '../../../../core/utils/extensions/localization_extension.dart';
import '../widgets/user_settings_body.dart';

class UserSettingsScreen extends StatelessWidget {
  const UserSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const _UserSettingsTitle()),
      body: const SafeArea(child: UserSettingsBody()),
    );
  }
}

class _UserSettingsTitle extends StatelessWidget {
  const _UserSettingsTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(context.l10n.userSettingsTitle);
  }
}
