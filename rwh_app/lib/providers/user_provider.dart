import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProvider with ChangeNotifier {
  // ✅ Firebase user (for login state)
  User? _user;
  User? get user => _user;

  // ✅ Form data
  String name = '';
  String location = '';
  double roofArea = 0;
  int numberOfDwellers = 0;
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
    required String name,
    required String location,
    required double roofArea,
    required int numberOfDwellers,
    required double openSpace,
  }) {
    this.name = name;
    this.location = location;
    this.roofArea = roofArea;
    this.numberOfDwellers = numberOfDwellers;
    this.openSpace = openSpace;
    notifyListeners();
  }

  void clearUserData() {
    name = '';
    location = '';
    roofArea = 0;
    numberOfDwellers = 0;
    openSpace = 0;
    notifyListeners();
  }
}
