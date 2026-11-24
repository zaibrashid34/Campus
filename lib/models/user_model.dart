import '../utils/encryption_helper.dart';

class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String profileImage;
  final String campusRole; // e.g., 'Student', 'Faculty', 'Admin'
  final String preferredLocation;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    this.profileImage = '',
    this.campusRole = 'Student',
    this.preferredLocation = 'Main Library Plaza',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phone': EncryptionHelper.encryptData(phone), // Encrypted before storage
      'profileImage': profileImage,
      'campusRole': campusRole,
      'preferredLocation': preferredLocation,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      phone: EncryptionHelper.decryptData(map['phone'] ?? ''), // Decrypted when used in app
      profileImage: map['profileImage'] ?? '',
      campusRole: map['campusRole'] ?? 'Student',
      preferredLocation: map['preferredLocation'] ?? 'Main Library Plaza',
    );
  }

  UserModel copyWith({
    String? id,
    String? fullName,
    String? email,
    String? phone,
    String? profileImage,
    String? campusRole,
    String? preferredLocation,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileImage: profileImage ?? this.profileImage,
      campusRole: campusRole ?? this.campusRole,
      preferredLocation: preferredLocation ?? this.preferredLocation,
    );
  }
}
