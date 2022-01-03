class Currency {
  //Use an ISO alphabetic code
  final String isoCode;

  //The amount of [isoCode] currency
  double amount;

  Currency(
    this.isoCode, {
    this.amount = 0,
  }) {
    if (isoCode.length != 3) throw ArgumentError('The ISO code must have a lenght of 3.'); // Example: MYR, SGD, BND
    if (amount < 0) throw ArgumentError('Amount cannot be negative');
  }
}
