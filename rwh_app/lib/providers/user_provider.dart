import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String name = '';
  String location = '';
  double roofArea = 0;
  int numberOfDwellers = 0;
  double openSpace = 0;

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
