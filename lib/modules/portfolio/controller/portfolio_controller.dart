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

  // Replace with your CDN base if image paths are relative on backend
  final String serverBase = "https://shriraminvestment-app.onrender.com";

  // For developer instruction: local report path placeholder (replace if needed)
  // NOTE: replace this with actual downloadUrl if your server provides it
  final String sampleReportLocalPath = "/mnt/data/reports/";

  @override
  void onInit() {
    fetchInvestments();
    super.onInit();
  }

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
          final list = arr.map((e) => InvestmentModel.fromJson(e)).toList()
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
          investments.assignAll(list);
          _classifyInvestments(list);
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

  void _classifyInvestments(List<InvestmentModel> sorted) {
    if (sorted.isEmpty) {
      activeInvestment.value = null;
      previousInvestments.clear();
      pending.value = false;
      return;
    }

    // Latest item:
    final latest = sorted[0];
    final now = DateTime.now();
    final diffHours = now.difference(latest.createdAt).inHours;

    if (diffHours >= 24) {
      // latest is active
      activeInvestment.value = latest;
      previousInvestments.assignAll(sorted.skip(1).toList());
      pending.value = false;
    } else {
      // latest pending
      pending.value = true;
      activeInvestment.value = sorted.length > 1 ? sorted[1] : null;
      previousInvestments.assignAll(sorted.skip(activeInvestment.value == null ? 1 : 2).toList());
    }
  }

  /// monthly breakdown for an investment (returns list of month labels + monthly interest amount)
  List<Map<String, dynamic>> monthlyBreakdownForInvestment(InvestmentModel inv) {
    final months = <Map<String, dynamic>>[];
    final now = DateTime.now();
    final totalMonths = inv.timeDuration * 12;
    final monthlyInterest = (inv.investedAmount * 0.12) / 12; // 12% yearly as in website

    for (int i = 0; i < totalMonths; i++) {
      final date = DateTime(now.year, now.month + i, 1);
      final monthName = "${date.month}/${date.year}";
      months.add({
        "label": monthName,
        "amount": monthlyInterest,
        "index": i,
      });
    }
    return months;
  }

  /// calculated gains (example: simple annual 12% for website parity)
  Map<String, String> calculateGainsAndTotal(InvestmentModel inv) {
    final gains = inv.investedAmount * 0.12 * inv.timeDuration;
    final total = inv.investedAmount + gains;
    return {
      "gains": gains.toStringAsFixed(0),
      "total": total.toStringAsFixed(0),
    };
  }

  /// Download report for a given investmentId and open it
  Future<void> downloadInvestmentReport(String investmentId) async {
    try {
      final token = await SharedPrefs.getToken();
      if (token == null) {
        Get.snackbar("Error", "Please login");
        return;
      }
      isLoading.value = true;
      final file = await _repo.downloadInvestmentReportBlob(investmentId: investmentId, token: token);
      await OpenFile.open(file.path);
    } catch (e) {
      Get.snackbar("Error", "Download failed: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// If server returns downloadUrl JSON instead of direct PDF blob, use this
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

  /// helper to get full image url for UI
  String fullImageUrl(String relative) {
    if (relative.isEmpty) return "";
    if (relative.startsWith("http")) return relative;
    return "$serverBase$relative";
  }
}
