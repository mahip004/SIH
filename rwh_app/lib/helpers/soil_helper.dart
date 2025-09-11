import 'dart:convert';
import 'package:flutter/services.dart';

class SoilHelper {
  static Map<String, String>? _soilData;

  // Load JSON once
  static Future<void> loadSoilData() async {
    if (_soilData != null) return; // already loaded
    final String jsonString = await rootBundle.loadString('assets/soil_data.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    _soilData = jsonMap.map((key, value) => MapEntry(key, value.toString()));
  }

  // Get soil type for a state
  static String getSoilType(String state) {
    if (_soilData == null) throw Exception("Soil data not loaded. Call loadSoilData() first.");
    return _soilData![state] ?? "Unknown";
  }

  // Get all states
  static List<String> getAllStates() {
    if (_soilData == null) throw Exception("Soil data not loaded. Call loadSoilData() first.");
    return _soilData!.keys.toList();
  }
}
