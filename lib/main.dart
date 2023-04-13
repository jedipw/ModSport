import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:modsport/constants/routes.dart';
import 'package:modsport/utilities/page_route.dart';
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
            return ModSportPageRoute(
                builder: (_) => const LoginView(), settings: settings);
          case detailRoute:
            return ModSportPageRoute(
                builder: (_) => const DetailView(), settings: settings);
          case disableRoute:
            return ModSportPageRoute(
                builder: (_) => const DisableView(), settings: settings);
          case homeRoute:
            return ModSportPageRoute(
                builder: (_) => const HomeView(), settings: settings);
          case reservationRoute:
            return ModSportPageRoute(
                builder: (_) => const ReservationView(), settings: settings);
          case statusRoute:
            return ModSportPageRoute(
                builder: (_) => const StatusView(), settings: settings);
          case helpCenterRoute:
            return ModSportPageRoute(
                builder: (_) => const HelpCenterView(), settings: settings);
          case menuRoute:
            return ModSportPageRoute(
                builder: (_) => const MenuView(), settings: settings);
          default:
            return null;
        }
      },
    );
  }
}
