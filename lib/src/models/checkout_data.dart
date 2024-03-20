import 'dart:convert';

class SwervpayCheckoutDataModel {
  final String? reference;
  final double amount;
  final String? description;
  final String currency;

  SwervpayCheckoutDataModel(
      {required this.reference,
      required this.amount,
      required this.description,
      required this.currency});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'reference': reference,
      'amount': amount,
      'description': description,
      'currency': currency,
    };
  }

  String toJson() => json.encode(toMap());
}
