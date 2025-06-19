import 'dart:async';

import 'package:flutter/foundation.dart';

class AnimationState with ChangeNotifier {
  bool _isAnimating = false;
  bool get isAnimating => _isAnimating;

  void setAnimating(bool value) {
    if (_isAnimating != value) {
      _isAnimating = value;
      notifyListeners();
    }
  }
}

class ChartState with ChangeNotifier {
  bool _isAutoRefresh = false;
  bool get isAutoRefresh => _isAutoRefresh;

  void setAutoRefresh(bool value) {
    if (_isAutoRefresh != value) {
      _isAutoRefresh = value;
      notifyListeners();
    }
  }

  void stopAutoRefresh(Timer? chartTimer){
    chartTimer?.cancel();
    chartTimer = null;
  }
}