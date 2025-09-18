import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Save or update user information in Firestore
  Future<void> saveUser(String uid, String name, String email, String district) async {
    try {
      await _db.collection("users").doc(uid).set({
        "name": name,
        "email": email,
        "createdAt": FieldValue.serverTimestamp(),
        "district": district,
      }, SetOptions(merge: true)); // merge avoids overwriting existing data
      print("✅ Firestore: User saved successfully");
    } catch (e) {
      print("❌ Firestore error: $e");
      rethrow;
    }
  }

  /// Update only the district field
  Future<void> updateDistrict(String uid, String district) async {
    try {
      await _db.collection("users").doc(uid).set({
        "district": district,
      }, SetOptions(merge: true));
      print("✅ Firestore: District updated successfully");
    } catch (e) {
      print("❌ Firestore error: $e");
      rethrow;
    }
  }

  /// Fetch user data
  Future<DocumentSnapshot<Map<String, dynamic>>> getUser(String uid) async {
    return await _db.collection("users").doc(uid).get();
  }
}