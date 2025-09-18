import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:intl/intl.dart';
import '../models/report_model.dart';

class PdfGenerator {
  static Future<Uint8List> generateReportPdf(ReportModel report) async {
    final pdf = pw.Document();
    final formatter = NumberFormat.decimalPattern();

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Text(
              "Feasibility Report",
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
          ),

          pw.Text("Generated on: ${report.formattedDate}",
              style: const pw.TextStyle(fontSize: 12)),

          pw.SizedBox(height: 20),

          _buildSection("Property Details", [
            "State: ${report.state}",
            "Soil Type: ${report.soilType}",
            "Number of Dwellers: ${report.numberOfDwellers}",
            "Roof Area: ${report.roofArea.toStringAsFixed(1)} m²",
            "Roof Type: ${report.roofType}",
            "Roof Material: ${report.roofMaterial}",
            "Open Space: ${report.openSpace.toStringAsFixed(1)} m²",
          ]),

          _buildSection("Storage Tank", [
            "Volume: ${report.tankCapacityLitres.toStringAsFixed(0)} L",
            "Dimensions: ${report.storageDimensions?['diameter']?.toStringAsFixed(1) ?? 'N/A'} m dia × "
                "${report.storageDimensions?['height']?.toStringAsFixed(1) ?? 'N/A'} m height",
            report.pipeInfo ?? "No pipe information available",
          ]),

          _buildSection("Recharge Structure", [
            "Suggested: ${report.suggestedStructure}",
            "Dimensions: ${report.rechargeStructure?['dimensions'] ?? 'N/A'}",
            "Estimated Runoff Available: ${report.waterAvailable.toStringAsFixed(0)} L/year",
          ]),

          _buildSection("Runoff Generation Capacity", [
            "${report.waterAvailable.toStringAsFixed(0)} litres/year (Coefficient: ${report.runoffCoefficient})",
          ]),

          _buildSection("Cost Estimation & Benefit", [
            _sanitizeCost(report.costEstimation, formatter),
            "Benefit: Can store ~2.4 KL of water",
          ]),
        ],
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildSection(String title, List<String> items) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(title,
            style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blue700)),
        pw.SizedBox(height: 8),
        ...items.map((i) => pw.Text(i, style: const pw.TextStyle(fontSize: 12))),
        pw.SizedBox(height: 16),
      ],
    );
  }

  /// Cleanly handle Rs formatting (always plain text, no Unicode rupee sign)
  static String _sanitizeCost(dynamic costEstimation, NumberFormat formatter) {
    if (costEstimation == null) return "Estimated cost: N/A";

    if (costEstimation is num) {
      return "Estimated cost: Rs ${formatter.format(costEstimation)}";
    }

    if (costEstimation is String) {
      // Remove existing rupee symbols and "Estimated cost:"
      String cleaned = costEstimation
          .replaceAll("₹", "Rs ")
          .replaceAll("Estimated cost:", "")
          .replaceAll(RegExp(r"[-–—]"), " to ") // replace all dash types with "to"
          .trim();

      // Only prepend "Rs" if it doesn't already start with "Rs"
      if (!cleaned.startsWith("Rs")) {
        cleaned = "Rs $cleaned";
      }

      return "Estimated cost: $cleaned";
    }

    return "Estimated cost: N/A";
  }
}
