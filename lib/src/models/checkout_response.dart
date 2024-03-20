import 'dart:convert';

class SwervpayCheckoutResponseModel {
  final String? reference;
  final String checkoutId;
  final String status;

  SwervpayCheckoutResponseModel(
      {required this.reference,
      required this.checkoutId,
      required this.status});

  SwervpayCheckoutResponseModel copyWith({
    String? reference,
    String? checkoutId,
    String? status,
  }) {
    return SwervpayCheckoutResponseModel(
      reference: reference ?? this.reference,
      checkoutId: checkoutId ?? this.checkoutId,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'reference': reference,
      'checkoutId': checkoutId,
      'status': status,
    };
  }

  factory SwervpayCheckoutResponseModel.fromMap(Map<String, dynamic> map) {
    return SwervpayCheckoutResponseModel(
      reference: map['reference'] != null ? map['reference'] as String : null,
      checkoutId: map['checkoutId'] as String,
      status: map['status'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SwervpayCheckoutResponseModel.fromJson(String source) =>
      SwervpayCheckoutResponseModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'SwervpayCheckoutResponseModel(reference: $reference, checkoutId: $checkoutId, status: $status)';
}
