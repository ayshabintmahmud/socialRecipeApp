import 'dart:async';
import 'package:flutter/material.dart';

// Creates constants for each tab the user taps
class FooderlichTab {
  static const int explore = 0;
  static const int recipes = 1;
  static const int toBuy = 2;
}

class AppStateManager extends ChangeNotifier {
  // checks if the app is initialized
  bool _initialized = false;
  // lets you check if the user has logged in
  bool _loggedIn = false;
  // checks if the user completed the onboarding flow
  bool _onboardingComplete = false;
  // keeps track of which tab the user is on
  int _selectedTab = FooderlichTab.explore;

  // These are getter methods for each property.
  bool get isInitialized => _initialized;
  bool get isLoggedIn => _loggedIn;
  bool get isOnboardingComplete => _onboardingComplete;
  int get getSelectedTab => _selectedTab;

  //initializeApp
  void initializeApp() {
    // Sets a delayed timer for 2,000 milliseconds before executing the closure
    Timer(
      const Duration(milliseconds: 2000),
      () {
        // Sets initialized to true
        _initialized = true;
        // Notifies all listeners
        notifyListeners();
      },
    );
  }

  //login
  void login(String username, String password) {
    // Sets loggedIn to true
    _loggedIn = true;
    // Notifies all listeners
    notifyListeners();
  }

  //completeOnboarding
  void completeOnboarding() {
    _onboardingComplete = true;
    notifyListeners();
  }

  //goToTab
  void goToTab(index) {
    _selectedTab = index;
    notifyListeners();
  }

  //goToRecipes
  void goToRecipes() {
    _selectedTab = FooderlichTab.recipes;
    notifyListeners();
  }

  //Add logout
  void logout() {
    // Resets all app state properties.
    _loggedIn = false;
    _onboardingComplete = false;
    _initialized = false;
    _selectedTab = 0;

    // Reinitializes the app.
    initializeApp();
    //Notifies all listeners of state change.
    notifyListeners();
  }
}
