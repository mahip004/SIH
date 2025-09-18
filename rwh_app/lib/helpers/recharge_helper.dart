import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

class RechargeConfig {
  final String id;
  final String label;
  final double? maxRoofArea;
  final String dimensions;
  final String image;

  RechargeConfig({
    required this.id,
    required this.label,
    required this.maxRoofArea,
    required this.dimensions,
    required this.image,
  });

  factory RechargeConfig.fromJson(Map<String, dynamic> json) {
    return RechargeConfig(
      id: json['id'] as String,
      label: json['label'] as String,
      maxRoofArea: json['maxRoofArea'] == null
          ? null
          : (json['maxRoofArea'] as num).toDouble(),
      dimensions: json['dimensions'] as String,
      image: json['image'] as String,
    );
  }
}

class RechargeHelper {
  static List<RechargeConfig>? _cache;

  static Future<List<RechargeConfig>> _loadConfigs() async {
    if (_cache != null) return _cache!;
    final jsonStr = await rootBundle.loadString('assets/recharge_structures.json');
    final data = json.decode(jsonStr) as List<dynamic>;
    _cache = data.map((e) => RechargeConfig.fromJson(e as Map<String, dynamic>)).toList();
    return _cache!;
  }

  static Future<RechargeConfig?> selectByRoofArea(double roofArea) async {
    final configs = await _loadConfigs();
    // Find the first config whose maxRoofArea is >= roofArea
    for (final cfg in configs) {
      if (cfg.maxRoofArea != null && roofArea <= cfg.maxRoofArea!) {
        return cfg;
      }
    }
    // Fallback: last config (where maxRoofArea is null or largest bucket)
    return configs.isNotEmpty ? configs.last : null;
  }
}


