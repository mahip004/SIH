import 'dart:math';

class RWHStructure {
  final double roofArea; // in m²
  final int numberOfDwellers;
  final int dryDays; // length of dry season
  final double consumptionPerPerson; // L/day per person
  final bool limitedSpace; // if true, recommend underground/shaft

  RWHStructure({
    required this.roofArea,
    required this.numberOfDwellers,
    required this.dryDays,
    this.consumptionPerPerson = 20,
    this.limitedSpace = false,
  });

  // Calculate storage volume in liters
  double get storageVolume => dryDays * numberOfDwellers * consumptionPerPerson;

  // Decide storage type
  String get storageType => limitedSpace ? "Underground Tank" : "Above-Ground Tank";

  // Approx. tank dimensions (cylinder)
  Map<String, double> get storageDimensions {
    double height = 2.0; // meters
    double diameter = sqrt(storageVolume / (3.1416 * height)); // ✅ fixed
    return {"height": height, "diameter": diameter};
  }

  // Decide recharge structure based on roof area
  Map<String, String> get rechargeStructure {
    String type;
    String dimensions;

    if (roofArea <= 100) {
      type = "Recharge Pit";
      dimensions = "2m × 2m × 3m (Boulders, Gravel, Sand)";
    } else if (roofArea <= 300) {
      type = "Recharge Trench";
      dimensions = "1m × 1.5m × 15m (Boulders, Gravel, Sand)";
    } else {
      type = "Recharge Shaft";
      dimensions = "1m × 5m (Deep Aquifer)";
    }

    return {"type": type, "dimensions": dimensions};
  }
}
