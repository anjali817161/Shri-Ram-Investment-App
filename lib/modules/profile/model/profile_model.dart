class UserProfileResponse {
  final UserData? user;

  UserProfileResponse({this.user});

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) {
    return UserProfileResponse(
      user: json["user"] != null ? UserData.fromJson(json["user"]) : null,
    );
  }
}

class UserData {
  final String? id;
  final String? name;
  final String? email;
  final String? phone;

  UserData({
    this.id,
    this.name,
    this.email,
    this.phone,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json["id"],
      name: json["name"],
      email: json["email"],
      phone: json["phone"],
    );
  }
}
