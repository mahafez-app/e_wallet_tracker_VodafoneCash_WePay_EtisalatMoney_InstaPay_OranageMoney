import 'package:flutter/material.dart';

import '../../../../core/utils/extensions/localization_extension.dart';
import '../widgets/invitations/invitations_body.dart';

class InvitationsScreen extends StatelessWidget {
  const InvitationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.invitationsTitle)),
      body: const SafeArea(child: InvitationsBody()),
    );
  }
}
