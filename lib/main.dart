import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:modsport/constants/routes.dart';
import 'package:modsport/views/detail_view.dart';
import 'package:modsport/views/disable_view.dart';
import 'package:modsport/views/help_center_view.dart';
import 'package:modsport/views/home_view.dart';
import 'package:modsport/views/login_view.dart';
import 'package:modsport/views/menu_view.dart';
import 'package:modsport/views/reservation_view.dart';
import 'package:modsport/views/status_view.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: loginRoute,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case loginRoute:
            return NoAnimationPageRoute(
                builder: (_) => const LoginView(), settings: settings);
          case detailRoute:
            return NoAnimationPageRoute(
                builder: (_) => const DetailView(), settings: settings);
          case disableRoute:
            return NoAnimationPageRoute(
                builder: (_) => const DisableView(), settings: settings);
          case homeRoute:
            return NoAnimationPageRoute(
                builder: (_) => const HomeView(), settings: settings);
          case reservationRoute:
            return NoAnimationPageRoute(
                builder: (_) => const ReservationView(), settings: settings);
          case statusRoute:
            return NoAnimationPageRoute(
                builder: (_) => const StatusView(), settings: settings);
          case helpCenterRoute:
            return NoAnimationPageRoute(
                builder: (_) => const HelpCenterView(), settings: settings);
          case menuRoute:
            return NoAnimationPageRoute(
                builder: (_) => const MenuView(), settings: settings);
          default:
            return null;
        }
      },
    );
  }
}

// Route that removes the sliding animation for specific routes
class NoAnimationPageRoute<T> extends MaterialPageRoute<T> {
  final List<String> excludedRoutes = [
    homeRoute,
    statusRoute,
    menuRoute,
  ];

  NoAnimationPageRoute(
      {required WidgetBuilder builder, required RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (excludedRoutes.contains(settings.name)) {
      return child;
    }
    return super
        .buildTransitions(context, animation, secondaryAnimation, child);
  }
}
