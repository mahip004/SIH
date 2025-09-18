import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'structure.dart';
import '../providers/user_provider.dart';
import 'water_availability_data.dart';
import 'rainfall_data.dart';
import 'rainfall_intensity_data.dart';
import 'pipe_diameter_data.dart';
import '../helpers/location_helper.dart';
import '../helpers/recharge_helper.dart';
import '../helpers/pdf_generator.dart';
import '../models/report_model.dart';
import '../services/report_storage_service.dart';
import 'package:printing/printing.dart';


class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  double waterAvailable = 0.0;
  String suggestedStructure = "Calculating...";
  double tankCapacityLitres = 0.0;
  String costEstimation = "";
  int scarcityDays = 120;
  double? rainfallIntensity;
  PipeData? selectedPipe;

  Map<String, double>? storageDim;
  Map<String, dynamic>? recharge;
  late RWHStructure rwh;
  bool isFetchingPipe = false;
  bool isSavingReport = false;
  RechargeConfig? selectedRecharge;
  String? structureImagePath;

  @override
  void initState() {
    super.initState();
    calculateWaterAvailability();
  }

  double _nearestRainfall(double rainfallValue) {
    double nearestValue = WaterAvailability.rainfall.reduce(
      (a, b) => (a - rainfallValue).abs() < (b - rainfallValue).abs() ? a : b,
    );
    return nearestValue;
  }

  Future<void> _ensureLocationAvailable() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.latitude != null && userProvider.longitude != null) return;

    final saved = await LocationHelper.getSavedLocation();
    if (saved != null) {
      userProvider.setLocation(saved.latitude, saved.longitude);
      return;
    }

    final fetched = await LocationHelper.askLocationPermissionAndFetch();
    if (fetched != null) {
      userProvider.setLocation(fetched.latitude, fetched.longitude);
    }
  }

  Future<void> calculateWaterAvailability() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await _ensureLocationAvailable();

    final roofArea = userProvider.roofArea;
    final roofType = userProvider.roofType.toLowerCase();
    final numberOfDwellers = userProvider.numberOfDwellers;
    final runoffCoefficient = userProvider.runoffCoefficient;

    tankCapacityLitres = numberOfDwellers * scarcityDays * 10;
    final state = userProvider.state;
    final rawRainfall = (stateRainfall[state] ?? 800).toDouble();
    final rainfall = _nearestRainfall(rawRainfall);

    rwh = RWHStructure(
      roofArea: roofArea,
      numberOfDwellers: numberOfDwellers,
      dryDays: scarcityDays,
      limitedSpace: userProvider.limitedSpace,
    );

    storageDim = rwh.storageDimensions;

    selectedRecharge = await RechargeHelper.selectByRoofArea(roofArea);
    if (selectedRecharge != null) {
      recharge = {
        'type': selectedRecharge!.label,
        'dimensions': selectedRecharge!.dimensions,
        'image': selectedRecharge!.image,
      };
      structureImagePath = selectedRecharge!.image;
    } else {
      recharge = rwh.rechargeStructure;
      structureImagePath = 'assets/recharge_sketch.png';
    }

    if (roofType == "flat") {
      final value = WaterAvailability.getFlatAvailability(roofArea, rainfall);
      if (value != null) waterAvailable = value * 1000 * runoffCoefficient;
    } else if (roofType == "sloping") {
      final value = WaterAvailability.getSlopingAvailability(roofArea, rainfall);
      if (value != null) waterAvailable = value * 1000 * runoffCoefficient;
    }

    String suffixLabel;
    if (waterAvailable >= tankCapacityLitres) {
      suffixLabel = "enough collection";
    } else if (waterAvailable >= tankCapacityLitres / 2) {
      suffixLabel = "moderate collection";
    } else {
      suffixLabel = "low collection";
    }

    final baseLabel = selectedRecharge?.label ?? (recharge?['type'] ?? 'Recharge Structure');
    suggestedStructure = "$baseLabel ($suffixLabel)";

    // ✅ Optimized Cost Estimation
    final minCostPerLitre = 0.8; // ₹ per litre
    final maxCostPerLitre = 1.2; // ₹ per litre
    final minCost = tankCapacityLitres * minCostPerLitre;
    final maxCost = tankCapacityLitres * maxCostPerLitre;

    costEstimation =
        "Estimated Cost: ₹${minCost.toStringAsFixed(0)} – ₹${maxCost.toStringAsFixed(0)}\n"
        "Benefit: Can store ~${(tankCapacityLitres / 1000).toStringAsFixed(1)} KL of water";

    if (userProvider.latitude != null && userProvider.longitude != null) {
      try {
        isFetchingPipe = true;
        setState(() {});

        rainfallIntensity = await getYearlyMaxRainfall(
          userProvider.latitude!,
          userProvider.longitude!,
        );

        if (rainfallIntensity != null) {
          final pipeSelector = PipeSelector();
          selectedPipe = pipeSelector.findClosest(
            roofArea,
            rainfallIntensity!.round(),
          );
        }
      } catch (e) {
        debugPrint("Error fetching rainfall or selecting pipe: $e");
      } finally {
        isFetchingPipe = false;
        setState(() {});
      }
    }

    setState(() {});
  }

  Future<void> _saveReport() async {
    if (isSavingReport) return;
    setState(() => isSavingReport = true);

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final report = ReportModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        date: DateTime.now(),
        state: userProvider.state,
        soilType: userProvider.soilType,
        numberOfDwellers: userProvider.numberOfDwellers,
        roofArea: userProvider.roofArea,
        roofType: userProvider.roofType,
        roofMaterial: userProvider.roofMaterial,
        runoffCoefficient: userProvider.runoffCoefficient,
        openSpace: userProvider.openSpace,
        waterAvailable: waterAvailable,
        suggestedStructure: suggestedStructure,
        tankCapacityLitres: tankCapacityLitres,
        costEstimation: costEstimation,
        storageDimensions: storageDim,
        rechargeStructure: recharge,
        pipeInfo: selectedPipe != null
            ? "Pipe: ${selectedPipe!.diameter} mm dia × ${selectedPipe!.width} mm width"
            : "No suitable pipe found",
      );

      final success = await ReportStorageService.saveReport(report);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success ? 'Report saved successfully!' : 'Failed to save report.'),
            backgroundColor: success ? Colors.green[600] : Colors.red[600],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error saving report. Please try again.'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => isSavingReport = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      body: suggestedStructure == "Calculating..."
          ? _buildLoading()
          : _buildResultContent(userProvider),
    );
  }

  Widget _buildLoading() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [const Color(0xFF1A73E8).withOpacity(0.05), Colors.white],
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Color(0xFF1A73E8)),
            SizedBox(height: 16),
            Text(
              "Calculating your results...",
              style: TextStyle(
                color: Color(0xFF1A73E8),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultContent(UserProvider userProvider) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [const Color(0xFF1A73E8).withOpacity(0.05), Colors.white],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 24),
                    _buildInsightCard(
                      icon: FontAwesomeIcons.database,
                      title: "Storage Tank",
                      value:
                          "${rwh.storageType}\nVolume: ${rwh.storageVolume.toStringAsFixed(0)} L\nDimensions: ${storageDim?['diameter']?.toStringAsFixed(1) ?? 0} m dia × ${storageDim?['height']?.toStringAsFixed(1) ?? 0} m height\n${isFetchingPipe ? "Loading pipe dimensions..." : selectedPipe != null ? "Pipe: ${selectedPipe!.diameter} mm dia × ${selectedPipe!.width} mm width" : "No suitable pipe found"}",
                      gradientColors: const [Color(0xFF1A73E8), Color(0xFF2A93D5)],
                    ),
                    _buildInsightCard(
                      icon: FontAwesomeIcons.seedling,
                      title: "Recharge Structure",
                      value:
                          "${recharge?['type'] ?? 'N/A'}\nRecommended Dimensions: ${recharge?['dimensions'] ?? 'N/A'}\nEstimated Runoff Available: ${waterAvailable.toStringAsFixed(0)} L/year",
                      gradientColors: const [Color(0xFF26A69A), Color(0xFF4DB6AC)],
                      imagePath: structureImagePath,
                    ),
                    _buildInsightCard(
                      icon: FontAwesomeIcons.water,
                      title: "Runoff Generation Capacity",
                      value: "${waterAvailable.toStringAsFixed(0)} litres/year (with runoff coefficient)",
                      gradientColors: const [Color(0xFF5C6BC0), Color(0xFF7986CB)],
                    ),
                    _buildInsightCard(
                      icon: FontAwesomeIcons.database,
                      title: "Required Tank Capacity",
                      value:
                          "${tankCapacityLitres.toStringAsFixed(0)} litres (For ${userProvider.numberOfDwellers} persons, $scarcityDays days)",
                      gradientColors: const [Color(0xFF1A73E8), Color(0xFF2A93D5)],
                    ),
                    _buildInsightCard(
                      icon: FontAwesomeIcons.coins,
                      title: "Cost Estimation & Benefit",
                      value: costEstimation,
                      gradientColors: const [Color(0xFFFF9800), Color(0xFFFFB74D)],
                    ),
                    _buildInsightCard(
                      icon: FontAwesomeIcons.seedling,
                      title: "Soil Type",
                      value: userProvider.soilType,
                      gradientColors: const [Color(0xFF26A69A), Color(0xFF4DB6AC)],
                    ),
                    const SizedBox(height: 30),
                    _buildActionButtons(userProvider),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1A73E8), Color(0xFF2A93D5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 16),
          const Text(
            "Feasibility Report",
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.save_alt, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Rainwater Harvesting Insights",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A73E8),
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Based on your location and property details",
                style: TextStyle(fontSize: 14, color: Colors.grey[700], height: 1.3),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF1A73E8).withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.insights, color: Color(0xFF1A73E8), size: 28),
        ),
      ],
    );
  }

  Widget _buildActionButtons(UserProvider userProvider) {
  return Column(
    children: [
      Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text("Back"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF1A73E8),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: const Color(0xFF1A73E8).withOpacity(0.3), width: 1),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: isSavingReport ? null : _saveReport,
              icon: isSavingReport
                  ? const SizedBox(
                      width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.save),
              label: Text(isSavingReport ? "Saving..." : "Save Report"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A73E8),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),
      // Download PDF button
      SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () async {
            final report = ReportModel(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              date: DateTime.now(),
              state: userProvider.state,
              soilType: userProvider.soilType,
              numberOfDwellers: userProvider.numberOfDwellers,
              roofArea: userProvider.roofArea,
              roofType: userProvider.roofType,
              roofMaterial: userProvider.roofMaterial,
              runoffCoefficient: userProvider.runoffCoefficient,
              openSpace: userProvider.openSpace,
              waterAvailable: waterAvailable,
              suggestedStructure: suggestedStructure,
              tankCapacityLitres: tankCapacityLitres,
              costEstimation: costEstimation,
              storageDimensions: storageDim,
              rechargeStructure: recharge,
              pipeInfo: selectedPipe != null
                  ? "Pipe: ${selectedPipe!.diameter} mm dia × ${selectedPipe!.width} mm width"
                  : "No suitable pipe found",
            );

            try {
              final pdfData = await PdfGenerator.generateReportPdf(report);
              await Printing.layoutPdf(onLayout: (format) => pdfData);
            } catch (e) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error generating PDF: $e'),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            }
          },
          icon: const Icon(Icons.download),
          label: const Text("Download PDF"),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF26A69A),
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
      ),
    ],
  );
}


  Widget _buildInsightCard({
    required IconData icon,
    required String title,
    required String value,
    String? imagePath,
    required List<Color> gradientColors,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: gradientColors[0].withOpacity(0.15), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              if (imagePath != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => FullScreenImage(imagePath: imagePath)),
                );
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: gradientColors, begin: Alignment.topLeft, end: Alignment.bottomRight),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(icon, size: 24, color: Colors.white),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(title,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D3748))),
                            const SizedBox(height: 8),
                            Text(value, style: TextStyle(fontSize: 15, color: Colors.grey[800], height: 1.5)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (imagePath != null) ...[
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: ImageWidget(imagePath: imagePath),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Reusable Image Widget
class ImageWidget extends StatelessWidget {
  final String imagePath;
  const ImageWidget({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return imagePath.startsWith('http')
        ? Image.network(imagePath, fit: BoxFit.contain, width: double.infinity, height: 180)
        : Image.asset(imagePath, fit: BoxFit.contain, width: double.infinity, height: 180);
  }
}

// Full screen modal for image
class FullScreenImage extends StatelessWidget {
  final String imagePath;
  const FullScreenImage({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
      ),
      body: Center(
        child: imagePath.startsWith('http') ? Image.network(imagePath, fit: BoxFit.contain) : Image.asset(imagePath, fit: BoxFit.contain),
      ),
    );
  }
}
