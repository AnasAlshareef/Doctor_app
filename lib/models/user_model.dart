class UserModel {
  final String uid;
  final String email;
  final String name;
  final String role; // 'doctor' or 'patient'
  final String? specialization; // Only for doctors
  final String? photoUrl;
  final String? phoneNumber;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.role,
    this.specialization,
    this.photoUrl,
    this.phoneNumber,
  });

  // Convert to map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'role': role,
      'specialization': specialization,
      'photoUrl': photoUrl,
      'phoneNumber': phoneNumber,
    };
  }

  // Create from Firestore document
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      role: map['role'] ?? '',
      specialization: map['specialization'],
      photoUrl: map['photoUrl'],
      phoneNumber: map['phoneNumber'],
    );
  }
}