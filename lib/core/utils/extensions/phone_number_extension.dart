import '../egyptian_phone_number.dart';

extension PhoneNumberFormatting on String {
  String get formattedEgyptianPhoneNumber =>
      EgyptianPhoneNumber.formatForDisplay(this);
}
