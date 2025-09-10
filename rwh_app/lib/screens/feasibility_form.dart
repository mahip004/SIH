import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  final TextEditingController _roofController = TextEditingController();
  final TextEditingController _roofMaterialController = TextEditingController();
  final TextEditingController _spaceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                controller: _roofController,
                decoration: const InputDecoration(labelText: "Roof Area (m²)"),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? "Enter roof area" : null,
              ),
              const SizedBox(height: 16),

              // Roof Material
              TextFormField(
                controller: _roofMaterialController,
                decoration: const InputDecoration(labelText: "Roof Material"),
                validator: (value) => value!.isEmpty ? "Enter roof material" : null,
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
                    if (_formKey.currentState!.validate()) {
                      Provider.of<UserProvider>(context, listen: false).setUserData(
                        numberOfDwellers: int.parse(_dwellersController.text),
                        roofArea: double.parse(_roofController.text),
                        roofMaterial: _roofMaterialController.text,
                        openSpace: double.parse(_spaceController.text),
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
