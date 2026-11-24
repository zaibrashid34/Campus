import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier {
  bool _notificationsEnabled = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  double _fontSize = 14.0;
  bool _screenReaderSupport = false;

  bool get notificationsEnabled => _notificationsEnabled;
  bool get soundEnabled => _soundEnabled;
  bool get vibrationEnabled => _vibrationEnabled;
  double get fontSize => _fontSize;
  bool get screenReaderSupport => _screenReaderSupport;

  void toggleNotifications(bool value) {
    _notificationsEnabled = value;
    notifyListeners();
  }

  void toggleSound(bool value) {
    _soundEnabled = value;
    notifyListeners();
  }

  void toggleVibration(bool value) {
    _vibrationEnabled = value;
    notifyListeners();
  }

  void setFontSize(double size) {
    _fontSize = size;
    notifyListeners();
  }

  void toggleScreenReaderSupport(bool value) {
    _screenReaderSupport = value;
    notifyListeners();
  }
}
