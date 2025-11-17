import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeram_investment_app/modules/bonds/view/bonds_view.dart';
import 'package:shreeram_investment_app/modules/invest_form/view/invest_form.dart';
import 'package:shreeram_investment_app/modules/navbar/bottom_navbar.dart';

class PortfolioView extends StatefulWidget {
  const PortfolioView({super.key});

  @override
  State<PortfolioView> createState() => _PortfolioViewState();
}

class _PortfolioViewState extends State<PortfolioView>
    with TickerProviderStateMixin {
  late TabController _mainTabController;
  int _selectedSubTab = 0;

  @override
  void initState() {
    super.initState();
    _mainTabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0E0E0E),
      bottomNavigationBar: _buildBottomNav(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 4),
            _buildMainTabs(),
            const Divider(color: Colors.grey, height: 0.5),
            Expanded(
              child: TabBarView(
                controller: _mainTabController,
                children: [
                  _buildBondsSection(),
                  _buildFDsSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // HEADER
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "My Portfolio",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
         
        ],
      ),
    );
  }

  // MAIN TABS (BONDS | FDs)
  Widget _buildMainTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TabBar(
        controller: _mainTabController,
        indicatorColor: const Color(0xff16C47F),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey,
        dividerColor: Colors.transparent,
        labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
        tabs: const [
          Tab(text: "Bonds"),
          Tab(text: "FDs"),
        ],
      ),
    );
  }

  // ------------------- BONDS SECTION -------------------
  Widget _buildBondsSection() {
    return Column(
      children: [
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedSubTab = 0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _selectedSubTab == 0
                            ? Colors.white
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "REPAYMENTS",
                        style: TextStyle(
                          color: _selectedSubTab == 0
                              ? Colors.black
                              : Colors.grey.shade400,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedSubTab = 1),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _selectedSubTab == 1
                            ? Colors.white
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "INVESTMENTS",
                        style: TextStyle(
                          color: _selectedSubTab == 1
                              ? Colors.black
                              : Colors.grey.shade400,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: _selectedSubTab == 0 ? _buildRepaymentsView() : _buildInvestmentsView(),
        ),
      ],
    );
  }

  Widget _buildRepaymentsView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Upcoming",
              style: TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(height: 4),
          const Text(
            "₹0",
            style: TextStyle(
                color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 18),
          _glassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Track all your repayments",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Plan your future investments by tracking your repayments efficiently.",
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(height: 18),
                Column(
                  children: [
                    _repaymentTile("25 Mar", "₹13,500", "Interest"),
                    const Divider(color: Colors.grey, height: 1),
                    _repaymentTile("5 Apr", "₹1,15,000", "Pri + Int"),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: (){
                          Get.to(() => InvestmentDetailsPage());
                        },
                        child: Text("Invest now",
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 14)),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.arrow_forward, size: 18, color: Colors.black),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInvestmentsView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Active investments",
              style: TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _statTile("+ ₹0", "Gains"),
              _statTile("₹0", "Current value"),
              _statTile("₹0", "Invested"),
            ],
          ),
          const SizedBox(height: 26),
          _glassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Bring stability to your portfolio",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Invest in bonds to earn steady returns.",
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(height: 18),
                Center(
                  child: Image.asset(
                    'assets/images/bonds.jpg',
                    height: 220,
                  ),
                ),
                const SizedBox(height: 18),
                _buildPrimaryButton("Invest now"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ------------------- FDs SECTION -------------------
  Widget _buildFDsSection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Active investments",
              style: TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(height: 14),
          Row(
            children: [
              _statTile("₹0", "Invested amount"),
              _statTile("₹0", "Current amount"),
            ],
          ),
          const SizedBox(height: 26),
          _glassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Better FDs and experience coming soon",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Image.asset(
                    'assets/images/fd.jpg',
                    height: 220,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ------------------- COMPONENTS -------------------

  Widget _repaymentTile(String date, String amount, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(date, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.grey.shade900, Colors.black],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white10),
            ),
            child: Row(
              children: [
                Text(
                  amount,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 8),
                Text(label,
                    style:
                        const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statTile(String amount, String label) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey.shade900, Colors.black],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          children: [
            Text(
              amount,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
            const SizedBox(height: 6),
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12))
          ],
        ),
      ),
    );
  }

  Widget _buildPrimaryButton(String title) {
    return GestureDetector(
      onTap: () {
        Get.to(() => InvestmentDetailsPage());
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          // gradient: const LinearGradient(
          //   colors: [Color(0xff16C47F), Color(0xff0ED286)],
          // ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title,
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 14)),
            const SizedBox(width: 6),
            const Icon(Icons.arrow_forward, size: 18, color: Colors.black),
          ],
        ),
      ),
    );
  }

  Widget _glassCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: child,
    );
  }

  Widget _buildBottomNav() {
    return BottomNavBar(currentIndex: 1);
  }
}
