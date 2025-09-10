import 'package:flutter/foundation.dart'; // 🔹 for kIsWeb
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'feasibility_form.dart';
import 'trends_screen.dart';
import 'past_reports_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // --- Logout function with confirmation ---
  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), // Cancel
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop(); // Close the dialog
              await _logout(context);
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    try {
      // Firebase logout
      await FirebaseAuth.instance.signOut();

      // Only sign out from GoogleSignIn on non-web platforms
      if (!kIsWeb) {
        await GoogleSignIn().signOut();
      }

      // Navigate to login screen and remove all previous routes
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
            (route) => false,
      );
    } catch (e) {
      debugPrint("Logout failed: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Logout failed: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Rainwater Hub",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0A66C2),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () => _confirmLogout(context),
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[100],
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Welcome Back 👋",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0A66C2),
              ),
            ),
            const SizedBox(height: 20),

            // --- Water Insights ---
            _buildHomeCard(
              context,
              icon: FontAwesomeIcons.chartLine,
              title: "Water Insights",
              subtitle: "See recent trends and rainfall updates",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TrendsScreen()),
                );
              },
            ),

            // --- Check Feasibility ---
            _buildHomeCard(
              context,
              icon: FontAwesomeIcons.droplet,
              title: "Check Feasibility",
              subtitle: "Evaluate rooftop rainwater harvesting potential",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FeasibilityForm()),
                );
              },
            ),

            // --- Past Reports ---
            _buildHomeCard(
              context,
              icon: FontAwesomeIcons.clockRotateLeft,
              title: "Past Reports",
              subtitle: "View your previous feasibility results",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PastReportsScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // --- Helper Widget for Home Cards ---
  Widget _buildHomeCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
        required VoidCallback onTap,
      }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, size: 32, color: const Color(0xFF0A66C2)),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text(subtitle,
                        style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
