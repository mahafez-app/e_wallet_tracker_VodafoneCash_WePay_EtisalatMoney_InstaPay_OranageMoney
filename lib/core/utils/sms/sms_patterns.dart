// lib/core/utils/sms/sms_patterns.dart

class SmsPatterns {
  SmsPatterns._();

  // ─── Arabic ───────────────────────────────────────────────────────────────

  /// تم استلام مبلغ 545 جنيه من رقم 01015698339
  /// تم استلام مبلغ 545.00 جنيه من رقم 01015698339
  static final arReceiveFromNumber = RegExp(
    r'(?:تم استلام|تم إيداع|استلمت)\s*(?:مبلغ)?\s*([\d,\.]+)\s*(?:جنيه|ج\.م|جم).*?(?:من رقم|من)\s*(\+?[\d]{8,13})',
  );

  /// تم تحويل 500 جنيه لرقم 01120892874
  static final arSendToNumber = RegExp(
    r'(?:تم تحويل|تم إرسال|حولت)\s*([\d,\.]+)\s*(?:جنيه|ج\.م|جم).*?(?:لرقم|إلى رقم|الى رقم)\s*(\+?[\d]{8,13})',
  );

  /// InstaPay / bank receive — no counterparty number
  /// تم إضافة تحويل لحظي لحسابكم رقم 0130 بمبلغ 1000.00 جم من NAME
  static final arBankReceive = RegExp(
    r'(?:تم إضافة تحويل|تم إيداع مبلغ).*?بمبلغ\s*([\d,\.]+)\s*(?:جم|جنيه|ج\.م)',
  );

  /// InstaPay / bank send — no counterparty number
  /// تم تنفيذ تحويل لحظي من حسابكم رقم 0130 بمبلغ 600.00 جم إلى NAME
  static final arBankSend = RegExp(
    r'(?:تم تنفيذ تحويل|تم تحويل مبلغ).*?بمبلغ\s*([\d,\.]+)\s*(?:جم|جنيه|ج\.م)',
  );

  // ─── English ──────────────────────────────────────────────────────────────

  /// Received EGP150 from 00201140932674 to Mobile Account Number 2111
  /// Mar 22, 2026 11:37:20 AM: Received EGP150 from 00201140932674
  static final enReceiveFromNumber = RegExp(
    r'[Rr]eceived\s+EGP\s*([\d,\.]+)\s+from\s+(\+?[\d]{8,13})',
  );

  /// Sent EGP500 to 01012345678
  /// You sent EGP 1,000.00 to 01094347803
  static final enSendToNumber = RegExp(
    r'(?:[Yy]ou\s+)?[Ss]ent\s+EGP\s*([\d,\.]+)\s+to\s+(\+?[\d]{8,13})',
  );

  /// Transfer of EGP 500.00 sent to 01012345678
  static final enTransferSentToNumber = RegExp(
    r'[Tt]ransfer\s+of\s+EGP\s*([\d,\.]+)\s+sent\s+to\s+(\+?[\d]{8,13})',
  );

  /// Transfer of EGP 500.00 received from 01012345678
  static final enTransferReceivedFromNumber = RegExp(
    r'[Tt]ransfer\s+of\s+EGP\s*([\d,\.]+)\s+received\s+from\s+(\+?[\d]{8,13})',
  );

  // ─── Reference numbers ────────────────────────────────────────────────────

  /// رقم العملية 018959810019   (VF-Cash, WePay)
  static final refOperationAr = RegExp(r'رقم العملية\s*([\d]+)');

  /// كود العملية 018959810019   (Orange)
  static final refCodeAr = RegExp(r'كود العملية\s*([\d]+)');

  /// رقم المرجع 018959810019    (Etisalat)
  static final refNumberAr = RegExp(r'رقم المرجع\s*([\d]+)');

  /// رقم مرجعي 643111494336     (InstaPay / banks)
  static final refBankAr = RegExp(r'رقم مرجعي\s*([\d]+)');

  /// Ref: 018959810019  /  Ref No. 018959810019
  static final refEn = RegExp(r'[Rr]ef(?:\s*[Nn]o\.?)?\s*[:\-]?\s*([\d]+)');

  // ─── Date / time ──────────────────────────────────────────────────────────

  /// 08-04-26 17:50   →   DD-MM-YY HH:mm
  static final dateShort = RegExp(r'(\d{2})-(\d{2})-(\d{2})\s+(\d{2}):(\d{2})');

  /// Mar 22, 2026 11:37:20 AM
  static final dateLongEn = RegExp(
    r'(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)\s+(\d{1,2}),\s+(\d{4})\s+(\d{1,2}):(\d{2}):(\d{2})\s+(AM|PM)',
    caseSensitive: false,
  );

  /// يوم 08-04-26 الساعة 17:50
  static final dateArabicBank = RegExp(
    r'يوم\s+(\d{2})-(\d{2})-(\d{2}).*?الساعة\s+(\d{2}):(\d{2})',
  );
}
