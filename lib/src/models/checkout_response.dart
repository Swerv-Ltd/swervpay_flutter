import 'dart:convert';

class SwervpayCheckoutResponseModel {
  final String? reference;
  final String checkoutId;
  final String status;
  final double? amount;
  final String? currency;
  final double? charges;
  SwervpayCheckoutResponseModel({
    this.reference,
    required this.checkoutId,
    required this.status,
    this.amount,
    this.currency,
    this.charges,
  });

  SwervpayCheckoutResponseModel copyWith({
    String? reference,
    String? checkoutId,
    String? status,
    double? amount,
    String? currency,
    double? charges,
  }) {
    return SwervpayCheckoutResponseModel(
      reference: reference ?? this.reference,
      checkoutId: checkoutId ?? this.checkoutId,
      status: status ?? this.status,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      charges: charges ?? this.charges,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'reference': reference,
      'checkoutId': checkoutId,
      'status': status,
      'amount': amount,
      'currency': currency,
      'charges': charges,
    };
  }

  factory SwervpayCheckoutResponseModel.fromMap(Map<String, dynamic> map) {
    return SwervpayCheckoutResponseModel(
      reference: map['reference'] != null ? map['reference'] as String : null,
      checkoutId: map['checkoutId'] as String,
      status: map['status'] as String,
      amount: map['amount'] != null ? dynamicToDouble(map['amount']) : null,
      currency: map['currency'] != null ? map['currency'] as String : null,
      charges: map['charges'] != null ? dynamicToDouble(map['charges']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SwervpayCheckoutResponseModel.fromJson(String source) =>
      SwervpayCheckoutResponseModel.fromMap(
          json.decode(source) as Map<String, dynamic>);
}

double dynamicToDouble(dynamic value) {
  if (value is int) {
    return value.toDouble();
  } else if (value is double) {
    return value;
  } else {
    return 0;
  }
}
