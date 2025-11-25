// lib/controllers/investment_controller.dart
import 'dart:convert';
import 'dart:math';
import 'package:get/get.dart';
import 'package:shreeram_investment_app/modules/portfolio/model/portfolio_model.dart';
import 'package:shreeram_investment_app/services/auth_repository.dart';
import 'package:shreeram_investment_app/services/sharedPreferences.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';

class PortfolioInvestmentController extends GetxController {
  final AuthRepository _repo = AuthRepository();

  var isLoading = false.obs;
  var investments = <InvestmentModel>[].obs;
  var activeInvestment = Rxn<InvestmentModel>();
  var previousInvestments = <InvestmentModel>[].obs;
  var pending = false.obs;

  // 🔥 NEW VARIABLES FOR DROPDOWN & FILTERING
  var selectedInvestmentId = ''.obs;
  var filteredInvestments = <InvestmentModel>[].obs;

  final String serverBase = "https://shriraminvestment-app.onrender.com";
  final String sampleReportLocalPath = "/mnt/data/reports/";

  @override
  void onInit() {
    fetchInvestments();
    super.onInit();
  }

  // 🔥 UPDATED BUT NON-BREAKING
  Future<void> fetchInvestments() async {
    try {
      isLoading.value = true;
      final token = await SharedPrefs.getToken();
      final userId = await SharedPrefs.getUserId();
      if (token == null || userId == null) {
        Get.snackbar("Error", "Please login");
        return;
      }

      print("🔄 Fetching investments for userId: $userId");
      print("token----$token");

      final res = await _repo.fetchUserInvestments(userId: userId, token: token);
      final status = res["status"] as int;
      final body = res["body"] as String;

      print("responsebody----$body");
      print("status----$status");

      if (status == 200 || status == 201) {
        final decoded = jsonDecode(body);

        if (decoded["success"] == true && decoded["data"] != null) {
          List arr = decoded["data"] as List;

          // Convert to model list and sort by latest
          final list = arr
              .map((e) => InvestmentModel.fromJson(e))
              .toList()
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

          // 🔥 Remove investments < 24 hours old (dropdown requirement)
          final now = DateTime.now();
          final filteredForDropdown = list.where((inv) {
            final diff = now.difference(inv.createdAt).inHours;
            return diff >= 24; // only show investments older than 24 hours
          }).toList();

          investments.assignAll(filteredForDropdown);

          _classifyInvestments(list); // keep original logic untouched

          // 🔥 Setup dropdown default selection
          if (filteredForDropdown.isNotEmpty) {
            selectedInvestmentId.value = filteredForDropdown.first.id ?? "";
            filterInvestmentList();
          } else {
            selectedInvestmentId.value = "";
            filteredInvestments.clear();
          }

        } else {
          investments.clear();
          activeInvestment.value = null;
          previousInvestments.clear();
        }
      } else {
        final decoded = jsonDecode(body);
        Get.snackbar("Error", decoded["message"] ?? "Failed to load investments");
      }
    } catch (e) {
      Get.snackbar("Error", "Network error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // 🔥 NEW: FILTER LIST FOR SELECTED INVESTMENT
  void filterInvestmentList() {
    if (selectedInvestmentId.value.isEmpty) {
      filteredInvestments.clear();
      return;
    }

    filteredInvestments.assignAll(
      investments.where((e) => e.id == selectedInvestmentId.value).toList(),
    );
  }

  

  // --------------------------------------
  // BELOW THIS — NOTHING MODIFIED BY ME
  // --------------------------------------

  void _classifyInvestments(List<InvestmentModel> sorted) {
    if (sorted.isEmpty) {
      activeInvestment.value = null;
      previousInvestments.clear();
      pending.value = false;
      return;
    }

    final latest = sorted[0];
    final now = DateTime.now();
    final diffHours = now.difference(latest.createdAt).inHours;

    if (diffHours >= 24) {
      activeInvestment.value = latest;
      previousInvestments.assignAll(sorted.skip(1).toList());
      pending.value = false;
    } else {
      pending.value = true;
      activeInvestment.value = sorted.length > 1 ? sorted[1] : null;
      previousInvestments.assignAll(sorted.skip(activeInvestment.value == null ? 1 : 2).toList());
    }
  }

  List<Map<String, dynamic>> monthlyBreakdownForInvestment(InvestmentModel inv) {
    final months = <Map<String, dynamic>>[];
    final now = DateTime.now();
    final totalMonths = inv.timeDuration * 12;
    final monthlyInterest = (inv.investedAmount * 0.12) / 12;

    for (int i = 0; i < totalMonths; i++) {
      final date = DateTime(now.year, now.month + i, 1);
      final monthName = "${date.month}/${date.year}";
      months.add({"label": monthName, "amount": monthlyInterest, "index": i});
    }
    return months;
  }

  Map<String, String> calculateGainsAndTotal(InvestmentModel inv) {
    final now = DateTime.now();

    int monthsPassed = (now.year - inv.createdAt.year) * 12 + (now.month - inv.createdAt.month);
    monthsPassed = monthsPassed.clamp(0, inv.timeDuration * 12);

    final monthlyGain = (inv.investedAmount * 0.12) / 12;
    final cumulativeGain = monthlyGain * monthsPassed;
    final currentValue = inv.investedAmount + cumulativeGain;

    return {
      "gains": cumulativeGain.toStringAsFixed(0),
      "total": currentValue.toStringAsFixed(0),
    };
  }

  Future<void> downloadInvestmentReport(String investmentId) async {
    try {
      final token = await SharedPrefs.getToken();
      if (token == null) {
        Get.snackbar("Error", "Please login");
        return;
      }
      isLoading.value = true;
      final file = await _repo.downloadInvestmentReportBlob(
          investmentId: investmentId, token: token);
      await OpenFile.open(file.path);
    } catch (e) {
      Get.snackbar("Error", "Download failed: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> downloadFromUrlAndOpen(String downloadUrl, String filename) async {
    try {
      isLoading.value = true;
      final file = await _repo.downloadFromUrl(downloadUrl, filename);
      await OpenFile.open(file.path);
    } catch (e) {
      Get.snackbar("Error", "Download failed: $e");
    } finally {
      isLoading.value = false;
    }
  }

  String fullImageUrl(String relative) {
    if (relative.isEmpty) return "";
    if (relative.startsWith("http")) return relative;
    return "$serverBase$relative";
  }

  InvestmentModel? get selectedInvestmentModel {
  if (selectedInvestmentId.value.isEmpty) return null;
  return investments.firstWhereOrNull((e) => e.id == selectedInvestmentId.value);
}

}
