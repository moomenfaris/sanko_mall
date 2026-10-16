import 'package:equatable/equatable.dart';

/// Authenticated user (or guest). Backend-ready: maps to/from JSON.
class UserModel extends Equatable {
  const UserModel({
    required this.id,
    required this.email,
    required this.token,
    this.isGuest = false,
  });

  final String id;
  final String email;
  final String token;
  final bool isGuest;

  factory UserModel.guest() => const UserModel(
    id: 'guest',
    email: 'guest@sankomall.local',
    token: 'guest-token',
    isGuest: true,
  );

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'] as String,
    email: json['email'] as String,
    token: json['token'] as String,
    isGuest: json['isGuest'] as bool? ?? false,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'token': token,
    'isGuest': isGuest,
  };

  @override
  List<Object?> get props => [id, email, token, isGuest];
}
