import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Sign in with Google
  Future<User?> signInWithGoogle() async {
    if (kIsWeb) {
      // 🔹 Web sign-in
      GoogleAuthProvider googleProvider = GoogleAuthProvider();
      googleProvider
        ..addScope('email')
        ..addScope('profile');

      final UserCredential userCredential =
      await _auth.signInWithPopup(googleProvider);

      return userCredential.user;
    } else {
      // 🔹 Android / iOS sign-in
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
      );

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) return null; // User cancelled

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
      await _auth.signInWithCredential(credential);

      return userCredential.user;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    await _auth.signOut();
    if (!kIsWeb) {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
      );
      await googleSignIn.signOut();
    }
  }
}
