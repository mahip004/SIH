import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../providers/user_provider.dart';
import 'profile_screen.dart';

class UsersInDistrictScreen extends StatelessWidget {
  const UsersInDistrictScreen({super.key});

  Future<List<Map<String, dynamic>>> _fetchUsersInDistrict(String district) async {
    final query = await FirebaseFirestore.instance
        .collection('users')
        .where('district', isEqualTo: district)
        .get();
    return query.docs.map((doc) => doc.data()).toList();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user ?? FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Users in Your District'),
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: user != null
            ? FirebaseFirestore.instance.collection('users').doc(user.uid).get()
            : null,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          }
          final userData = snapshot.data!.data();
          final district = userData?['district'];
          if (district == null || district.toString().isEmpty) {
            return _NoDistrictWidget();
          }
          return FutureBuilder<List<Map<String, dynamic>>>(
            future: _fetchUsersInDistrict(district),
            builder: (context, usersSnapshot) {
              if (!usersSnapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final users = usersSnapshot.data!;
              return Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    Text(
                      "🌎 $district District",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF185A9D),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "There are ${users.length} users from your district using Rainwater Hub!",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF43CEA2),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: users.isEmpty
                          ? Center(
                              child: Text(
                                "Be the first to start rainwater harvesting in your district!",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[700],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            )
                          : ListView.builder(
                              itemCount: users.length,
                              itemBuilder: (context, idx) {
                                final u = users[idx];
                                return Card(
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  margin: const EdgeInsets.symmetric(vertical: 8),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: const Color(0xFF185A9D),
                                      child: Text(
                                        (u['name'] ?? 'U')[0].toUpperCase(),
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    title: Text(u['name'] ?? 'Unknown'),
                                    subtitle: Text(u['email'] ?? ''),
                                  ),
                                );
                              },
                            ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF43CEA2).withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        "Join others in your district and make a difference! "
                        "Encourage your friends and neighbors to start harvesting rainwater.",
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF185A9D),
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _NoDistrictWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_off, size: 48, color: Color(0xFF185A9D)),
            const SizedBox(height: 24),
            const Text(
              "District not set!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF185A9D)),
            ),
            const SizedBox(height: 12),
            Text(
              "Please set your district in your profile to see other users from your area.",
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.person_pin_circle),
              label: const Text("Go to Profile"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF185A9D),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => ProfileScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}