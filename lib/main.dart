import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

// Importing route constants and custom page route transitions
import 'package:modsport/constants/routes.dart';
import 'package:modsport/services/notifi_service.dart';
import 'package:modsport/utilities/page_route.dart';
import 'package:modsport/views/change_password_view.dart';
import 'package:modsport/views/forget_password_view.dart';

// Importing the views/screens used in the app
import 'package:modsport/views/help_center_view.dart';
import 'package:modsport/views/home_view.dart';
import 'package:modsport/views/login_view.dart';
import 'package:modsport/views/register_view.dart';
import 'package:modsport/views/status_view.dart';
import 'package:modsport/views/verify_email_view.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
// Importing Firebase options
import 'firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    NotificationService().showNotification(
        title: message.notification!.title, body: message.notification!.body);
  });

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  NotificationService().initNotification();
  runApp(const MainApp());
  // Running the app
}

// MainApp widget that builds the app
class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late final TextEditingController email;
  late final TextEditingController password;
  @override
  void initState() {
    email = TextEditingController();
    password = TextEditingController();
    super.initState();

    Future.delayed(const Duration(seconds: 1))
        .then((value) => {FlutterNativeSplash.remove()});
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

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

          // Routing for the RegisterView screen
          case registerRoute:
            return ModSportPageRoute(
                builder: (_) => const RegisterView(), settings: settings);

          // Routing for the ForgetPasswordView screen
          case forgetPasswordRoute:
            return ModSportPageRoute(
                builder: (_) => const ForgetPasswordView(), settings: settings);

          // Routing for the VerifyEmailView screen
          case verifyEmailRoute:
            return ModSportPageRoute(
                builder: (_) => const VerifyEmailView(), settings: settings);

          case changePasswordRoute:
            return ModSportPageRoute(
                builder: (_) => const ChangePasswordView(), settings: settings);

          // Return null for any unknown routes
          default:
            return null;
        }
      },
    );
  }
}
