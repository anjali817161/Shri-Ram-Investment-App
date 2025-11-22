// lib/views/portfolio_view.dart
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


  void initState() {
    super.initState();
    c.fetchInvestments();
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
                Text("Active investments", style: TextStyle(color: Colors.grey.shade400)),
                const SizedBox(height: 12),

                // TOP STAT ROW
                Row(
                  children: [
                    _statCard("+ ₹${active != null ? c.calculateGainsAndTotal(active)['gains'] : '0'}", "Gains"),
                    const SizedBox(width: 8),
                    _statCard("₹${active != null ? c.calculateGainsAndTotal(active)['total'] : '0'}", "Current value"),
                    const SizedBox(width: 8),
                    _statCard("₹${active?.investedAmount ?? 0}", "Invested"),
                  ],
                ),

                const SizedBox(height: 20),

                // Active investment card (monthly breakdown)
                if (active != null)
                  _activeInvestmentCard(active)
                else
                  _emptyActiveCard(),

                const SizedBox(height: 20),

                // Pending note
                if (c.pending.value)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade700,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text("⏳ Your latest investment will appear after 24 hours.",
                      style: TextStyle(color: Colors.white)),
                  ),

                const SizedBox(height: 20),

                // Previous investments list
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

                // Invest now button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.to(() => const InvestmentDetailsPage());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, foregroundColor: Colors.black,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Text("Invest now", style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ),
                ),
                const SizedBox(height: 60),
              ],
            ),
          ),
        );
      
      }
      ),
     
    );
  }

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
            Text(amount, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(label, style: TextStyle(color: Colors.grey.shade400)),
          ],
        ),
      ),
    );
  }

  Widget _emptyActiveCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text("No active investment found.", style: TextStyle(color: Colors.white70)),
    );
  }

  Widget _activeInvestmentCard(inv) {
    final ctrl = Get.find<PortfolioInvestmentController>();
    final breakdown = ctrl.monthlyBreakdownForInvestment(inv);
    final df = DateFormat('MMM yyyy');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Investment: ₹${inv.investedAmount} • ${inv.timeDuration} year(s)", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text("Agent: ${inv.agentId}", style: TextStyle(color: Colors.grey.shade400)),
          const SizedBox(height: 12),

          // monthly list scrollable
          SizedBox(
            height: 400,
            child: ListView.separated(
              itemCount: breakdown.length,
              separatorBuilder: (_,__) => Divider(color: Colors.grey.shade700), // grey divider
              itemBuilder: (context, index) {
                final item = breakdown[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(item['label'], style: const TextStyle(color: Colors.white)),
                      Text("₹${(item['amount'] as double).toStringAsFixed(0)}", style: TextStyle(color: Colors.grey.shade400)),
                    ],
                  ),
                  // Removed trailing 3 dots icon
                  onTap: () => _showMonthActions(context, inv.id, item['label'], item['amount']),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _previousInvestmentTile(inv) {
    final ctrl = Get.find<PortfolioInvestmentController>();
    final gainsTotal = ctrl.calculateGainsAndTotal(inv);
    return InkWell(
      onTap: () {
        _showMonthActions(context, inv.id, "Monthly Details", 0);
      },
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
                        DateFormat('dd MMM yyyy').format(DateTime.parse(inv.date ?? DateTime.now().toString())),
                        style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "₹${inv.investedAmount}",
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text("Total: ₹${gainsTotal['total'] ?? '-'} | Gains: +₹${gainsTotal['gains'] ?? '-'}",
                      style: TextStyle(color: Colors.grey.shade400)),
                ],
              ),
            ),
            // Remove the IconButton and make whole card clickable, so no trailing icon here
          ],
        ),
      ),
    );
  }

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
              Text(monthLabel, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Text("Monthly interest: ₹${amount.toStringAsFixed(0)}", style: TextStyle(color: Colors.grey.shade400)),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.remove_red_eye),
                      label: const Text("View Details"),
                      onPressed: () {
                        // For now we show a details dialog. You can expand to full screen details page
                        Navigator.of(context).pop();
                        _showDetailsDialog(context, investmentId, monthLabel, amount);
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black),
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
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.greenAccent, foregroundColor: Colors.black),
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

  void _showDetailsDialog(BuildContext context, String investmentId, String monthLabel, double amount) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xff0E0E0E),
        title: Text(monthLabel, style: const TextStyle(color: Colors.white)),
        content: Text("Monthly interest: ₹${amount.toStringAsFixed(0)}\nInvestmentId: $investmentId",
          style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("Close")),
        ],
      ),
    );
  }
}
