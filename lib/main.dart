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
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: loginRoute,
      routes: {
        loginRoute: (context) => const LoginView(),
        detailRoute: (context) => const DetailView(),
        disableRoute: (context) => const DisableView(),
        homeRoute: (context) => const HomeView(),
        reservationRoute: (context) => const ReservationView(),
        statusRoute: (context) => const StatusView(),
        helpCenterRoute: (context) => const HelpCenterView(),
        menuRoute: (context) => const MenuView(),
      },
    );
  }
}
