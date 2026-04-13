// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/sms_permission_controller.dart';
import 'user_settings_content.dart';
import 'user_settings_feedback_listeners.dart';

class UserSettingsBody extends ConsumerStatefulWidget {
  const UserSettingsBody({super.key});

  @override
  ConsumerState<UserSettingsBody> createState() => _UserSettingsBodyState();
}

class _UserSettingsBodyState extends ConsumerState<UserSettingsBody>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(smsPermissionControllerProvider.notifier).refreshStatus();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(smsPermissionControllerProvider.notifier).refreshStatus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return const UserSettingsFeedbackListeners(child: UserSettingsContent());
  }
}
