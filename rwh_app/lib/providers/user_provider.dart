import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProvider with ChangeNotifier {
  // ✅ Firebase user (for login state)
  User? _user;
  User? get user => _user;

  // ✅ Form data
  int numberOfDwellers = 0;
  double roofArea = 0;
  String roofMaterial = '';
  double openSpace = 0;

  // --- Firebase user management ---
  void setUser(User? user) {
    _user = user;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }

  // --- Form data management ---
  void setUserData({
    required int numberOfDwellers,
    required double roofArea,
    required String roofMaterial,
    required double openSpace,
  }) {
    this.numberOfDwellers = numberOfDwellers;
    this.roofArea = roofArea;
    this.roofMaterial = roofMaterial;
    this.openSpace = openSpace;
    notifyListeners();
  }

  void clearUserData() {
    numberOfDwellers = 0;
    roofArea = 0;
    roofMaterial = '';
    openSpace = 0;
    notifyListeners();
  }
}
