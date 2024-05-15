class SwervpayCustomerDataModel {
  final String email;
  final String firstname;
  final String lastname;
  final String phoneNumber;

  SwervpayCustomerDataModel({
    required this.email,
    required this.firstname,
    required this.lastname,
    required this.phoneNumber,
  });

  SwervpayCustomerDataModel copyWith({
    String? email,
    String? firstname,
    String? lastname,
    String? phoneNumber,
  }) {
    return SwervpayCustomerDataModel(
      email: email ?? this.email,
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'firstname': firstname,
      'lastname': lastname,
      'phone_number': phoneNumber,
    };
  }
}
