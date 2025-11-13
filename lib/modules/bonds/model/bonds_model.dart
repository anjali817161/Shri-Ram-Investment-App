class BondModel {
  final String name;
  final String month;
  final double rate;
  final double oldRate;
  final int soldPercent;
  final String minAmount;
  final String tenure;
  final String tag;

  BondModel({
    required this.name,
    required this.month,
    required this.rate,
    required this.oldRate,
    required this.soldPercent,
    required this.minAmount,
    required this.tenure,
    required this.tag,
  });
}
