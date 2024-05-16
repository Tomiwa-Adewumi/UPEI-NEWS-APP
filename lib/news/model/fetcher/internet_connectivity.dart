import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

// InternetConnectivityProvider class responsible for managing internet connectivity state
class InternetConnectivityProvider extends ChangeNotifier {
  bool _isConnected = false; // Variable to track internet connectivity status

  bool get isConnected => _isConnected; // Getter method to access _isConnected variable

  final Connectivity _connectivity = Connectivity(); // Instance of Connectivity plugin

  late StreamSubscription<ConnectivityResult> _connectivitySubscription; // Stream subscription for monitoring connectivity changes

  // Constructor to initialize connectivity monitoring
  InternetConnectivityProvider() {
    _initConnectivity();
  }

  // Function to initialize connectivity monitoring
  Future<void> _initConnectivity() async {
    ConnectivityResult result = await _connectivity.checkConnectivity(); // Check current connectivity status
    _isInternetConnected(result); // Update _isConnected variable based on initial connectivity status
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
          // Listen for connectivity changes
          _isInternetConnected(result); // Update _isConnected variable based on updated connectivity status
        });
  }

  // Function to update _isConnected variable based on connectivity status
  void _isInternetConnected(ConnectivityResult? result) {
    if (result == ConnectivityResult.none) {
      _isConnected = false; // No internet connectivity
    } else if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      _isConnected = true; // Internet connectivity available via mobile data or WiFi
    }
    notifyListeners(); // Notify listeners (e.g., UI) about the updated connectivity status
  }

  // Dispose method to cancel subscription when the object is no longer needed
  @override
  void dispose() {
    _connectivitySubscription.cancel(); // Cancel the connectivity subscription
    super.dispose(); // Call the superclass dispose method
  }
}
