# TODO for Monthly Report PDF Generation Feature

- [ ] Add method `PdfGenerator.generateMonthlyReport` to generate PDF for a monthly investment report.
- [ ] Add method `DocumentController.generateMonthlyReportPdf` to generate monthly report PDF locally using `PdfGenerator`.
- [ ] Add method `PortfolioInvestmentController.generateMonthlyReportPdf` to collect required monthly data and call DocumentController.
- [ ] Modify `portfolio_view.dart` `_showMonthActions` to call the new monthly report generation method for the "Download PDF" button on monthly items.

Testing:
- [ ] Test clicking a month from portfolio page monthly breakdown generates correct monthly PDF report.
- [ ] Ensure no API calls during monthly PDF generation.
- [ ] Verify no regressions on existing overall PDF report generation.
