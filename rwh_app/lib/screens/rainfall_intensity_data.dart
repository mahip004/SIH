import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

Future<double?> getYearlyMaxRainfall(double latitude, double longitude) async {
  final url = Uri.parse(
      "https://power.larc.nasa.gov/api/temporal/hourly/point");

  final params = {
    'parameters': 'PRECTOTCORR',
    'start': '20240101',
    'end': '20241231',
    'latitude': latitude.toString(),
    'longitude': longitude.toString(),
    'community': 'AG',
    'format': 'JSON'
  };

  final uri = url.replace(queryParameters: params);

  try {
    final res = await http.get(uri);
    if (res.statusCode != 200) {
      print("Error fetching data: ${res.statusCode}");
      return null;
    }

    final data = jsonDecode(res.body);
    if (data == null ||
        data["properties"] == null ||
        data["properties"]["parameter"] == null ||
        data["properties"]["parameter"]["PRECTOTCORR"] == null) {
      print("Data not available in response");
      return null;
    }

    final Map<String, dynamic> hourlyData =
    Map<String, dynamic>.from(data["properties"]["parameter"]["PRECTOTCORR"]);

    // Track daily max rainfall
    Map<String, double> dailyMax = {};

    hourlyData.forEach((datetimeKey, value) {
      try {
        // Handle null or invalid values
        if (value == null) return;

        // Ensure datetime string is exactly 10 digits (YYYYMMDDHH)
        String cleanDatetime = datetimeKey.toString().padLeft(10, '0');

        // Validate the datetime string length
        if (cleanDatetime.length != 10) {
          print("Invalid datetime format: $datetimeKey");
          return;
        }

        // Parse YYYYMMDDHH format manually
        int year = int.parse(cleanDatetime.substring(0, 4));
        int month = int.parse(cleanDatetime.substring(4, 6));
        int day = int.parse(cleanDatetime.substring(6, 8));
        int hour = int.parse(cleanDatetime.substring(8, 10));

        // Validate date components
        if (month < 1 || month > 12 || day < 1 || day > 31 || hour < 0 || hour > 23) {
          print("Invalid date components: $cleanDatetime");
          return;
        }

        DateTime dt = DateTime(year, month, day, hour);
        String dayKey = DateFormat("yyyy-MM-dd").format(dt);

        double intensity = (value as num).toDouble();

        // Update daily maximum
        if (dailyMax.containsKey(dayKey)) {
          if (intensity > dailyMax[dayKey]!) {
            dailyMax[dayKey] = intensity;
          }
        } else {
          dailyMax[dayKey] = intensity;
        }
      } catch (e) {
        print("Skipping bad datetime key: $datetimeKey ($e)");
      }
    });

    if (dailyMax.isEmpty) {
      print("No daily max values found");
      return null;
    }

    // Return maximum intensity across the year
    double yearlyMax = dailyMax.values.reduce((a, b) => a > b ? a : b);

    print("Yearly maximum rainfall intensity: $yearlyMax mm/hr");
    return yearlyMax;
  } catch (e) {
    print("Exception while fetching data: $e");
    return null;
  }
}

// Example usage
void main() async {
  double? result = await getYearlyMaxRainfall(23.1815, 79.9864);
  if (result != null) {
    print("Result: $result mm/hr");
  } else {
    print("Failed to get rainfall data");
  }
}