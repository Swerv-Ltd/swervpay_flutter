import 'dart:convert';

import 'package:swervpay_widget/swervpay_widget.dart';

class SwervpayCheckoutDataModel {
  final String? reference;
  final double amount;
  final String? description;
  final String currency;
  final SwervpayCustomerDataModel? customer;
  final Map<String, dynamic>? metadata;

  SwervpayCheckoutDataModel({
    required this.reference,
    required this.amount,
    required this.description,
    required this.currency,
    this.customer,
    this.metadata,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'reference': reference,
      'amount': amount,
      'description': description,
      'currency': currency,
      'customer': customer?.toMap() ?? '{}',
      'metadata': metadata ?? '{}'
    };
  }

  String toJson() => json.encode(toMap());
}
