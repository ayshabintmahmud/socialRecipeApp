class AppLink {
  // Create constants for each URL path.
  static const String homePath = '/home';
  static const String onboardingPath = '/onboarding';
  static const String loginPath = '/login';
  static const String profilePath = '/profile';
  static const String itemPath = '/item';
  // Create constants for each of the query parameters you’ll support.
  static const String tabParam = 'tab';
  static const String idParam = 'id';
  // Store the path of the URL using location.
  String? location;
  // Use currentTab to store the tab you want to redirect the user to.
  int? currentTab;
  // Store the ID of the item you want to view in itemId.
  String? itemId;
  // Initialize the app link with the location and the two query parameters.

  AppLink({
    this.location,
    this.currentTab,
    this.itemId,
  });

//fromLocation
  static AppLink fromLocation(String? location) {
    // decode the URL
    location = Uri.decodeFull(location ?? '');
    // Parse the URI for query parameter keys and key-value pairs.
    final uri = Uri.parse(location);
    final params = uri.queryParameters;

    // Extract the currentTab from the URL path if it exists
    final currentTab = int.tryParse(params[AppLink.tabParam] ?? '');
    // Extract the itemId from the URL path if it exists.
    final itemId = params[AppLink.idParam];
    // Create the AppLink by passing in the query parameters
    final link = AppLink(
      location: uri.path,
      currentTab: currentTab,
      itemId: itemId,
    );
    // Return the instance of AppLink.
    return link;
  }

//Add toLocation
  String toLocation() {
    // 1
    String addKeyValPair({
      required String key,
      String? value,
    }) =>
        value == null ? '' : '${key}=$value&';
    // Go through each defined path.
    switch (location) {
      // If the path is loginPath, return the right string path: /login
      case loginPath:
        return loginPath;
      // If the path is onboardingPath, return the right string path: /onboarding.
      case onboardingPath:
        return onboardingPath;
      // If the path is profilePath, return the right string path: /profile.
      case profilePath:
        return profilePath;
      //f the path is itemPath, return the right string path: /item
      case itemPath:
        var loc = '$itemPath?';
        loc += addKeyValPair(
          key: idParam,
          value: itemId,
        );
        return Uri.encodeFull(loc);
      // If the path is invalid, default to the path /home
      default:
        var loc = '$homePath?';
        loc += addKeyValPair(
          key: tabParam,
          value: currentTab.toString(),
        );
        return Uri.encodeFull(loc);
    }
  }
}
