import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../helpers/location_helper.dart';
import '../services/firestore_service.dart'; // 🔹 import Firestore service
import 'home_screen.dart';
import '../l10n/app_localizations.dart';
import '../widgets/language_selector.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  bool _isSigningIn = false;

  late AnimationController _animationController;
  late Animation<Color?> _backgroundGradientAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);

    _backgroundGradientAnimation = ColorTween(
      begin: const Color(0xFF1A73E8),
      end: const Color(0xFF2A93D5),
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    if (_isSigningIn) return; // prevent multiple clicks
    setState(() => _isSigningIn = true);

    try {
      UserCredential userCredential;

      if (kIsWeb) {
        // --- WEB LOGIN ---
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        try {
          userCredential =
              await FirebaseAuth.instance.signInWithPopup(googleProvider);
        } catch (e) {
          debugPrint('Popup failed, falling back to redirect: $e');
          await FirebaseAuth.instance.signInWithRedirect(googleProvider);
          final result = await FirebaseAuth.instance.getRedirectResult();
          if (result.user == null) {
            setState(() => _isSigningIn = false);
            return;
          }
          userCredential = result;
        }
      } else {
        // --- MOBILE LOGIN (Android/iOS/Emulator) ---
        final GoogleSignIn googleSignIn = GoogleSignIn();
        final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

        if (googleUser == null) {
          // user canceled sign-in
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

      // --- SAVE USER IN PROVIDER ---
      final user = userCredential.user;
      Provider.of<UserProvider>(context, listen: false).setUser(user);

      // --- SAVE USER TO FIRESTORE ---
      if (user != null) {
        await FirestoreService().saveUser(
          user.uid,
          user.displayName ?? "No Name",
          user.email ?? "No Email",
          "Jabalpur",
        );
        debugPrint("✅ User data saved successfully for UID: ${user.uid}");
      } else {
        debugPrint("⚠️ User is null, nothing to save to Firestore.");
      }

      // --- LOCATION PROMPT ---
      final savedLocation = await LocationHelper.getSavedLocation();
      double? latitude;
      double? longitude;

      final l10n = AppLocalizations.of(context);

      if (savedLocation == null) {
        bool? shareLocation = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(l10n.shareLocationTitle,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            content: Text(
              l10n.shareLocationDesc,
              style: const TextStyle(fontSize: 15),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(l10n.no),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A73E8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(l10n.yes, style: const TextStyle(color: Colors.white)),
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
        await Future.delayed(const Duration(milliseconds: 150));
        debugPrint("📍 User location saved: ($latitude, $longitude)");
      }

      // --- NAVIGATE TO HOME ---
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
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
    final Color animatedColor =
        _backgroundGradientAnimation.value ?? const Color(0xFF1A73E8);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              animatedColor.withOpacity(0.8),
              animatedColor.withOpacity(0.7),
              Colors.white,
            ],
            stops: const [0.0, 0.4, 1.0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 16),
                const LanguageSelector(),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: animatedColor.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.water_drop,
                    size: 60,
                    color: animatedColor,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.appTitle,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1,
                    shadows: const [
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
                  child: Text(
                    l10n.sustainableWaterDesc,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      height: 1.4,
                      shadows: const [
                        Shadow(
                          color: Colors.black26,
                          offset: Offset(0, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40), // <-- Replace Spacer with SizedBox
                Container(
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
                                    color: animatedColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.eco_outlined,
                                    color: animatedColor,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    l10n.sustainableWaterSolutions,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: animatedColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              l10n.sustainableWaterDesc,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[700],
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: animatedColor.withOpacity(0.2),
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
                              ? CircularProgressIndicator(
                                  color: animatedColor,
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
                                    Text(
                                      l10n.signInWithGoogle,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        l10n.tosPrivacy,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}