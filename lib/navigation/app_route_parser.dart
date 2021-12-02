import 'package:flutter/material.dart';

import 'app_link.dart';

// AppRouteParser extends RouteInformationParser
class AppRouteParser extends RouteInformationParser<AppLink> {
  // override the parseRouteInformation()
  @override
  Future<AppLink> parseRouteInformation(
      RouteInformation routeInformation) async {
    // Take the route information and build an instance of AppLink from it.
    final link = AppLink.fromLocation(routeInformation.location);
    return link;
  }

  // The second method you need to override is restoreRouteInformation().

  @override
  RouteInformation restoreRouteInformation(AppLink appLink) {
    // This function passes in an AppLink object

    final location = appLink.toLocation();
    // You wrap it in RouteInformation to pass it along
    return RouteInformation(location: location);
  }
}
