// lib/models/investment_model.dart
class InvestmentModel {
  final String id;
  final String userId;
  final int investedAmount;
  final int timeDuration;
  final String agentId;
  final String image; // relative path from server
  final DateTime createdAt;

  InvestmentModel({
    required this.id,
    required this.userId,
    required this.investedAmount,
    required this.timeDuration,
    required this.agentId,
    required this.image,
    required this.createdAt,
  });

  factory InvestmentModel.fromJson(Map<String, dynamic> json) {
    return InvestmentModel(
      id: json["_id"] as String,
      userId: (json["user"] ?? "") as String,
      investedAmount: (json["investedAmount"] is int)
          ? json["investedAmount"]
          : int.tryParse(json["investedAmount"].toString()) ?? 0,
      timeDuration: (json["timeDuration"] is int)
          ? json["timeDuration"]
          : int.tryParse(json["timeDuration"].toString()) ?? 0,
      agentId: (json["agentId"] ?? "") as String,
      image: (json["image"] ?? "") as String,
      createdAt: DateTime.parse(json["createdAt"] ?? DateTime.now().toIso8601String()),
    );
  }
}
