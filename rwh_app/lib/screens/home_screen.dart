import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import 'result_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _roofController = TextEditingController();
  final TextEditingController _dwellersController = TextEditingController();
  final TextEditingController _spaceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rainwater Harvesting Feasibility'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (value) =>
                  value!.isEmpty ? 'Enter your name' : null,
                ),
                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(labelText: 'Location'),
                  validator: (value) =>
                  value!.isEmpty ? 'Enter your location' : null,
                ),
                TextFormField(
                  controller: _roofController,
                  decoration: const InputDecoration(labelText: 'Roof Area (m²)'),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                  value!.isEmpty ? 'Enter roof area' : null,
                ),
                TextFormField(
                  controller: _dwellersController,
                  decoration:
                  const InputDecoration(labelText: 'Number of Dwellers'),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                  value!.isEmpty ? 'Enter number of dwellers' : null,
                ),
                TextFormField(
                  controller: _spaceController,
                  decoration: const InputDecoration(labelText: 'Open Space (m²)'),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                  value!.isEmpty ? 'Enter open space area' : null,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Provider.of<UserProvider>(context, listen: false)
                          .setUserData(
                        name: _nameController.text,
                        location: _locationController.text,
                        roofArea: double.parse(_roofController.text),
                        numberOfDwellers: int.parse(_dwellersController.text),
                        openSpace: double.parse(_spaceController.text),
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ResultScreen(),
                        ),
                      );
                    }
                  },
                  child: const Text('Check Feasibility'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
