import 'package:flutter/material.dart';
import 'package:modsport/constants/routes.dart';

class ModSportPageRoute<T> extends MaterialPageRoute<T> {
  final List<String> noAnimationRoutes = [
    homeRoute,
    statusRoute,
    helpCenterRoute,
  ];

  // Constructor to initialize the class with builder and settings
  ModSportPageRoute(
      {required WidgetBuilder builder, required RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // Check if the route name is in the list of routes that don't need animation
    if (noAnimationRoutes.contains(settings.name)) {
      return child; // Return the child widget without animation
    }
    // If the route needs animation, then use the default implementation
    return super
        .buildTransitions(context, animation, secondaryAnimation, child);
  }
}
