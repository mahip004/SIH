import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../helpers/location_helper.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isSigningIn = false;

  Future<void> _signInWithGoogle(BuildContext context) async {
    if (_isSigningIn) return; // prevent multiple clicks
    setState(() => _isSigningIn = true);

    try {
      UserCredential userCredential;

      // --- GOOGLE SIGN-IN ---
      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        try {
          // try popup first (fast & common)
          userCredential =
          await FirebaseAuth.instance.signInWithPopup(googleProvider);
        } catch (e) {
          // Popup may be blocked due to COOP/COEP policies. Fallback to redirect.
          debugPrint('Popup failed, falling back to redirect: $e');
          try {
            await FirebaseAuth.instance.signInWithRedirect(googleProvider);
            // After redirect the app reloads; try to obtain the result (may be null if redirect hasn't completed)
            final result = await FirebaseAuth.instance.getRedirectResult();
            if (result.user == null) {
              // If still null, bail out gracefully; the redirect should complete the auth cycle.
              setState(() => _isSigningIn = false);
              return;
            }
            userCredential = result;
          } catch (e2) {
            debugPrint('Redirect sign-in also failed: $e2');
            rethrow;
          }
        }
      } else {
        // mobile / non-web
        final GoogleSignInAccount? googleUser =
            await GoogleSignIn().signInSilently() ?? await GoogleSignIn().signIn();
        if (googleUser == null) {
          setState(() => _isSigningIn = false);
          return;
        }

        final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
      }

      // --- SAVE USER ---
      Provider.of<UserProvider>(context, listen: false)
          .setUser(userCredential.user);

      // --- LOCATION PROMPT ---
      final savedLocation = await LocationHelper.getSavedLocation();
      double? latitude;
      double? longitude;

      if (savedLocation == null) {
        bool? shareLocation = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              "📍 Share Location",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: const Text(
              "Do you wish to share your location? This will help auto-update rainfall and feasibility data.",
              style: TextStyle(fontSize: 15),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("No"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A73E8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Yes", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );

        if (shareLocation == true) {
          final loc = await LocationHelper.askLocationPermissionAndFetch();
          if (loc != null) {
            latitude = loc.latitude;
            longitude = loc.longitude;
          }
        }
      } else {
        latitude = savedLocation.latitude;
        longitude = savedLocation.longitude;
      }

      // Save location to UserProvider
      if (latitude != null && longitude != null) {
        Provider.of<UserProvider>(context, listen: false)
            .setLocation(latitude, longitude);
        // give provider a small moment to propagate (normally not needed, but avoids a possible race)
        await Future.delayed(const Duration(milliseconds: 150));
      }

      // --- NAVIGATE TO HOME ---
      // Router is driven by authStateChanges now; simply pop to root and let StreamBuilder decide
      if (mounted) {
        Navigator.of(context).maybePop();
      }
    } catch (e) {
      debugPrint('Error during Google Sign-In: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sign-In Failed: $e'),
            backgroundColor: Colors.red[400],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSigningIn = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF1A73E8).withOpacity(0.8),
              const Color(0xFF2A93D5).withOpacity(0.7),
              Colors.white,
            ],
            stops: const [0.0, 0.4, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 1),

              // Logo
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1A73E8).withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.water_drop,
                  size: 60,
                  color: Color(0xFF1A73E8),
                ),
              ),
              const SizedBox(height: 24),

              const Text(
                "Rainwater Hub",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1,
                  shadows: [
                    Shadow(
                      color: Colors.black26,
                      offset: Offset(0, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 40),
                child: const Text(
                  "Your complete solution for rainwater harvesting and groundwater conservation",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    height: 1.4,
                    shadows: [
                      Shadow(
                        color: Colors.black26,
                        offset: Offset(0, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(flex: 1),

              // Main Content Area
              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(30),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      // App Description
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1A73E8).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.eco_outlined,
                                    color: Color(0xFF1A73E8),
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Expanded(
                                  child: Text(
                                    "Sustainable Water Solutions",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1A73E8),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "Estimate rooftop rainwater harvesting potential and support groundwater conservation with our advanced tools and insights.",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[700],
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Spacer(),

                      // Sign In Button
                      Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF1A73E8).withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () => _signInWithGoogle(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black87,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(
                                color: Colors.grey[300]!,
                                width: 1,
                              ),
                            ),
                          ),
                          child: _isSigningIn
                              ? const CircularProgressIndicator(
                            color: Color(0xFF1A73E8),
                          )
                              : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/google_logo.png',
                                height: 24,
                                width: 24,
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Sign in with Google',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Privacy Note
                      Text(
                        "By signing in, you agree to our Terms of Service and Privacy Policy",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}