import 'package:flutter/material.dart';

import '../widgets/sms_permissions_body.dart';

class SmsPermissionsScreen extends StatelessWidget {
  const SmsPermissionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SafeArea(child: SmsPermissionsBody()));
  }
}
