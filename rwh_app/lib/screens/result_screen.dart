import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);

    // Simple calculation for rainwater harvesting potential
    // Runoff = Roof Area * Rainfall Coefficient * Average Rainfall
    // Using approximate coefficient 0.8 and average rainfall 1000mm (1m)
    double runoffPotential = user.roofArea * 0.8 * 1; // in m³

    // Suggest type of recharge structure
    String suggestedStructure = '';
    if (user.openSpace >= 10) {
      suggestedStructure = 'Recharge Pit';
    } else if (user.openSpace >= 5) {
      suggestedStructure = 'Recharge Trench';
    } else {
      suggestedStructure = 'Recharge Shaft';
    }

    // Estimated water per dweller per day (simple model)
    double dailyWaterPerDweller = 135; // liters per person per day
    double totalDaysSupport = (runoffPotential * 1000) / // convert m³ to liters
        (user.numberOfDwellers * dailyWaterPerDweller);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Feasibility Result'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, ${user.name}',
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'Location: ${user.location}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Runoff Potential: ${runoffPotential.toStringAsFixed(2)} m³ per year',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Suggested Recharge Structure: $suggestedStructure',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Can support ${totalDaysSupport.toStringAsFixed(0)} days of water for ${user.numberOfDwellers} dwellers',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}
