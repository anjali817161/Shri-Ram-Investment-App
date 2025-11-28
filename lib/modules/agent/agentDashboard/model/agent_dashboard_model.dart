class DashboardResponse {
  final bool success;
  final DashboardData dashboard;

  DashboardResponse({
    required this.success,
    required this.dashboard,
  });

  factory DashboardResponse.fromJson(Map<String, dynamic> json) {
    return DashboardResponse(
      success: json["success"] ?? false,
      dashboard: DashboardData.fromJson(json["dashboard"] ?? {}),
    );
  }
}

class DashboardData {
  final String agentId;
  final int totalInvestments;
  final int totalAmount;
  final int totalClients;
  final int totalCommission;
  final int avgInvestment;
  final List<RecentInvestment> recentInvestments;

  DashboardData({
    required this.agentId,
    required this.totalInvestments,
    required this.totalAmount,
    required this.totalClients,
    required this.totalCommission,
    required this.avgInvestment,
    required this.recentInvestments,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      agentId: json["agentId"] ?? "",
      totalInvestments: json["totalInvestments"] ?? 0,
      totalAmount: json["totalAmount"] ?? 0,
      totalClients: json["totalClients"] ?? 0,
      totalCommission: json["totalCommission"] ?? 0,
      avgInvestment: json["avgInvestment"] ?? 0,
      recentInvestments: (json["recentInvestments"] as List? ?? [])
          .map((e) => RecentInvestment.fromJson(e))
          .toList(),
    );
  }
}

class RecentInvestment {
  final String id;
  final String user;
  final int investedAmount;
  final int timeDuration;
  final String agentId;
  final String image;
  final String createdAt;
  final String status;
  final bool verified;

  RecentInvestment({
    required this.id,
    required this.user,
    required this.investedAmount,
    required this.timeDuration,
    required this.agentId,
    required this.image,
    required this.createdAt,
    required this.status,
    required this.verified,
  });

  factory RecentInvestment.fromJson(Map<String, dynamic> json) {
    return RecentInvestment(
      id: json["_id"] ?? "",
      user: json["user"] ?? "",
      investedAmount: json["investedAmount"] ?? 0,
      timeDuration: json["timeDuration"] ?? 0,
      agentId: json["agentId"] ?? "",
      image: json["image"] ?? "",
      createdAt: json["createdAt"] ?? "",
      status: json["status"] ?? "",
      verified: json["verified"] ?? false,
    );
  }
}
