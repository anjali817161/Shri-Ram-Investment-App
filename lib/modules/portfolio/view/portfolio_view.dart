import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeram_investment_app/modules/invest_form/view/invest_form.dart';
import 'package:intl/intl.dart';
import 'package:shreeram_investment_app/modules/navbar/bottom_navbar.dart';
import 'package:shreeram_investment_app/modules/portfolio/controller/portfolio_controller.dart';

class PortfolioView extends StatefulWidget {
  PortfolioView({super.key});

  @override
  State<PortfolioView> createState() => _PortfolioViewState();
}

class _PortfolioViewState extends State<PortfolioView> {
  final PortfolioInvestmentController c = Get.put(PortfolioInvestmentController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      c.fetchInvestments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0E0E0E),
      appBar: AppBar(
        backgroundColor: const Color(0xff0E0E0E),
        elevation: 0,
        title: const Text("My Portfolio"),
      ),
      bottomNavigationBar: const BottomNavBar(),
      body: Obx(() {
        if (c.isLoading.value && c.investments.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        final active = c.activeInvestment.value;
        final prev = c.previousInvestments;

        return RefreshIndicator(
          onRefresh: c.fetchInvestments,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 6),

                /// ---------- ACTIVE INVESTMENT STATS (unchanged) ----------
                Row(
                  children: [
                    Text("Active investments", style: TextStyle(color: Colors.grey.shade400)),
                    Container(
                      margin: const EdgeInsets.only(left: 8),
                      padding:
                          const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.green.shade600,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "SEBI Regitered",
                        style: const TextStyle(
                            color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    _statCard(
                      "+ ₹${active != null ? c.calculateGainsAndTotal(active)['gains'] : '0'}",
                      "Monthly cumulative gain",
                    ),
                    const SizedBox(width: 8),
                    _statCard(
                      "₹${active != null ? c.calculateGainsAndTotal(active)['total'] : '0'}",
                      "Cumulative current value",
                    ),
                    const SizedBox(width: 8),
                    _statCard("₹${active?.investedAmount ?? 0}", "Invested"),
                  ],
                ),

                const SizedBox(height: 20),

                /// ---------- REPLACED SECTION START ----------
                /// Instead of Active Investment Card, we show dynamic dropdown list
                _dynamicInvestmentDropdownList(),
                /// ---------- REPLACED SECTION END ----------

                const SizedBox(height: 20),

               /// ---------- TOTAL INVESTMENT STATS ----------
                // Text("Overall investments", style: TextStyle(color: Colors.grey.shade400)),
                // const SizedBox(height: 12),

                // Row(
                //   children: [
                //     _statCard(
                //   "+  ₹${c.activeInvestment}",
                //       "Monthly cumulative gain",
                //     ),
                //     const SizedBox(width: 8),
                //     _statCard(
                //       "₹${active != null ? c.calculateGainsAndTotal(active)['total'] : '0'}",
                //       "Cumulative current value",
                //     ),
                //     const SizedBox(width: 8),
                //     _statCard("₹${active?.investedAmount ?? 0}", "Invested"),
                //   ],
                // ),

                // const SizedBox(height: 20),

                if (c.pending.value)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade700,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      "⏳ Your latest investment will appear after 24 hours.",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),

                const SizedBox(height: 20),

                /// ---------- PREVIOUS INVESTMENTS ----------
                if (prev.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Previous investments", style: TextStyle(color: Colors.white70)),
                      const SizedBox(height: 12),
                      ...prev.map((inv) => _previousInvestmentTile(inv)).toList(),
                    ],
                  ),

                const SizedBox(height: 18),

                /// ---------- INVEST NOW ----------
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.to(() => const InvestmentDetailsPage());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Text("Invest now",
                          style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ),
                ),

                const SizedBox(height: 60),
              ],
            ),
          ),
        );
      }),
    );
  }

  // --------------------------------------------------------------------------- 
  // STAT CARD
  Widget _statCard(String amount, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(amount,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 6),
            Center(child: Text(label, style: TextStyle(color: Colors.grey.shade400, fontSize: 12))),
          ],
        ),
      ),
    );
  }
Widget _dynamicInvestmentDropdownList() {
  final list = c.investments;

  if (list.isEmpty) {
    return _emptyActiveCard();
  }

  // 🔥 Always sort latest first
  list.sort((a, b) => b.createdAt.compareTo(a.createdAt));

  return Column(
    children: List.generate(list.length, (index) {
      final inv = list[index];
      final monthList = c.monthlyBreakdownForInvestment(inv);

      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
            dividerColor: Colors.transparent,
          ),
          child: ExpansionTile(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),

            // ------------------------------------------------------------
            // 🔹 TOP COLLAPSED HEADER
            // ------------------------------------------------------------
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 💰 Amount
                Text(
                  "₹${inv.investedAmount}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),

                const SizedBox(height: 4),

                // 📅 Date + Duration (Years)
                Row(
                  children: [
                    Icon(Icons.calendar_month, size: 16, color: Colors.white60),
                    const SizedBox(width: 5),
                    Text(
                      DateFormat('dd MMM yyyy').format(inv.createdAt),
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                    ),

                    const SizedBox(width: 12),

                    Icon(Icons.timelapse_rounded, size: 16, color: Colors.white60),
                    const SizedBox(width: 5),

                    // 🟢 Years
                    Text(
                      "${inv.timeDuration} year${inv.timeDuration > 1 ? 's' : ''}",
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),

            iconColor: Colors.white,
            collapsedIconColor: Colors.white,

            childrenPadding: EdgeInsets.zero,

            // ------------------------------------------------------------
            // 🔻 EXPANDED VIEW CONTENT
            // ------------------------------------------------------------
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.03),
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(14)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // -----------------------------------------------------
                    // 🔹 Heading text (Dynamic)
                    // -----------------------------------------------------
                    Text(
                      "Monthly breakdown for ₹${inv.investedAmount} (${inv.timeDuration} year${inv.timeDuration > 1 ? 's' : ''})",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // -----------------------------------------------------
                    // 🔹 Monthly breakdown LIST
                    // -----------------------------------------------------
                    Column(
                      children: List.generate(monthList.length, (i) {
                        final m = monthList[i];

                        return Column(
                          children: [
                            ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,

                              title: Text(
                                m['label'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),

                              trailing: Text(
                                "₹${(m['amount'] as double).toStringAsFixed(0)}",
                                style: const TextStyle(
                                  color: Colors.greenAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),

                              onTap: () => _showMonthActions(
                                context,
                                inv.id,
                                m['label'],
                                m['amount'],
                              ),
                            ),

                            if (i != monthList.length - 1)
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 6),
                                height: 1,
                                color: Colors.white12,
                              ),
                          ],
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }),
  );
}



  Widget _emptyActiveCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text("No active investment found.",
          style: TextStyle(color: Colors.white70)),
    );
  }

  // --------------------------------------------------------------------------- 
  // PREVIOUS INVESTMENT TILE (unchanged)
  Widget _previousInvestmentTile(inv) {
    final ctrl = Get.find<PortfolioInvestmentController>();
    final gainsTotal = ctrl.calculateGainsAndTotal(inv);

    return InkWell(
      onTap: () => _showMonthActions(context, inv.id, "Monthly Details", 0),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Expanded(
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                    DateFormat('dd MMM yyyy').format(inv.createdAt),
                    style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Column(
                    children: [
                      Text(
                      "₹${inv.investedAmount}",
                      style: const TextStyle(
                        color: Colors.green, fontWeight: FontWeight.w900, fontSize: 18),
                      ),
                    ],
                    ),
                  ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                    "Total: ₹${gainsTotal['total'] ?? '-'} | Gains: +₹${gainsTotal['gains'] ?? '-'}",
                    style: TextStyle(color: Colors.grey.shade400),
                    ),
                    IconButton(
                    icon: const Icon(Icons.download, color: Colors.white70),
                    onPressed: () {
                      final ctrl = Get.find<PortfolioInvestmentController>();
                      ctrl.downloadInvestmentReport(inv.id);
                    },
                    ),
                  ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------------------------------- 
  // BOTTOM SHEET ACTIONS
  void _showMonthActions(BuildContext context, String investmentId, String monthLabel, double amount) {
    final ctrl = Get.find<PortfolioInvestmentController>();
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xff0E0E0E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(monthLabel,
                  style: const TextStyle(
                      color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Text("Monthly interest: ₹${amount.toStringAsFixed(0)}",
                  style: TextStyle(color: Colors.grey.shade400)),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.remove_red_eye),
                      label: const Text("View Details"),
                      onPressed: () {
                        Navigator.of(context).pop();
                        _showDetailsDialog(context, investmentId, monthLabel, amount);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white, foregroundColor: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.download),
                      label: const Text("Download PDF"),
                      onPressed: () {
                        Navigator.of(context).pop();
                        ctrl.downloadInvestmentReport(investmentId);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.greenAccent, foregroundColor: Colors.black),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  // --------------------------------------------------------------------------- 
  void _showDetailsDialog(
      BuildContext context, String investmentId, String monthLabel, double amount) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xff0E0E0E),
        title: Text(monthLabel, style: const TextStyle(color: Colors.white)),
        content: Text(
          "Monthly interest: ₹${amount.toStringAsFixed(0)}\nInvestmentId: $investmentId",
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }
}
