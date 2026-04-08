import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../generated/l10n.dart';

extension DateFormatting on DateTime {
  String toTimeAgo(BuildContext context) {
    final s = S.of(context);
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inMinutes < 1) {
      return s.homeJustNow;
    } else if (difference.inHours < 1) {
      return s.homeMinutesAgo(difference.inMinutes);
    } else if (difference.inDays < 1) {
      return DateFormat.jm(
        Localizations.localeOf(context).languageCode,
      ).format(this);
    } else if (difference.inDays < 2) {
      // Need a "Yesterday" translation ideally, but formatting as date is safe
      return DateFormat.yMMMd(
        Localizations.localeOf(context).languageCode,
      ).format(this);
    } else {
      return DateFormat.yMMMd(
        Localizations.localeOf(context).languageCode,
      ).format(this);
    }
  }
}
