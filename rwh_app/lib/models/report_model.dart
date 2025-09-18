class ReportModel {
  final String id;
  final DateTime date;
  final String state;
  final String soilType;
  final int numberOfDwellers;
  final double roofArea;
  final String roofType;
  final String roofMaterial;
  final double runoffCoefficient;
  final double openSpace;
  final double waterAvailable;
  final String suggestedStructure;
  final double tankCapacityLitres;
  final String costEstimation;
  final Map<String, double>? storageDimensions;
  final Map<String, dynamic>? rechargeStructure;
  final String? pipeInfo;

  ReportModel({
    required this.id,
    required this.date,
    required this.state,
    required this.soilType,
    required this.numberOfDwellers,
    required this.roofArea,
    required this.roofType,
    required this.roofMaterial,
    required this.runoffCoefficient,
    required this.openSpace,
    required this.waterAvailable,
    required this.suggestedStructure,
    required this.tankCapacityLitres,
    required this.costEstimation,
    this.storageDimensions,
    this.rechargeStructure,
    this.pipeInfo,
  });

  // Convert to Map for JSON serialization
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'state': state,
      'soilType': soilType,
      'numberOfDwellers': numberOfDwellers,
      'roofArea': roofArea,
      'roofType': roofType,
      'roofMaterial': roofMaterial,
      'runoffCoefficient': runoffCoefficient,
      'openSpace': openSpace,
      'waterAvailable': waterAvailable,
      'suggestedStructure': suggestedStructure,
      'tankCapacityLitres': tankCapacityLitres,
      'costEstimation': costEstimation,
      'storageDimensions': storageDimensions,
      'rechargeStructure': rechargeStructure,
      'pipeInfo': pipeInfo,
    };
  }

  // Create from Map for JSON deserialization
  factory ReportModel.fromMap(Map<String, dynamic> map) {
    return ReportModel(
      id: map['id'] ?? '',
      date: DateTime.parse(map['date'] ?? DateTime.now().toIso8601String()),
      state: map['state'] ?? '',
      soilType: map['soilType'] ?? '',
      numberOfDwellers: map['numberOfDwellers'] ?? 0,
      roofArea: map['roofArea']?.toDouble() ?? 0.0,
      roofType: map['roofType'] ?? '',
      roofMaterial: map['roofMaterial'] ?? '',
      runoffCoefficient: map['runoffCoefficient']?.toDouble() ?? 0.0,
      openSpace: map['openSpace']?.toDouble() ?? 0.0,
      waterAvailable: map['waterAvailable']?.toDouble() ?? 0.0,
      suggestedStructure: map['suggestedStructure'] ?? '',
      tankCapacityLitres: map['tankCapacityLitres']?.toDouble() ?? 0.0,
      costEstimation: map['costEstimation'] ?? '',
      storageDimensions: map['storageDimensions'] != null
          ? Map<String, double>.from(map['storageDimensions'])
          : null,
      rechargeStructure: map['rechargeStructure'],
      pipeInfo: map['pipeInfo'],
    );
  }

  // Get formatted date string
  String get formattedDate {
    return '${date.day}/${date.month}/${date.year}';
  }

  // Get short structure name for display
  String get shortStructure {
    if (suggestedStructure.contains('Recharge Pit')) return 'Recharge Pit';
    if (suggestedStructure.contains('Recharge Trench')) return 'Recharge Trench';
    if (suggestedStructure.contains('Recharge Shaft')) return 'Recharge Shaft';
    return suggestedStructure;
  }
}
