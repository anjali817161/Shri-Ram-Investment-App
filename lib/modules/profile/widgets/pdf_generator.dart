import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class PdfGenerator {
  static Future<void> generateFDcertificate({
    required String customerName,
    required String email,
    required String bankName,
    required String accountNumber,
    required String ifsc,
    required String investmentId,
    required String investedAmount,
    required String interestRate,
    required String tenure,
    required String issueDate,
    required String maturityDate,
    required String maturityValue,
  }) async {
    final pdf = pw.Document();

    // LOAD ASSETS
    final logoData = await rootBundle.load('assets/images/shri_icon.png');
    final logo = pw.MemoryImage(logoData.buffer.asUint8List());

    final hindiFontData = await rootBundle.load("assets/fonts/NotoSansDevanagari-Regular.ttf");
    final hindiFont = pw.Font.ttf(hindiFontData);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(25),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [

              // LOGO + HEADER
              pw.Center(
                child: pw.Image(logo, height: 65),
              ),
              pw.SizedBox(height: 8),

              pw.Center(
                child: pw.Text(
                  "SHRI RAM INVESTMENT",
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 20,
                    color: PdfColors.red,
                  ),
                ),
              ),

              pw.Center(
                child: pw.Text(
                  "e-Fixed Deposit Account Receipt",
                  style: pw.TextStyle(fontSize: 12),
                ),
              ),

              pw.SizedBox(height: 18),

              // ACCOUNT + CUSTOMER ROW
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey700),
                children: [
                  _row("Account No", accountNumber),
                  _row("Customer Name", customerName),
                ],
              ),

              pw.SizedBox(height: 12),

              pw.Text(
                "Deposit Amount: INR $investedAmount for a period of $tenure days at the rate of $interestRate% per annum.",
                style: pw.TextStyle(fontSize: 11),
              ),

              pw.SizedBox(height: 15),

              // DATE / MATURITY / SCHEME TABLE
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey600),
                children: [
                  _dualRow("Date of Issue", issueDate,
                      "Date of Maturity", maturityDate),
                  _dualRow("Maturity Value", maturityValue,
                      "Deposit Scheme", "FD"),
                  _dualRow("Maturity Instruction", "Auto Renew",
                      "Nominee", "N/A"),
                ],
              ),

              pw.SizedBox(height: 15),

              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey600),
                children: [
                  _row("Debit Account Number", accountNumber),
                  _row("Repayment Account Number", accountNumber),
                ],
              ),

              pw.SizedBox(height: 25),

              pw.Text(
                "Important Instructions:",
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 13),
              ),

              pw.SizedBox(height: 5),

              pw.Bullet(text: "This is not transferable."),
              pw.Bullet(
                text:
                    "The confirmation of deposit is issued based on customer mandate. In case of discrepancy contact branch within 7 days.",
              ),
              pw.Bullet(
                text: "Maturity value & withdrawal are subject to TDS as per Income Tax Act.",
              ),
              pw.Bullet(
                text:
                    "Deposit will be auto renewed as per scheme applicable on maturity date.",
              ),
              pw.Bullet(
                text:
                    "Premature withdrawal is subject to penalty as per bank guidelines.",
              ),

              pw.SizedBox(height: 25),

              pw.Center(
                child: pw.Text(
                  "This is a computer-generated receipt and does not require a signature.",
                  style: pw.TextStyle(fontSize: 10),
                ),
              ),

              pw.SizedBox(height: 20),

              /// *** HINDI LINE (WITH FONT) ***
              pw.Center(
                child: pw.Text(
                  "श्री राम विकास पत्र",
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                    font: hindiFont,
                    color: PdfColors.red800,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    // SAVE PDF
    final dir = await getTemporaryDirectory();
    final file = File("${dir.path}/fd_certificate_new.pdf");
    await file.writeAsBytes(await pdf.save());
    await OpenFile.open(file.path);
  }

  // ---------- REUSABLE TABLE ROWS ----------
  static pw.TableRow _row(String k, String v) {
    return pw.TableRow(
      children: [
        _cell(k, bold: true),
        _cell(v),
      ],
    );
  }

  static pw.TableRow _dualRow(
    String k1,
    String v1,
    String k2,
    String v2,
  ) {
    return pw.TableRow(
      children: [
        _cell(k1, bold: true),
        _cell(v1),
        _cell(k2, bold: true),
        _cell(v2),
      ],
    );
  }

  static pw.Widget _cell(String text, {bool bold = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 11,
          fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }
}
