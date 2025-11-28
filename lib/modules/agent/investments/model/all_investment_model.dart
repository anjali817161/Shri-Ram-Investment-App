class AgentInvestment {
  final String id;
  final String? userName;
  final String? userEmail;
  final int investedAmount;
  final int timeDuration;
  final String agentId;
  final String? image;
  final DateTime createdAt;
  final String status;
  final bool verified;

  AgentInvestment({
    required this.id,
    this.userName,
    this.userEmail,
    required this.investedAmount,
    required this.timeDuration,
    required this.agentId,
    this.image,
    required this.createdAt,
    required this.status,
    required this.verified,
  });

  factory AgentInvestment.fromJson(Map<String, dynamic> json) {
    return AgentInvestment(
      id: json["_id"],
      userName: json["user"]?["name"],
      userEmail: json["user"]?["email"],
      investedAmount: json["investedAmount"],
      timeDuration: json["timeDuration"],
      agentId: json["agentId"],
      image: json["image"],
      createdAt: DateTime.parse(json["createdAt"]),
      status: json["status"] ?? "pending",
      verified: json["verified"] ?? false,
    );
  }
}
