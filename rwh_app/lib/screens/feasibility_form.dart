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
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFF1A73E8).withOpacity(0.05),
                Colors.white,
              ],
            ),
          ),
          child: const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF1A73E8),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF1A73E8).withOpacity(0.05),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1A73E8), Color(0xFF2A93D5)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      "Feasibility Form",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Form Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Check Your Feasibility",
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1A73E8),
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    "Fill in the details to evaluate your rainwater harvesting potential",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[700],
                                      height: 1.3,
                                    ),
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
                              child: const Icon(
                                Icons.calculate_outlined,
                                color: Color(0xFF1A73E8),
                                size: 28,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // --- State Dropdown ---
                        _buildDropdownField(
                          label: "Select State",
                          hint: "Choose your state",
                          value: _selectedState,
                          items: SoilHelper.getAllStates().map((state) {
                            return DropdownMenuItem(value: state, child: Text(state));
                          }).toList(),
                          onChanged: (value) {
                            setState(() => _selectedState = value);
                          },
                          validator: (value) => value == null ? "Select a state" : null,
                          icon: Icons.location_on_outlined,
                        ),
                        const SizedBox(height: 16),

                        // Number of Dwellers
                        _buildTextField(
                          controller: _dwellersController,
                          label: "Number of Dwellers",
                          hint: "Enter the number of people",
                          keyboardType: TextInputType.number,
                          validator: (value) => value!.isEmpty ? "Enter number of dwellers" : null,
                          icon: Icons.people_outline,
                        ),
                        const SizedBox(height: 16),

                        // Roof Area
                        _buildTextField(
                          controller: _roofAreaController,
                          label: "Roof Area (mﾲ)",
                          hint: "Enter your roof area",
                          keyboardType: TextInputType.number,
                          validator: (value) => value!.isEmpty ? "Enter roof area" : null,
                          icon: Icons.home_outlined,
                        ),
                        const SizedBox(height: 16),

                        // Roof Type Dropdown
                        _buildDropdownField(
                          label: "Roof Type",
                          hint: "Select roof type",
                          value: _selectedRoofType,
                          items: ["Flat", "Sloping"].map((type) {
                            return DropdownMenuItem(value: type, child: Text(type));
                          }).toList(),
                          onChanged: (value) => setState(() => _selectedRoofType = value!),
                          icon: Icons.roofing_outlined,
                        ),
                        const SizedBox(height: 16),

                        // Roof Material Dropdown
                        _buildDropdownField(
                          label: "Roof Material",
                          hint: "Select roof material",
                          value: _selectedRoofMaterial,
                          items: _roofMaterials.keys.map((mat) {
                            final coeff = _roofMaterials[mat]!;
                            return DropdownMenuItem(
                              value: mat,
                              child: Text("$mat (${coeff.toStringAsFixed(2)})"),
                            );
                          }).toList(),
                          onChanged: (value) => setState(() => _selectedRoofMaterial = value!),
                          icon: Icons.layers_outlined,
                        ),
                        const SizedBox(height: 16),

                        // Open Space
                        _buildTextField(
                          controller: _spaceController,
                          label: "Available Open Space (mﾲ)",
                          hint: "Enter available open space",
                          keyboardType: TextInputType.number,
                          validator: (value) => value!.isEmpty ? "Enter open space area" : null,
                          icon: Icons.landscape_outlined,
                        ),
                        const SizedBox(height: 32),

                        // Submit Button
                        Container(
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF1A73E8).withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
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
                                  state: _selectedState!,
                                );

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const ResultScreen()),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1A73E8),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.check_circle_outline),
                                SizedBox(width: 8),
                                Text(
                                  "Check Feasibility",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Water fact tip
                        Container(
                          margin: const EdgeInsets.only(top: 24),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                            border: Border.all(
                              color: const Color(0xFF1A73E8).withOpacity(0.1),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1A73E8).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.lightbulb_outline,
                                  color: Color(0xFF1A73E8),
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Did you know?",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1A73E8),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "The roof material significantly affects how much rainwater you can collect. GI sheets have the highest collection efficiency.",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[800],
                                        height: 1.3,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build consistent text fields
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required TextInputType keyboardType,
    required FormFieldValidator<String> validator,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
          labelStyle: TextStyle(color: Colors.grey[700]),
          prefixIcon: Icon(icon, color: const Color(0xFF1A73E8)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey[200]!, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF1A73E8), width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.red[400]!, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.red[400]!, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  // Helper method to build consistent dropdown fields
  Widget _buildDropdownField<T>({
    required String label,
    required String hint,
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
    FormFieldValidator<T>? validator,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonFormField<T>(
        value: value,
        items: items,
        onChanged: onChanged,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
          labelStyle: TextStyle(color: Colors.grey[700]),
          prefixIcon: Icon(icon, color: const Color(0xFF1A73E8)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey[200]!, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF1A73E8), width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.red[400]!, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.red[400]!, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          filled: true,
          fillColor: Colors.white,
        ),
        icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF1A73E8)),
        isExpanded: true,
        dropdownColor: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}