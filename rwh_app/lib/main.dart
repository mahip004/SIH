import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart'; // 🔹 Firebase options
import 'providers/user_provider.dart';
import 'providers/app_provider.dart'; // <-- Add this import
import 'screens/login_screen.dart';
import 'screens/home_screen.dart'; // ✅ import the new Home Page
import 'package:cloud_firestore/cloud_firestore.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // 🔹 use this
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => AppProvider()), // <-- Add this line
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Rainwater Harvesting App',
        theme: ThemeData(
          primaryColor: const Color(0xFF0A66C2), // LinkedIn blue
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF0A66C2),
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF0A66C2), width: 2),
            ),
            labelStyle: const TextStyle(color: Colors.black87),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0A66C2),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding:
              const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
              textStyle: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              Provider.of<UserProvider>(context, listen: false)
                  .setUser(snapshot.data);

              // Fetch user name from Firestore and set in AppProvider
              if (snapshot.hasData) {
                final uid = snapshot.data!.uid;
                final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
                final name = doc.data()?['name'] ?? '';
                Provider.of<AppProvider>(context, listen: false).setUserName(name);
              }
            });

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            if (snapshot.hasData) {
              return const HomeScreen();
            }
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
