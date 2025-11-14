import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
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

    // Load logo if needed
    final logo = await rootBundle.load('assets/images/shri_icon.png');
    final imageLogo = pw.MemoryImage(logo.buffer.asUint8List());

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [

              pw.Center(
                child: pw.Image(imageLogo, height: 70),
              ),

              pw.SizedBox(height: 10),

              pw.Center(
                child: pw.Text(
                  "SHRI RAM INVESTMENT",
                  style: pw.TextStyle(
                    fontSize: 22,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.red900,
                  ),
                ),
              ),

              pw.Center(
                child: pw.Text(
                  "Fixed Deposit (System Generated Certificate)",
                  style: const pw.TextStyle(
                    fontSize: 12,
                    color: PdfColors.grey600,
                  ),
                ),
              ),

              pw.SizedBox(height: 20),

              pw.Text(
                "Customer Details",
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.red900,
                ),
              ),

              pw.SizedBox(height: 6),

              _table([
                ["Customer Name", customerName],
                ["Email", email],
                ["Bank Name", bankName],
                ["Account Number", accountNumber],
                ["IFSC Code", ifsc],
              ]),

              pw.SizedBox(height: 20),

              pw.Text(
                "Investment Details",
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.red900,
                ),
              ),

              pw.SizedBox(height: 6),

              _table([
                ["Investment ID", investmentId],
                ["Invested Amount", investedAmount],
                ["Interest Rate", interestRate],
                ["Tenure", tenure],
                ["Date of Issue", issueDate],
                ["Maturity Date", maturityDate],
                ["Maturity Value", maturityValue],
              ]),

              pw.Spacer(),

              pw.Center(
                child: pw.Text(
                  "This is a system-generated document. It does not require a signature.",
                  style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey500),
                ),
              ),

              pw.Center(
                child: pw.Text(
                  "Keep this certificate safe for your financial records.",
                  style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey500),
                ),
              ),
            ],
          );
        },
      ),
    );

    final dir = await getTemporaryDirectory();
    final file = File("${dir.path}/fd_certificate.pdf");
    await file.writeAsBytes(await pdf.save());

    OpenFile.open(file.path);
  }

  static pw.Widget _table(List<List<String>> rows) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey600),
      columnWidths: {
        0: const pw.FlexColumnWidth(2),
        1: const pw.FlexColumnWidth(3),
      },
      children: rows
          .map(
            (row) => pw.TableRow(
              children: [
                _cell(row[0], bold: true),
                _cell(row[1]),
              ],
            ),
          )
          .toList(),
    );
  }

  static pw.Widget _cell(String text, {bool bold = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 12,
          fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }
}
