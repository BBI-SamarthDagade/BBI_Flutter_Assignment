class ProfileModel {
  final String imageUrl;
  final String username;
  final String phoneNumber;
  final String address;

  ProfileModel({
    required this.imageUrl,
    required this.username,
    required this.phoneNumber,
    required this.address,
  });

  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
      'username': username,
      'phoneNumber': phoneNumber,
      'address': address,
    };
  }

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      imageUrl: json['imageUrl'],
      username: json['username'],
      phoneNumber: json['phoneNumber'],
      address: json['address'],
    );
  }
}