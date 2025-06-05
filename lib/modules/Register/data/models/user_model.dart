class User {
  final String user_id;
  final String user_name;
  final String user_email;
  final String user_password;
  final String role; // 'admin', 'doctor', 'patient'

  User({
    required this.user_id,
    required this.user_name,
    required this.user_email,
    required this.user_password,
    required this.role,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_id': user_id,
      'user_name': user_name,
      'user_email': user_email,
      'user_password': user_password,
      'role': role,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      user_id: map['user_id'],
      user_name: map['user_name'],
      user_email: map['user_email'],
      user_password: map['user_password'],
      role: map['role'],
    );
  }
}
