import 'package:flutter/material.dart';
import 'result_screen.dart';

class PastReportsScreen extends StatelessWidget {
  const PastReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // --- Dummy past reports ---
    final List<Map<String, String>> pastReports = [
      {
        "date": "2025-09-01",
        "structure": "Recharge Pit",
      },
      {
        "date": "2025-08-25",
        "structure": "Recharge Trench",
      },
      {
        "date": "2025-08-10",
        "structure": "Recharge Shaft",
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Past Reports"),
        backgroundColor: const Color(0xFF0A66C2),
      ),
      body: Container(
        color: Colors.grey[100],
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Your Previous Feasibility Reports",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0A66C2)),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: pastReports.length,
                itemBuilder: (context, index) {
                  final report = pastReports[index];
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Text(
                        "Date: ${report['date']}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 6),
                          Text("Suggested Structure: ${report['structure']}"),
                        ],
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey,
                      ),
                      onTap: () {
                        // TODO: Pass data to ResultScreen if you want full detail
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ResultScreen()),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
