import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeram_investment_app/modules/bonds/widget/bond_card.dart';
import '../controller/bonds_controller.dart';

class BondsPage extends StatelessWidget {
  final BondsController controller = Get.put(BondsController());

  BondsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: const Text(
            "LIVE BONDS (30)",
            style: TextStyle(color: Colors.white),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _filterChip("All", selected: true),
                  const SizedBox(width: 8),
                  _filterChip("High rated"),
                  const SizedBox(width: 8),
                  _filterChip("Short tenure"),
                  const SizedBox(width: 8),
                  _filterChip("High returns"),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(
                () => ListView.builder(
                  itemCount: controller.bonds.length,
                  itemBuilder: (context, index) {
                    return BondCard(bond: controller.bonds[index]);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterChip(String label, {bool selected = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? Colors.white : const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.black : Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
