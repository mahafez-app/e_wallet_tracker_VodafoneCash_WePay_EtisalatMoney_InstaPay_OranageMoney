enum WalletProvider {
  vodafoneCash,
  orangeMoney,
  etisalatCash,
  instaPay,
  wePay,
  unknown;

  static WalletProvider fromString(String value) {
    switch (value.toLowerCase().replaceAll(' ', '_')) {
      case 'vodafone_cash':
      case 'vodafone':
        return WalletProvider.vodafoneCash;
      case 'orange_money':
      case 'orange':
        return WalletProvider.orangeMoney;
      case 'etisalat_cash':
      case 'etisalat':
        return WalletProvider.etisalatCash;
      case 'instapay':
        return WalletProvider.instaPay;
      case 'we_pay':
      case 'we':
        return WalletProvider.wePay;
      default:
        return WalletProvider.unknown;
    }
  }

  String get toValue => switch (this) {
    WalletProvider.vodafoneCash => 'vodafone_cash',
    WalletProvider.orangeMoney => 'orange_money',
    WalletProvider.etisalatCash => 'etisalat_cash',
    WalletProvider.instaPay => 'instapay',
    WalletProvider.wePay => 'we_pay',
    WalletProvider.unknown => 'unknown',
  };
}
