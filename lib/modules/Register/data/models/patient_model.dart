class Patient {
  final String patient_address;
  final String patient_id;
  final String patient_email;
  final String patient_name;

  final String patient_password;
  final String patient_phone;

  Patient({
    required this.patient_address,
    required this.patient_id,
    required this.patient_email,
    required this.patient_name,
    required this.patient_password,
    required this.patient_phone,
  });

  factory Patient.fromMap(Map<String, dynamic> map) {
    return Patient(
      patient_address: map['patient_address'],
      patient_id: map['patient_id'],
      patient_email: map['patient_email'],
      patient_name: map['patient_name'],
      patient_password: map['patient_password'],
      patient_phone: map['patient_phone'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'patient_address': patient_address,
      'patient_id': patient_id,
      'patient_email': patient_email,
      'patient_name': patient_name,
      'patient_password': patient_password,
      'patient_phone': patient_phone,
    };
  }
}
