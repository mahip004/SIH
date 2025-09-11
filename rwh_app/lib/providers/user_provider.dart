import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../helpers/soil_helper.dart';

class UserProvider with ChangeNotifier {
  // ✅ Firebase user (for login state)
  User? _user;
  User? get user => _user;

  // ✅ Form data
  int numberOfDwellers = 0;
  double roofArea = 0;
  String roofType = ''; // flat/sloping
  String roofMaterial = ''; // e.g., "GI Sheet"
  double runoffCoefficient = 0; // coefficient
  double openSpace = 0;
  String soilType = ''; // soil type
  String state = '';    // state
  bool limitedSpace = false; // <-- Add this

  // ✅ Location data
  double? _latitude;
  double? _longitude;

  double? get latitude => _latitude;
  double? get longitude => _longitude;

  void setLocation(double latitude, double longitude) {
    _latitude = latitude;
    _longitude = longitude;
    notifyListeners();
  }

  void clearLocation() {
    _latitude = null;
    _longitude = null;
    notifyListeners();
  }

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
    required String roofType,
    required String roofMaterial,
    required double runoffCoefficient,
    required double openSpace,
    required String state,
  }) {
    this.numberOfDwellers = numberOfDwellers;
    this.roofArea = roofArea;
    this.roofType = roofType;
    this.roofMaterial = roofMaterial;
    this.runoffCoefficient = runoffCoefficient;
    this.openSpace = openSpace;
    this.state = state;
    this.soilType = SoilHelper.getSoilType(state);

    notifyListeners();
  }

  void clearUserData() {
    numberOfDwellers = 0;
    roofArea = 0;
    roofType = '';
    roofMaterial = '';
    runoffCoefficient = 0;
    openSpace = 0;
    soilType = '';
    state = '';
    notifyListeners();
  }
}
