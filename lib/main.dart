import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

// Importing route constants and custom page route transitions
import 'package:modsport/constants/routes.dart';
import 'package:modsport/utilities/page_route.dart';

// Importing the views/screens used in the app
import 'package:modsport/views/help_center_view.dart';
import 'package:modsport/views/home_view.dart';
import 'package:modsport/views/login_view.dart';
import 'package:modsport/views/status_view.dart';

// Importing Firebase options
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Running the app
  runApp(const MainApp());
}

// MainApp widget that builds the app
class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Setting the initial route for the app
      initialRoute: loginRoute,

      // Generating routes for each screen/view in the app
      onGenerateRoute: (settings) {
        switch (settings.name) {
          // Routing for the LoginView screen
          case loginRoute:
            return ModSportPageRoute(
                builder: (_) => const LoginView(), settings: settings);

          // Routing for the HomeView screen
          case homeRoute:
            return ModSportPageRoute(
                builder: (_) => const HomeView(), settings: settings);

          // Routing for the StatusView screen
          case statusRoute:
            return ModSportPageRoute(
                builder: (_) => const StatusView(), settings: settings);

          // Routing for the HelpCenterView screen
          case helpCenterRoute:
            return ModSportPageRoute(
                builder: (_) => const HelpCenterView(), settings: settings);


          // Return null for any unknown routes
          default:
            return null;
        }
      },
    );
  }
}
