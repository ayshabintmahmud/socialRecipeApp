import 'package:flutter/material.dart';

import '../models/models.dart';
import '../screens/screens.dart';

// extends RouterDelegate
class AppRouter extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  // Declares GlobalKey, a unique key across the entire app
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  // Declares AppStateManager
  final AppStateManager appStateManager;
  //Declares GroceryManager to listen to the user’s state.
  final GroceryManager groceryManager;
  //Declares ProfileManager to listen to the user profile state.
  final ProfileManager profileManager;

  AppRouter({
    required this.appStateManager,
    required this.groceryManager,
    required this.profileManager,
  }) : navigatorKey = GlobalKey<NavigatorState>() {
    //Add Listeners
    appStateManager.addListener(notifyListeners);
    groceryManager.addListener(notifyListeners);
    profileManager.addListener(notifyListeners);
  }

  // Dispose listeners
  @override
  void dispose() {
    appStateManager.removeListener(notifyListeners);
    groceryManager.removeListener(notifyListeners);
    profileManager.removeListener(notifyListeners);
    super.dispose();
  }

  // configures the navigator and pages.
  @override
  Widget build(BuildContext context) {
    // Configures a Navigator
    return Navigator(
      // is required to retrieve the current navigator.
      key: navigatorKey,
      onPopPage: _handlePopPage,
      // Declares pages
      pages: [
        //SplashScreen
        if (!appStateManager.isInitialized) SplashScreen.page(),
        //LoginScreen
        if (appStateManager.isInitialized && !appStateManager.isLoggedIn)
          LoginScreen.page(),

        //OnboardingScreen
        if (appStateManager.isLoggedIn && !appStateManager.isOnboardingComplete)
          OnboardingScreen.page(),

        //Home
        if (appStateManager.isOnboardingComplete)
          Home.page(appStateManager.getSelectedTab),

        //Create new item
        // Checks if the user is creating a new grocery item.
        if (groceryManager.isCreatingNewItem)
          //If so, shows the Grocery Item screen.
          GroceryItemScreen.page(
            onCreate: (item) {
              // Once the user saves the item, updates the grocery list.
              groceryManager.addItem(item);
            },
            onUpdate: (item, index) {
              // 4 No update
            },
          ),

        //Select GroceryItemScreen
        // Checks to see if a grocery item is selected.
        if (groceryManager.selectedIndex != -1)
          // If so, creates the Grocery Item screen page.
          GroceryItemScreen.page(
              item: groceryManager.selectedGroceryItem,
              index: groceryManager.selectedIndex,
              onUpdate: (item, index) {
                // it updates the item at the current index.
                groceryManager.updateItem(item, index);
              },
              onCreate: (_) {
                // 4 No create
              }),

        //Add Profile Screen
        if (profileManager.didSelectUser)
          ProfileScreen.page(profileManager.getUser),

        //Add WebView Screen
        if (profileManager.didTapOnRaywenderlich) WebViewScreen.page(),
      ],
    );
  }

  bool _handlePopPage(
      // the current Route
      Route<dynamic> route,
      // result is the value that returns when the route completes
      result) {
    // Checks if the current route’s pop succeeded.
    if (!route.didPop(result)) {
      // if yes triggers the appropriate state changes.
      return false;
    }

    // 5
    //Handle Onboarding and splash
    if (route.settings.name == FooderlichPages.onboardingPath) {
      appStateManager.logout();
    }

    //Handle state when user closes grocery item screen
    if (route.settings.name == FooderlichPages.groceryItemDetails) {
      groceryManager.groceryItemTapped(-1);
    }

    //Handle state when user closes profile screen
    if (route.settings.name == FooderlichPages.profilePath) {
      profileManager.tapOnProfile(false);
    }

    //Handle state when user closes WebView screen
    if (route.settings.name == FooderlichPages.raywenderlich) {
      profileManager.tapOnRaywenderlich(false);
    }

    // 6
    return true;
  }

  // Sets setNewRoutePath to null since you aren’t supporting Flutter web apps.
  @override
  Future<void> setNewRoutePath(configuration) async => null;
}
