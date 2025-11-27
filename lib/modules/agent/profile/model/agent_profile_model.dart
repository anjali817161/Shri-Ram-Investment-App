class AgentProfileModel {
  String? id;
  String? name;
  String? email;
  String? phone;
  String? gender;
  String? address;
  String? userId;
  String? createdAt;
  String? updatedAt;

  AgentProfileModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.gender,
    this.address,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  factory AgentProfileModel.fromJson(Map<String, dynamic> json) {
    final data = json["agent"] ?? json; // support both direct & wrapped JSON

    return AgentProfileModel(
      id: data["_id"],
      name: data["name"],
      email: data["email"],
      phone: data["phone"],
      gender: data["gender"],
      address: data["address"],
      userId: data["userId"]?.toString(),
      createdAt: data["createdAt"],
      updatedAt: data["updatedAt"],
    );
  }
}
