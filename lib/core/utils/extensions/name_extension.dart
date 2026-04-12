extension NameFormatting on String? {
  String? get firstNameOrNull {
    final trimmedValue = this?.trim();
    if (trimmedValue == null || trimmedValue.isEmpty) {
      return null;
    }

    return trimmedValue.split(RegExp(r'\s+')).first;
  }
}
