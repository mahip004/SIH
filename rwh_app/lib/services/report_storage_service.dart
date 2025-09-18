import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/report_model.dart';

class ReportStorageService {
  static const String _reportsKey = 'saved_reports';

  // Save a report to local storage
  static Future<bool> saveReport(ReportModel report) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final reports = await getReports();

      // Add new report to the beginning of the list
      reports.insert(0, report);

      // Convert reports to JSON
      final reportsJson = reports.map((r) => r.toMap()).toList();
      final reportsString = jsonEncode(reportsJson);

      // Save to SharedPreferences
      return await prefs.setString(_reportsKey, reportsString);
    } catch (e) {
      print('Error saving report: $e');
      return false;
    }
  }

  // Get all saved reports
  static Future<List<ReportModel>> getReports() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final reportsString = prefs.getString(_reportsKey);

      if (reportsString == null || reportsString.isEmpty) {
        return [];
      }

      final List<dynamic> reportsJson = jsonDecode(reportsString);
      return reportsJson.map((json) => ReportModel.fromMap(json)).toList();
    } catch (e) {
      print('Error loading reports: $e');
      return [];
    }
  }

  // Delete a specific report
  static Future<bool> deleteReport(String reportId) async {
    try {
      final reports = await getReports();
      reports.removeWhere((report) => report.id == reportId);

      final prefs = await SharedPreferences.getInstance();
      final reportsJson = reports.map((r) => r.toMap()).toList();
      final reportsString = jsonEncode(reportsJson);

      return await prefs.setString(_reportsKey, reportsString);
    } catch (e) {
      print('Error deleting report: $e');
      return false;
    }
  }

  // Clear all reports
  static Future<bool> clearAllReports() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_reportsKey);
    } catch (e) {
      print('Error clearing reports: $e');
      return false;
    }
  }

  // Get a specific report by ID
  static Future<ReportModel?> getReportById(String reportId) async {
    try {
      final reports = await getReports();
      return reports.firstWhere(
            (report) => report.id == reportId,
        orElse: () => throw Exception('Report not found'),
      );
    } catch (e) {
      print('Error getting report by ID: $e');
      return null;
    }
  }
}
