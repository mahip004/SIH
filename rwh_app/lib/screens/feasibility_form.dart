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

class _FeasibilityFormState extends State<FeasibilityForm> with SingleTickerProviderStateMixin {
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

  late AnimationController _animationController;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _loadSoil();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);

    _colorAnimation = ColorTween(
       begin: const Color(0xFFF5F7FA), // very light white-grey
  end: const Color(0xFFE3E9F2),   // another soft white-grey
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _dwellersController.dispose();
    _roofAreaController.dispose();
    _spaceController.dispose();
    super.dispose();
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
              const Color(0xFF1A73E8).withOpacity(0.07),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar with wave shape and gradient
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [const Color(0xFF0D47A1), const Color(0xFF1976D2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                    const SizedBox(width: 18),
                    AnimatedBuilder(
                      animation: _colorAnimation,
                      builder: (context, child) => Text(
                        "Feasibility Form",
                        style: TextStyle(
                          color: _colorAnimation.value,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.1,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.25),
                              offset: const Offset(0, 3),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [const Color(0xFF42A5F5), const Color(0xFF1A73E8)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF1A73E8).withOpacity(0.6),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.water_drop,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),

              // Form Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
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
                                  Text(
                                    "Check Your Feasibility",
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.blue.shade900,
                                      letterSpacing: 0.6,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Fill in the details to evaluate your rainwater harvesting potential",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey.shade700,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 12),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade100.withOpacity(0.3),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blue.shade200.withOpacity(0.5),
                                    blurRadius: 16,
                                    spreadRadius: 1,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.calculate_outlined,
                                color: Colors.blue.shade700,
                                size: 32,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),

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
                        const SizedBox(height: 20),

                        // Number of Dwellers
                        _buildTextField(
                          controller: _dwellersController,
                          label: "Number of Dwellers",
                          hint: "Enter the number of people",
                          keyboardType: TextInputType.number,
                          validator: (value) => value!.isEmpty ? "Enter number of dwellers" : null,
                          icon: Icons.people_outline,
                        ),
                        const SizedBox(height: 20),

                        // Roof Area
                        _buildTextField(
                          controller: _roofAreaController,
                          label: "Roof Area (m²)",
                          hint: "Enter your roof area",
                          keyboardType: TextInputType.number,
                          validator: (value) => value!.isEmpty ? "Enter roof area" : null,
                          icon: Icons.home_outlined,
                        ),
                        const SizedBox(height: 20),

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
                        const SizedBox(height: 20),

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
                        const SizedBox(height: 20),

                        // Open Space
                        _buildTextField(
                          controller: _spaceController,
                          label: "Available Open Space (m²)",
                          hint: "Enter available open space",
                          keyboardType: TextInputType.number,
                          validator: (value) => value!.isEmpty ? "Enter open space area" : null,
                          icon: Icons.landscape_outlined,
                        ),
                        const SizedBox(height: 36),

                        // Submit Button with gradient and shadow
                        Container(
                          width: double.infinity,
                          height: 58,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF1A73E8), Color(0xFF42A5F5)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF1A73E8).withOpacity(0.45),
                                blurRadius: 18,
                                offset: const Offset(0, 8),
                                spreadRadius: 1,
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
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 0,
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.check_circle_outline, size: 24),
                                SizedBox(width: 10),
                                Text(
                                  "Check Feasibility",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.6,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Water fact tip card with soft shadows and icon gradient
                        Container(
                          margin: const EdgeInsets.only(top: 30),
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.shade100.withOpacity(0.3),
                                blurRadius: 18,
                                offset: const Offset(0, 8),
                              ),
                            ],
                            border: Border.all(
                              color: const Color(0xFF1A73E8).withOpacity(0.15),
                              width: 1.2,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [const Color(0xFF1A73E8), const Color(0xFF42A5F5)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF1A73E8).withOpacity(0.7),
                                      blurRadius: 16,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.lightbulb_outline,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Did you know?",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.blue.shade900,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      "The roof material significantly affects how much rainwater you can collect. GI sheets have the highest collection efficiency.",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey.shade800,
                                        height: 1.4,
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

  // Helper method to build consistent text fields with subtle neumorphic style
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
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade100.withOpacity(0.4),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.white,
            blurRadius: 10,
            offset: const Offset(-6, -6),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 15),
          labelStyle: TextStyle(color: Colors.blue.shade900, fontWeight: FontWeight.w700),
          prefixIcon: Icon(icon, color: const Color(0xFF1A73E8)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.blue.shade50, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Color(0xFF1A73E8), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.red.shade400, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.red.shade700, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  // Helper method to build consistent dropdown fields with neumorphic style
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
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade100.withOpacity(0.4),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.white,
            blurRadius: 10,
            offset: const Offset(-6, -6),
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
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 15),
          labelStyle: TextStyle(color: Colors.blue.shade900, fontWeight: FontWeight.w700),
          prefixIcon: Icon(icon, color: const Color(0xFF1A73E8)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.blue.shade50, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Color(0xFF1A73E8), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.red.shade400, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.red.shade700, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
          filled: true,
          fillColor: Colors.white,
        ),
        icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF1A73E8)),
        isExpanded: true,
        dropdownColor: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}