import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:modsport/constants/routes.dart';
import 'package:modsport/views/login_view.dart';
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
        
      },
    );
  }
}
