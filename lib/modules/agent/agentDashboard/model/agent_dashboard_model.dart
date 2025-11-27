class DashboardModel {
  final String agentId;
  final int totalInvestments;
  final num totalAmount;
  final int totalClients;
  final num totalCommission;
  final num avgInvestment;
  final List<dynamic> recentInvestments;

  DashboardModel({
    required this.agentId,
    required this.totalInvestments,
    required this.totalAmount,
    required this.totalClients,
    required this.totalCommission,
    required this.avgInvestment,
    required this.recentInvestments,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      agentId: json["agentId"] ?? "",
      totalInvestments: json["totalInvestments"] ?? 0,
      totalAmount: json["totalAmount"] ?? 0,
      totalClients: json["totalClients"] ?? 0,
      totalCommission: json["totalCommission"] ?? 0,
      avgInvestment: json["avgInvestment"] ?? 0,
      recentInvestments: json["recentInvestments"] ?? [],
    );
  }
}
