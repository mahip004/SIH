import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../helpers/soil_helper.dart';
import '../providers/user_provider.dart';
import 'result_screen.dart';

class FeasibilityForm extends StatefulWidget {
  const FeasibilityForm({super.key});

  @override
  State<FeasibilityForm> createState() => _FeasibilityFormState();
}

class _FeasibilityFormState extends State<FeasibilityForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dwellersController = TextEditingController();
  final TextEditingController _roofAreaController = TextEditingController();
  final TextEditingController _spaceController = TextEditingController();

  String _selectedRoofType = "Flat";
  String _selectedRoofMaterial = "GI Sheet";
  String? _selectedState;

  bool _isLoading = true;

  final Map<String, double> _roofMaterials = {
    "GI Sheet": 0.9,
    "Asbestos": 0.8,
    "Tiled": 0.75,
    "Concrete": 0.7,
  };

  @override
  void initState() {
    super.initState();
    _loadSoil();
  }

  Future<void> _loadSoil() async {
    await SoilHelper.loadSoilData();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Feasibility Form"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Check Your Feasibility",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0A66C2),
                ),
              ),
              const SizedBox(height: 20),

              // --- State Dropdown ---
              DropdownButtonFormField<String>(
                value: _selectedState,
                decoration: const InputDecoration(labelText: "Select State"),
                items: SoilHelper.getAllStates().map((state) {
                  return DropdownMenuItem(value: state, child: Text(state));
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedState = value);
                },
                validator: (value) => value == null ? "Select a state" : null,
              ),
              const SizedBox(height: 16),

              // Number of Dwellers
              TextFormField(
                controller: _dwellersController,
                decoration: const InputDecoration(labelText: "Number of Dwellers"),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? "Enter number of dwellers" : null,
              ),
              const SizedBox(height: 16),

              // Roof Area
              TextFormField(
                controller: _roofAreaController,
                decoration: const InputDecoration(labelText: "Roof Area (m²)"),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? "Enter roof area" : null,
              ),
              const SizedBox(height: 16),

              // Roof Type Dropdown
              DropdownButtonFormField<String>(
                value: _selectedRoofType,
                decoration: const InputDecoration(labelText: "Roof Type"),
                items: ["Flat", "Sloping"].map((type) {
                  return DropdownMenuItem(value: type, child: Text(type));
                }).toList(),
                onChanged: (value) => setState(() => _selectedRoofType = value!),
              ),
              const SizedBox(height: 16),

              // Roof Material Dropdown
              DropdownButtonFormField<String>(
                value: _selectedRoofMaterial,
                decoration: const InputDecoration(labelText: "Roof Material"),
                items: _roofMaterials.keys.map((mat) {
                  final coeff = _roofMaterials[mat]!;
                  return DropdownMenuItem(value: mat, child: Text("$mat ($coeff)"));
                }).toList(),
                onChanged: (value) => setState(() => _selectedRoofMaterial = value!),
              ),
              const SizedBox(height: 16),

              // Open Space
              TextFormField(
                controller: _spaceController,
                decoration: const InputDecoration(labelText: "Available Open Space (m²)"),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? "Enter open space area" : null,
              ),
              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate() && _selectedState != null) {
                      Provider.of<UserProvider>(context, listen: false).setUserData(
                        numberOfDwellers: int.parse(_dwellersController.text),
                        roofArea: double.parse(_roofAreaController.text),
                        roofType: _selectedRoofType.toLowerCase(),
                        roofMaterial: _selectedRoofMaterial,
                        runoffCoefficient: _roofMaterials[_selectedRoofMaterial]!,
                        openSpace: double.parse(_spaceController.text),
                        state: _selectedState!, // ✅ pass selected state
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ResultScreen()),
                      );
                    }
                  },
                  child: const Text("Check Feasibility"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
