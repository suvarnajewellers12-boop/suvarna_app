import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'core/notification_service.dart';
import 'screens/splash_screen.dart';
import 'screens/auth_choice_screen.dart';
import 'features/auth/presentation/signup_form_screen.dart';
import 'features/auth/presentation/otp_verification_screen.dart';
import 'features/schemes/presentation/schemes_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,  // ← ADD
  );

  // Initialize notifications
  await NotificationService.initialize();

  runApp(const SuvarnaApp());
}

class SuvarnaApp extends StatelessWidget {
  const SuvarnaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Suvarna Jewellers',
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/auth': (context) => const AuthChoiceScreen(),
        '/signup': (context) => const SignUpFormScreen(),
        '/schemes': (context) => const SchemesScreen(),
      },
    );
  }
}