/// Authenticated user model.
class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final String token;
  final String avatarUrl;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.role = 'Member',
    required this.token,
    this.avatarUrl = '',
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String? ?? 'user_1',
      name: json['name'] as String? ?? 'Sankar User',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      role: json['role'] as String? ?? 'Member',
      token: json['token'] as String? ?? '',
      avatarUrl: json['avatarUrl'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'role': role,
        'token': token,
        'avatarUrl': avatarUrl,
      };
}
