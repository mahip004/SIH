import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      UserCredential userCredential;

      if (kIsWeb) {
        // Web: Use popup sign-in
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        userCredential = await FirebaseAuth.instance.signInWithPopup(googleProvider);
      } else {
        // Mobile/Desktop: Force logout of any previous Google session
        final GoogleSignIn googleSignIn = GoogleSignIn();
        await googleSignIn.signOut(); // ← Important to allow re-login

        final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
        if (googleUser == null) return; // User cancelled sign-in

        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      }

      // Save user to provider
      Provider.of<UserProvider>(context, listen: false).setUser(userCredential.user);
    } catch (e) {
      debugPrint('Error during Google Sign-In: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign-In Failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RainHarvestPro'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Rainwater harvesting icon from assets
              Image.asset(
                'assets/harvesting.jpg',
                height: 120,
              ),
              const SizedBox(height: 20),
              const Text(
                'Estimate rooftop rainwater harvesting potential and support groundwater conservation!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                // Google Sign-In icon from assets
                icon: Image.asset(
                  'assets/google_logo.png',
                  height: 24,
                  width: 24,
                ),
                label: const Text(
                  'Sign in with Google',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                onPressed: () => _signInWithGoogle(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
