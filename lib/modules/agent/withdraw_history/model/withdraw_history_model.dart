class WithdrawModel {
  final String id;
  final String agentId;
  final int amount;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  WithdrawModel({
    required this.id,
    required this.agentId,
    required this.amount,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WithdrawModel.fromJson(Map<String, dynamic> json) {
    return WithdrawModel(
      id: json["_id"] ?? "",
      agentId: json["agentId"] ?? "",
      amount: json["amount"] ?? 0,
      status: json["status"] ?? "",
      createdAt: DateTime.parse(json["createdAt"]),
      updatedAt: DateTime.parse(json["updatedAt"]),
    );
  }
}
