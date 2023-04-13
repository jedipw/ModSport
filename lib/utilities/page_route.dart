import 'package:flutter/material.dart';
import 'package:modsport/constants/routes.dart';

class ModSportPageRoute<T> extends MaterialPageRoute<T> {
  final List<String> noAnimationRoutes = [
    homeRoute,
    statusRoute,
    menuRoute,
  ];

  ModSportPageRoute(
      {required WidgetBuilder builder, required RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (noAnimationRoutes.contains(settings.name)) {
      return child;
    }
    return super
        .buildTransitions(context, animation, secondaryAnimation, child);
  }
}
