import 'package:flutter/foundation.dart';

class AppProvider extends ChangeNotifier {
  String userName = "";

  void setUserName(String name) {
    userName = name;
    notifyListeners();
  }
}
